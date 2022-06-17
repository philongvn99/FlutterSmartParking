import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../navigation/navigation_service.dart';
import '../routes/routes.dart';

class PopUp extends StatefulWidget {
  final String title;
  const PopUp({Key? key, required this.title}) : super(key: key);
  static const String id = 'PopUp';

  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      title: const Text('Phone Authentication'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              const Text(
                'Enter the 4-digit code we have sent to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Caveat',
                ),
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: 'Caveat',
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                height: 70.h,
                width: size.width,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                decoration: BoxDecoration(
                  // color: Colors.purple,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    VerificationTextField(),
                    VerificationTextField(),
                    VerificationTextField(),
                    VerificationTextField(),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              const Text(
                "Haven't received any code?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  fontFamily: 'Caveat',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              GetIt.I.get<NavigationService>().to(routeName: MobileRoutes.home);
            })
      ],
    );
  }
}

class VerificationTextField extends StatelessWidget {
  const VerificationTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 0.15 * size.width,
      height: 0.2 * size.height,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset.zero,
          ),
        ],
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 28,
        ),
        decoration: InputDecoration(
          counterText: "",
        ),
      ),
    );
  }
}
