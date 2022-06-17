import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../navigation/navigation_service.dart';
import '../../object/user.dart';
import 'package:smartparkingapp/src/navigation/routes.dart';

TextStyle infoTextStyle(FontWeight weight) => TextStyle(
      color: Colors.black,
      fontSize: 25,
      fontWeight: weight,
    );

class YourInfomation extends StatefulWidget {
  final UserInfo userInfo;
  const YourInfomation({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<YourInfomation> createState() => YourInfomationState();
}

class YourInfomationState extends State<YourInfomation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.blueGrey),
      child: ListView(children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Container(
                decoration: BoxDecoration(color: Colors.blueGrey.shade700),
                child: const Text(
                  "You are so cool !!!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Caveat'),
                ))),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AspectRatio(
                  aspectRatio: 3.0,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color(0xFF000000),
                              width: 4.0,
                              style: BorderStyle.solid),
                          color: Colors.blueGrey.shade200),
                      child: ListTile(
                        leading: const Icon(Icons.email),
                        title: Text('Email :',
                            style: infoTextStyle(FontWeight.bold)),
                        subtitle: Text(widget.userInfo.email,
                            style: infoTextStyle(FontWeight.normal)),
                      ))),
              AspectRatio(
                  aspectRatio: 3.0,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color(0xFF000000),
                              width: 4.0,
                              style: BorderStyle.solid),
                          color: Colors.white),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text('User :',
                            style: infoTextStyle(FontWeight.bold)),
                        subtitle: Text(widget.userInfo.username,
                            style: infoTextStyle(FontWeight.normal)),
                      ))),
              AspectRatio(
                  aspectRatio: 3.0,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color(0xFF000000),
                              width: 4.0,
                              style: BorderStyle.solid),
                          color: Colors.blueGrey.shade200),
                      child: ListTile(
                        leading: const Icon(Icons.phonelink_ring),
                        title: Text('Phone Number',
                            style: infoTextStyle(FontWeight.bold)),
                        subtitle: Text(widget.userInfo.phone,
                            style: infoTextStyle(FontWeight.normal)),
                      ))),
              AspectRatio(
                  aspectRatio: 3.0,
                  child: Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color(0xFF000000),
                              width: 4.0,
                              style: BorderStyle.solid),
                          color: Colors.blueGrey.shade200),
                      child: ListTile(
                        leading: const Icon(Icons.phonelink_ring),
                        title: Text('License Plate Number',
                            style: infoTextStyle(FontWeight.bold)),
                        subtitle: Text(widget.userInfo.license,
                            style: infoTextStyle(FontWeight.normal)),
                      ))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(10)),
              ),
              child: const Text("Log Out"),
              onPressed: () {
                GetIt.I
                    .get<NavigationService>()
                    .to(routeName: MobileRoutes.login);
              }),
        )
      ]),
    );
  }
}
