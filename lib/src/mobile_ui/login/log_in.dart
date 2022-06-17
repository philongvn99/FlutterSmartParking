// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'package:http/http.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smartparkingapp/secure/api_path.dart';
import 'package:smartparkingapp/src/res/asset_images.dart';
import 'package:smartparkingapp/src/navigation/routes.dart';
import 'package:smartparkingapp/src/navigation/navigation_service.dart';
import 'package:smartparkingapp/src/mobile_ui/homepage/homepage.dart';
import 'package:smartparkingapp/src/mobile_ui/object/user.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);
  static const String id = 'LogIn';

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isObscure = true;

  final email = TextEditingController();
  final password = TextEditingController();
  final client = Client();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        /// UI Background Color
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade400,
              Colors.grey,
              Colors.grey.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),

        child: Column(
          /// Align All Element Top Left as Default
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            const SizedBox(height: 40),

            /// BK LOGO
            Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Container(
                  height: 100,
                  width: 100,
                  // color: Colors.purple,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.HCMUT_LOGO),
                    ),
                  ),
                )),

            const SizedBox(height: 10),

            /// APP Name
            SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  /// LOGIN TEXT
                  Text('HCMUT\nSMART\nPARKING',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Caveat')),
                ],
              ),
            ),

            /// Interaction Area
            Expanded(
              flex: 3,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    /// Text Fields
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      constraints: const BoxConstraints(
                        maxHeight: double.infinity,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 10,
                                offset: const Offset(0, 10)),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// EMAIL
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: email,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey, width: 5),
                                    ),
                                    border: OutlineInputBorder(),
                                    hintText: 'Example@hostname.com',
                                    labelStyle:
                                        TextStyle(color: Colors.blueGrey),
                                    labelText: 'Email',
                                    isCollapsed: false,
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.black54)),
                              )),

                          /// PASSWORD
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: password,
                                obscureText: _isObscure,
                                style: const TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey, width: 5),
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelStyle:
                                      const TextStyle(color: Colors.blueGrey),
                                  labelText: 'Password',
                                  hintText: 'Password',
                                  isCollapsed: false,
                                  hintStyle: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                  suffixIcon: IconButton(
                                    color: Colors.black54,
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// LOGIN BUTTON
                    MaterialButton(
                      onPressed: () async {
                        final response = await client.post(
                            Uri.parse(login_path),
                            headers: {
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              "password": password.text,
                              "email": email.text
                            }),
                            encoding: Encoding.getByName("utf-8"));
                        if (response.statusCode == 200) {
                          // If the server did return a 201 CREATED response,
                          // then parse the JSON.
                          UserInfo user =
                              UserInfo.fromJson(jsonDecode(response.body));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(user: user),
                            ),
                          );
                        } else {
                          // If the server did not return a 201 CREATED response,
                          // then throw an exception.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Login Failed'),
                                content: Text(
                                    jsonDecode(response.body)['error_message']),
                              );
                            },
                          );
                        }
                      },
                      height: 45,
                      minWidth: 240,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      textColor: Colors.white,
                      color: Colors.green.shade700,
                      shape: const StadiumBorder(),
                    ),
                    const SizedBox(height: 20),

                    /// SIGN UP
                    RichText(
                        text: TextSpan(
                            text: " Don't have any account?",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                GetIt.I
                                    .get<NavigationService>()
                                    .to(routeName: MobileRoutes.signup);
                              })),

                    const SizedBox(height: 10),

                    /// Forgot Password
                    RichText(
                        text: TextSpan(
                            text: " Forgot password?",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                GetIt.I
                                    .get<NavigationService>()
                                    .to(routeName: MobileRoutes.password);
                              })),

                    const SizedBox(height: 15),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
