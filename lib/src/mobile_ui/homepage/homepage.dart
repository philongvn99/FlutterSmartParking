import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smartparkingapp/secure/api_path.dart';
import 'package:smartparkingapp/src/mobile_ui/object/parking.dart';
import 'package:smartparkingapp/src/mobile_ui/homepage/maps/maps.dart';
import 'package:smartparkingapp/src/mobile_ui/homepage/parking_info/parking_info.dart';
import 'package:smartparkingapp/src/mobile_ui/homepage/user_info/user_info.dart';
import '../object/user.dart';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.user}) : super(key: key);
  static const String id = 'Home page';

  final UserInfo user;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late int _currentIndex = 0;
  dynamic bodyWidget = Container();
  final client = Client();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyWidget.toString() == 'Container'
          ? Container(child: MyMaps(user: widget.user))
          : bodyWidget, // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Parking',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }

  Future<void> onTabTapped(int index) async {
    switch (index) {
      case 1:
        {
          final response = await client.get(Uri.parse(booking_path), headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${widget.user.token}',
          });
          if (response.statusCode == 200) {
            ParkingStatus parkingStatus =
                ParkingStatus.fromJson(jsonDecode(response.body));
            setState(() {
              bodyWidget =
                  YourParking(user: widget.user, parkingStatus: parkingStatus);
              _currentIndex = 1;
            });
          } else {
            setState(() {
              bodyWidget = YourParking(user: widget.user, parkingStatus: null);
              _currentIndex = 1;
            });
          }
        }
        break;
      case 2:
        {
          setState(() {
            bodyWidget = YourInfomation(userInfo: widget.user);
            _currentIndex = 2;
          });
        }
        break;
      default:
        {
          setState(() {
            bodyWidget = MyMaps(user: widget.user);
            _currentIndex = 0;
          });
        }
        break;
    }
  }
}
