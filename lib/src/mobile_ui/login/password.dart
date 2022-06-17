import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:smartparkingapp/src/navigation/routes.dart';
import 'package:smartparkingapp/src/navigation/navigation_service.dart';
import 'package:smartparkingapp/src/mobile_ui/widget/pop_up.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  static const String id = 'ForgotPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                TextButton(
                  child: const Text(
                      'Please enter your email to select Authentication method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Caveat',
                        color: Colors.black,
                      )),
                  onPressed: () {
                    GetIt.I
                        .get<NavigationService>()
                        .to(routeName: MobileRoutes.login);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                const SizedBox(
                  height: 70,
                ),
                Card(
                  color: const Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: const [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey, width: 5),
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: 'Example@hostname.com',
                                  labelStyle: TextStyle(color: Colors.blueGrey),
                                  labelText: 'Email',
                                  isCollapsed: false,
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            // color: Colors.blue,
            height: size.height / 3.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const PopUp(title: "lolo");
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF161616),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    fixedSize: const Size(342, 54),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
