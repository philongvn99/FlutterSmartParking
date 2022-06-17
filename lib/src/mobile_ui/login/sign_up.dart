import 'dart:convert';
import 'package:http/http.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:smartparkingapp/secure/api_path.dart';
import 'package:smartparkingapp/src/navigation/routes.dart';
import 'package:smartparkingapp/src/navigation/navigation_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const String id = 'SignUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscure = true;

  // Input Field Controller
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final cfPassword = TextEditingController();
  final phone = TextEditingController();
  final license = TextEditingController();
  final client = Client();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.grey.shade400,
              Colors.grey,
              Colors.grey.shade400,
            ])),
        child: Column(
          children: [
            /// Welcome
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 30, right: 20),
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                child: const Text(
                  'Join with us!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Caveat'),
                ),
                onPressed: () {
                  GetIt.I
                      .get<NavigationService>()
                      .to(routeName: MobileRoutes.login);
                },
              ),
              margin: const EdgeInsets.only(top: 25.0),
            ),

            /// The rest
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  color: Colors.blueGrey,
                ),
                padding: const EdgeInsets.only(top: 40, right: 15, left: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Text Fields
                      Container(
                        constraints: const BoxConstraints(
                          maxHeight: double.infinity,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10))
                            ]),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              // Email
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      if (value.length < 6) {
                                        return 'Too short';
                                      }
                                      if (!EmailValidator.validate(value)) {
                                        return 'You should enter valid Email';
                                      }
                                      return null;
                                    },
                                    controller: email,
                                    style: const TextStyle(fontSize: 15),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
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
                                            fontSize: 15,
                                            color: Colors.black54)),
                                  )),
                              // Username
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      if (value.length < 6) {
                                        return 'Too short';
                                      }
                                      return null;
                                    },
                                    controller: username,
                                    style: const TextStyle(fontSize: 15),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey, width: 5),
                                        ),
                                        border: OutlineInputBorder(),
                                        hintText: 'PeterParker',
                                        labelStyle:
                                            TextStyle(color: Colors.blueGrey),
                                        labelText: 'Username',
                                        isCollapsed: false,
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54)),
                                  )),
                              // Phone Number
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      if (value.length < 6) {
                                        return 'Too short';
                                      }
                                      return null;
                                    },
                                    controller: phone,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: const TextStyle(fontSize: 15),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey, width: 5),
                                        ),
                                        border: OutlineInputBorder(),
                                        hintText: '0xxxxxxxxx',
                                        labelStyle:
                                            TextStyle(color: Colors.blueGrey),
                                        labelText: 'Phone Number',
                                        isCollapsed: false,
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54)),
                                  )),
                              // Password
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      if (value.length < 6) {
                                        return 'Too short';
                                      }
                                      return null;
                                    },
                                    controller: password,
                                    obscureText: _isObscure,
                                    style: const TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 5),
                                      ),
                                      border: const OutlineInputBorder(),
                                      labelStyle: const TextStyle(
                                          color: Colors.blueGrey),
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
                              // Re-enter Password
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      if (value.length < 6) {
                                        return 'Too short';
                                      }
                                      if (value != password.text) {
                                        return 'The re-entered is not match';
                                      }
                                      return null;
                                    },
                                    controller: cfPassword,
                                    obscureText: _isObscure,
                                    style: const TextStyle(fontSize: 15),
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 5),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelStyle:
                                          TextStyle(color: Colors.blueGrey),
                                      labelText: 'Password',
                                      hintText: 'Password',
                                      isCollapsed: false,
                                      hintStyle: TextStyle(
                                          fontSize: 15, color: Colors.black54),
                                    ),
                                  )),
                              // License Plate
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Can\'t be empty';
                                      }
                                      if (value.length < 6) {
                                        return 'Too short';
                                      }
                                      if (!RegExp(
                                              r"([0-9]){2}[A-Z]{1,2}[0-9]*-[0-9]{4,5}$")
                                          //([0-9]){2}[A-Z]{1,2}[0-9]*-[0-9]{3}(.[0-9])*[0-9]
                                          .hasMatch(value)) {
                                        return 'You should enter valid Vietnamese License Plate';
                                      }
                                      return null;
                                    },
                                    controller: license,
                                    style: const TextStyle(fontSize: 15),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey, width: 5),
                                        ),
                                        border: OutlineInputBorder(),
                                        hintText: '64B2-00298',
                                        labelStyle:
                                            TextStyle(color: Colors.blueGrey),
                                        labelText: 'License Plate Number',
                                        isCollapsed: false,
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54)),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// Sign Up
                      MaterialButton(
                        shape: const StadiumBorder(),
                        minWidth: 230,
                        height: 45,
                        color: const Color(0xff616161),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (password.text != cfPassword.text) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                        scrollable: true,
                                        title: Text('Phone Authentication'),
                                        content: Text(
                                            'Re-entered Password is not match'));
                                  });
                            } else {
                              final response =
                                  await client.post(Uri.parse(signup_path),
                                      headers: {
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, String>{
                                        "password": password.text,
                                        "email": email.text,
                                        "username": username.text,
                                        "phone": phone.text,
                                        "carPlateNumber": license.text
                                      }),
                                      encoding: Encoding.getByName("utf-8"));
                              if (response.statusCode == 201) {
                                // If the server did return a 201 CREATED response,
                                // then parse the JSON.
                                GetIt.I
                                    .get<NavigationService>()
                                    .to(routeName: MobileRoutes.login);
                              } else {
                                // If the server did not return a 201 CREATED response,
                                // then throw an exception.
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text('Login Failed'),
                                      content: Text(jsonDecode(
                                          response.body)['error_message']),
                                    );
                                  },
                                );
                              }
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 45),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
