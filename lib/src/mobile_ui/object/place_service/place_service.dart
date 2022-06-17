import 'dart:convert';
import 'package:http/http.dart';
import 'package:smartparkingapp/secure/keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  String address;
  String name;
  LatLng geocoor;

  Place({
    this.address = '',
    this.geocoor = const LatLng(0, 0),
    this.name = '',
  });

  @override
  String toString() {
    return 'Place(address: $address, geocoor: ${geocoor.toString()}, name: $name)';
  }
}

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  final _apiKey = goongMapsApiKey;
  //Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    // (10.7733743, 106.6606193) is geometry of Ho Chi Minh University of Technology
    // You can modify it into your demand place's
    final request =
        'https://rsapi.goong.io/Place/AutoComplete?api_key=$_apiKey&location=10.7733743,%20106.6606193&input=$input&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://rsapi.goong.io/Place/Detail?place_id=$placeId&fields=formatted_address,geometry,name&api_key=$_apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final place = Place();
        place.address = result['result']['formatted_address'];
        place.geocoor = LatLng(result['result']['geometry']['location']['lat'],
            result['result']['geometry']['location']['lng']);
        place.name = result['result']['name'];
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<List<LatLng>> getDirection(LatLng ori, LatLng des) async {
    final request =
        'https://rsapi.goong.io/Direction?origin=${ori.latitude},${ori.longitude}&destination=${des.latitude},${des.longitude}&api_key=$_apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final encodedPolyline =
          result["routes"][0]["overview_polyline"]["points"];
      final polylines = decodeEncodedPolyline(encodedPolyline);
      return polylines;
    } else {
      throw Exception('Failed to fetch suggestion');
    }
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
}
