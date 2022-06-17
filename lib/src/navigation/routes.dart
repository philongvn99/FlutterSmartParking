import 'package:flutter/material.dart';
import 'package:smartparkingapp/src/mobile_ui/login/log_in.dart';
import 'package:smartparkingapp/src/mobile_ui/login/sign_up.dart';
import 'package:smartparkingapp/src/mobile_ui/login/password.dart';
import 'fade_route.dart';

class MobileRoutes {
  static const root = "login";
  static const login = "login";
  static const home = "homepage";
  static const signup = "signup";
  static const password = "password";
}

FadeRoute? routes(RouteSettings settings) {
  switch (settings.name) {
    case MobileRoutes.login:
      return FadeRoute(
        page: const LogIn(),
      );

    case MobileRoutes.signup:
      return FadeRoute(
        page: const SignUp(),
      );

    case MobileRoutes.password:
      return FadeRoute(
        page: const ForgotPassword(),
      );
  }
  return null;
}
