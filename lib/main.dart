import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laser_slides/database.dart';
import 'package:laser_slides/routes/route_config.dart';
import 'package:laser_slides/routes/route_error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    DatabaseHelper().createButton();
    DatabaseHelper().createNetwokData();
    await prefs.setBool('isFirstTime', false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<DeviceOrientation> preferredOrientations = screenSize.width > 600
        ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        : [DeviceOrientation.portraitUp];

    SystemChrome.setPreferredOrientations(preferredOrientations);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      unknownRoute:
          GetPage(name: '/route_error', page: () => const RouteErrorView()),
      getPages: AppRoutes.pages,
    );
  }
}
