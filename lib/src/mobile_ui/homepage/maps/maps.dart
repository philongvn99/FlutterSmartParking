import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartparkingapp/secure/api_path.dart';
import 'package:uuid/uuid.dart';
import '../../object/user.dart';
import '../../object/parking.dart';
import '../../object/place_service/address_search.dart';
import '../../object/place_service/place_service.dart';
import 'package:http/http.dart';

class MyMaps extends StatefulWidget {
  final UserInfo user;
  const MyMaps({Key? key, required this.user}) : super(key: key);
  static const String id = 'Home page';

  @override
  State<MyMaps> createState() => MapSampleState();
}

class MapSampleState extends State<MyMaps> {
  // API resquest client
  final client = Client();

  // Input Controller
  final license = TextEditingController();
  final block = TextEditingController();

  //Place Autocomplete States
  final Completer<GoogleMapController> _controller = Completer();
  final _locationController = TextEditingController();

  //  Selecting Parking Bar
  final LatLng _kBachKhoa = const LatLng(10.7733743, 106.6606193);
  Parking selectedParking = ParkingList[0];
  late List<Parking> _parkingList = ParkingList;
  late double radiusSearch = 0.0;

// Marker States
  late bool _isOrigin = true;
  late Marker _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'Origin'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: _kBachKhoa);
  late Marker _destination = const Marker(markerId: MarkerId('destination'));
  late Set<Marker> markerList = {_origin, _destination};

// Direction States
  late List<LatLng> _routingPoins = [];

// Geo location States
  var geoLocator = Geolocator();

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    setState(() => {
          _origin = Marker(
              markerId: const MarkerId('origin'),
              infoWindow: const InfoWindow(title: 'Origin'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
              position: latLatPosition)
        });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLatPosition, zoom: 15)));
  }

  Future<void> _goToParking(LatLng geo, double zoom) async {
    final GoogleMapController controller = await _controller.future;
    if (_origin.position != const LatLng(0.0, 0.0) &&
        _destination.position != const LatLng(0.0, 0.0)) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            (_origin.position.latitude + _destination.position.latitude) / 2.0,
            (_origin.position.longitude + _destination.position.longitude) /
                2.0),
        bearing: 12.8334901395799,
        zoom: 12.0,
      )));
      return;
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: geo,
      bearing: 12.8334901395799,
      zoom: zoom,
    )));
  }

  Future<void> _addMarker(LatLng pos) async {
    if (_isOrigin) {
      _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: pos);
      _undisplayParking();
    } else {
      _suggestParking(pos, 0.0002); //0.0015
    }
    _goToParking(pos, 15.0);
  }

  void _displayParking() {
    setState(() {
      markerList = Set<Marker>.of(ParkingList.map((p) => fromParking(p)));
    });
    _goToParking(_kBachKhoa, 12.0);
  }

  List<LatLng> decodeEncodedPolyline(String polylineStr) {
    int index = 0;
    double lat = 0.0;
    double lng = 0.0;
    List coords = [];
    Map changes = {'lat': 0.0, 'lng': 0.0};

    while (index < polylineStr.length) {
      for (int i = 0; i < 2; i++) {
        int shift = 0;
        int result = 0;

        while (true) {
          int byte = polylineStr.codeUnitAt(index) - 63;
          index += 1;
          result |= (byte & 0x1f) << shift;
          shift += 5;
          if (byte < 0x20) {
            break;
          }
        }
        if ((result & 1) == 1) {
          if (i == 0) {
            changes['lat'] = ~(result >> 1);
          } else {
            changes['lng'] = ~(result >> 1);
          }
        } else {
          if (i == 0) {
            changes['lat'] = (result >> 1);
          } else {
            changes['lng'] = (result >> 1);
          }
        }
      }

      lat += changes['lat'];
      lng += changes['lng'];

      coords.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return coords.cast<LatLng>();
  }

  void _undisplayParking() {
    setState(() {
      markerList = {_origin, _destination};
    });
  }

// Suggesting Parking Lots
  bool isNearDes(LatLng park, LatLng des, double radiusSqr) {
    return pow((park.latitude - des.latitude), 2) +
            pow((park.longitude - des.longitude), 2) <
        radiusSqr;
  }

  num distance(LatLng park, LatLng des) {
    return pow((park.latitude - des.latitude), 2) +
        pow((park.longitude - des.longitude), 2);
  }

  void _suggestParking(LatLng des, double radiusSqr) {
    var suggestedParkingList = List<Parking>.from(ParkingList.where(
        (parking) => isNearDes(parking.geocoor, des, radiusSqr)));
    if (suggestedParkingList.isEmpty) {
      suggestedParkingList = [
        ParkingList.reduce((nearest, parking) =>
            distance(nearest.geocoor, des) < distance(parking.geocoor, des)
                ? nearest
                : parking)
      ];
    }
    var newDestination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destionation'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: des);
    var newMarketList =
        Set<Marker>.of(suggestedParkingList.map((p) => fromParking(p)));
    newMarketList.addAll({_origin, newDestination});
    setState(() {
      _parkingList = suggestedParkingList;
      _destination = newDestination;
      markerList = newMarketList;
      selectedParking = suggestedParkingList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    license.text = widget.user.license;
    return Column(children: [
      //AUTOCOMPLETE SEARCHING BAR
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
          child: TextField(
            controller: _locationController,
            onTap: () async {
              // generate a new token herex
              final sessionToken = const Uuid().v4();
              final Suggestion? result = await showSearch(
                context: context,
                delegate: AddressSearch(sessionToken),
              );
              // This will change the text displayed in the TextField
              if (result != null) {
                final placeDetails = await PlaceApiProvider(sessionToken)
                    .getPlaceDetailFromId(result.placeId);
                _addMarker(placeDetails.geocoor);
              }
            },
            decoration: InputDecoration(
              icon: Container(
                margin: const EdgeInsets.only(left: 20),
                width: 10,
                height: 10,
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              hintText: "Enter your current address",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
              suffixIcon: TextButton(
                  onPressed: () => setState(() {
                        _isOrigin = !_isOrigin;
                      }),
                  child: Text(_isOrigin ? 'Origin' : 'Destination'),
                  style: TextButton.styleFrom(
                      primary: _isOrigin
                          ? Colors.orange.shade600
                          : Colors.yellow.shade600)),
            ),
          ),
        ),
      ),

      // GOOGLE MAPS
      Expanded(
        flex: 10,
        child: GoogleMap(
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: _kBachKhoa,
            bearing: 12.8334901395799,
            zoom: 15.0,
          ),
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: markerList,
          polylines: {
            if (_routingPoins != [])
              Polyline(
                polylineId: const PolylineId('Routing'),
                color: Colors.blue,
                width: 5,
                points: _routingPoins,
              )
          },
          onLongPress: _addMarker,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
        ),
      ),

      // SELECTING BAR
      Expanded(
          flex: 2,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 15),
                    child: DropdownButton<String>(
                      value: selectedParking.name,
                      elevation: 16,
                      style: const TextStyle(color: Colors.blueGrey),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) async {
                        var newParking = _parkingList
                            .where((i) => i.name == newValue)
                            .toList()[0];
                        _destination = Marker(
                            markerId: const MarkerId('destination'),
                            infoWindow: const InfoWindow(title: 'Destionation'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueYellow),
                            position: newParking.geocoor);
                        selectedParking = newParking;
                        final response = await client.get(
                            Uri.parse(parking_info_path + selectedParking.name),
                            headers: {
                              "Content-Type": "application/json",
                            });
                        if (response.statusCode == 200) {
                          // If the server did return a 201 CREATED response,
                          // then parse the JSON.
                          ParkingLotStatus parkingLotStatus =
                              ParkingLotStatus.fromJson(
                                  jsonDecode(response.body));
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text(selectedParking.name),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading:
                                              const Icon(Icons.location_on),
                                          title: const Text('Address :'),
                                          subtitle:
                                              Text(selectedParking.address()),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.timer),
                                          title: const Text('Day Price: '),
                                          subtitle: Text(
                                              '${parkingLotStatus.day} VND'),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.timer),
                                          title: const Text('Night Price: '),
                                          subtitle: Text(
                                              '${parkingLotStatus.night} VND'),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.crop_free),
                                          title:
                                              const Text('Available slots: '),
                                          subtitle: Text(
                                              parkingLotStatus.slot.toString()),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: license,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.blueGrey,
                                                        width: 5),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  labelStyle: TextStyle(
                                                      color: Colors.blueGrey),
                                                  labelText: 'License Plate',
                                                  isCollapsed: false,
                                                  hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black54)),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: block,
                                            style:
                                                const TextStyle(fontSize: 15),
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blueGrey,
                                                      width: 5),
                                                ),
                                                border: OutlineInputBorder(),
                                                hintText: 'A1',
                                                labelStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                                labelText: 'Block',
                                                isCollapsed: false,
                                                hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black54)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        child: const Text("Booking"),
                                        onPressed: () async {
                                          final response = await client.post(
                                              Uri.parse(booking_status_path),
                                              headers: {
                                                "Content-Type":
                                                    "application/json",
                                                'Authorization':
                                                    'Bearer ${widget.user.token}',
                                              },
                                              body: jsonEncode(<String, String>{
                                                "carPlateNumber": license.text,
                                                "blockName": block.text,
                                                "parkName":
                                                    selectedParking.name,
                                                "address":
                                                    selectedParking.address()
                                              }));
                                          var succ = response.statusCode == 200;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                scrollable: true,
                                                title: Text(succ
                                                    ? 'Booking Success'
                                                    : 'Booking Failed'),
                                                content: Text(succ
                                                    ? 'Welcome'
                                                    : jsonDecode(response.body)[
                                                        'error_message']),
                                              );
                                            },
                                          );
                                        })
                                  ],
                                );
                              });
                          final sessionToken = const Uuid().v4();
                          _routingPoins = await PlaceApiProvider(sessionToken)
                              .getDirection(
                                  _origin.position, newParking.geocoor);
                          _undisplayParking();
                          _goToParking(newParking.geocoor, 15.0);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Selecting Failed'),
                                content: Text(
                                    jsonDecode(response.body)['error_message']),
                              );
                            },
                          );
                        }
                      },
                      items: _parkingList
                          .map<DropdownMenuItem<String>>((Parking value) {
                        return DropdownMenuItem<String>(
                          value: value.name,
                          child: Text(value.name),
                        );
                      }).toList(),
                    ))),

            // SPEED DIAL BUTTON
            SpeedDial(
                //Speed dial menu
                icon: Icons.menu, //icon on Floating action button
                activeIcon: Icons.close, //icon when menu is expanded on button
                backgroundColor:
                    Colors.deepOrangeAccent, //background color of button
                foregroundColor:
                    Colors.black, //font color, icon color in button
                activeBackgroundColor: Colors
                    .deepPurpleAccent, //background color when menu is expanded
                activeForegroundColor: Colors.black,
                buttonSize: const Size(60, 60), //button size
                visible: true,
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                elevation: 8.0, //shadow elevation of button
                shape: const CircleBorder(), //shape of button

                children: [
                  SpeedDialChild(
                    //speed dial child
                    child: const Icon(Icons.directions_boat),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    label: 'To the BachKhoa!',
                    labelStyle: const TextStyle(fontSize: 18.0),
                    onTap: () => _goToParking(_kBachKhoa, 15.0),
                  ),
                  SpeedDialChild(
                    child: const Icon(
                      Icons.location_searching,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    label: 'Current Location',
                    labelStyle: const TextStyle(fontSize: 18.0),
                    onTap: () => _getLocation(),
                  ),
                  SpeedDialChild(
                    child: const Icon(
                      Icons.zoom_out_map_rounded,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    label: 'All Parking',
                    labelStyle: const TextStyle(fontSize: 18.0),
                    onTap: () => _displayParking(),
                    onLongPress: () => _undisplayParking(),
                  ),
                ])
          ])),
    ]);
  }
}
