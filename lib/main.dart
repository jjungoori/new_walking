import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/busDataController.dart';
import 'package:new_walking/pages/busSelectionPage.dart';
import 'package:new_walking/pages/homePage.dart';
import 'package:new_walking/pages/loginPage.dart';
import 'package:new_walking/pages/splashPage.dart';
import 'package:new_walking/pages/widgetsPage.dart';
import 'package:new_walking/root.dart';

void main() {
  Get.put(BusDataController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Pull ups",
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => RootPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/widgets', page: () => WidgetsPage()),
        GetPage(name: '/splash', page: () => SplashPage()),
        GetPage(name: '/busSelection', page: () => BusSelectionPage()),
        GetPage(name: '/login', page: () => LoginPage()),
      ],
    );
  }
}