import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartparkingapp/src/mobile_ui/login/log_in.dart';
import 'package:get_it/get_it.dart';
import 'src/di/service_locator.dart';
import 'src/navigation/navigation_service.dart';
import 'src/navigation/routes.dart';

void main() async {
  await ServiceLocator().setUp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "UI Kit",
        themeMode: ThemeMode.light,
        navigatorKey: GetIt.I.get<NavigationService>().navigatorKey,
        initialRoute: MobileRoutes.root,
        onGenerateRoute: routes,
        home: const LogIn(),
      ),
    );
  }
}
