import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:smartparkingapp/src/mobile_ui/object/user.dart';

class YourParking extends StatefulWidget {
  final dynamic parkingStatus;
  final UserInfo user;
  const YourParking({Key? key, required this.parkingStatus, required this.user})
      : super(key: key);

  @override
  State<YourParking> createState() => MapSampleState();
}

TextStyle infoTextStyle(FontWeight weight) => TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: weight,
    );

class MapSampleState extends State<YourParking> {
  late var nonExist = widget.parkingStatus.fee == 0;
  final client = Client();

  @override
  Widget build(BuildContext context) {
    return widget.parkingStatus == null
        // If you havent booked any parking
        ? Container(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            width: double.infinity,
            child: Column(
                // Vertically center the widget inside the column
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('You have not book any parking')]))
        // If any parking has been booked by your account
        : Container(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: ListView(children: <Widget>[
              // Quotes
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Your 'Partner' is at",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Caveat'),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Parking Name
                    AspectRatio(
                        aspectRatio: 3.5,
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 4.0,
                                    style: BorderStyle.solid),
                                color: Colors.blueGrey.shade200),
                            child: ListTile(
                              leading: const Icon(Icons.branding_watermark),
                              title: Text('Parking Name :',
                                  style: infoTextStyle(FontWeight.bold)),
                              subtitle: Text(
                                  nonExist
                                      ? 'Not Available'
                                      : widget.parkingStatus.parkingName,
                                  style: infoTextStyle(FontWeight.normal)),
                            ))),
                    // Address
                    AspectRatio(
                        aspectRatio: 3.5,
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 4.0,
                                    style: BorderStyle.solid),
                                color: Colors.white),
                            child: ListTile(
                              leading: const Icon(Icons.location_on),
                              title: Text('Address :',
                                  style: infoTextStyle(FontWeight.bold)),
                              subtitle: Text(
                                  nonExist
                                      ? 'Not Available'
                                      : widget.parkingStatus.address,
                                  style: infoTextStyle(FontWeight.normal)),
                            ))),
                    // Lot
                    AspectRatio(
                        aspectRatio: 3.5,
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 4.0,
                                    style: BorderStyle.solid),
                                color: Colors.blueGrey.shade200),
                            child: ListTile(
                              leading: const Icon(Icons.crop_free),
                              title: Text('Lot:',
                                  style: infoTextStyle(FontWeight.bold)),
                              subtitle: Text(
                                  nonExist
                                      ? 'Not Available'
                                      : widget.parkingStatus.lot,
                                  style: infoTextStyle(FontWeight.normal)),
                            ))),
                    // License Plate
                    AspectRatio(
                        aspectRatio: 3.5,
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 4.0,
                                    style: BorderStyle.solid),
                                color: Colors.white),
                            child: ListTile(
                              leading: const Icon(Icons.onetwothree),
                              title: Text('License Plate: ',
                                  style: infoTextStyle(FontWeight.bold)),
                              subtitle: Text(
                                  nonExist
                                      ? 'Not Available'
                                      : widget.parkingStatus.license,
                                  style: infoTextStyle(FontWeight.normal)),
                            ))),
                    // Fee
                    AspectRatio(
                        aspectRatio: 3.5,
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 4.0,
                                    style: BorderStyle.solid),
                                color: Colors.blueGrey.shade200),
                            child: ListTile(
                                leading: const Icon(Icons.monetization_on),
                                title: Text(
                                  'Fee: ',
                                  style: infoTextStyle(FontWeight.bold),
                                ),
                                subtitle: Text(
                                    nonExist
                                        ? 'Not Available'
                                        : widget.parkingStatus.fee.toString(),
                                    style: infoTextStyle(FontWeight.normal))))),
                    // Charging Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(10)),
                          ),
                          child: const Text("Charge"),
                          onPressed: () async {
                            final response = await client.delete(
                                Uri.parse(
                                    'https://smartparking-thesis.herokuapp.com/api/bookings/charge'),
                                headers: {
                                  "Content-Type": "application/json",
                                  'Authorization':
                                      'Bearer ${widget.user.token}',
                                },
                                encoding: Encoding.getByName("utf-8"));
                            if (response.statusCode == 200) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    title: const Text('See you again!'),
                                    content: ListTile(
                                        leading: const Icon(
                                            Icons.attach_money_rounded),
                                        title: Text('Your Current Fee :',
                                            style:
                                                infoTextStyle(FontWeight.bold)),
                                        subtitle: Text(json
                                            .decode(response.body)["amount"]
                                            .toString())),
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    title: const Text('Error'),
                                    content: Text(jsonDecode(
                                        response.body)['error_message']),
                                  );
                                },
                              );
                            }
                            setState(() {
                              nonExist = true;
                            });
                          }),
                    )
                  ],
                ),
              )
            ]),
          );
  }
}
