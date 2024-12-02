import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:new_walking/Controllers/busDataController.dart';
import 'package:new_walking/pages/busSelectionPage.dart';
import 'package:new_walking/pages/homePage.dart';
import 'package:new_walking/pages/loginPage.dart';
import 'package:new_walking/pages/splashPage.dart';
import 'package:new_walking/pages/widgetsPage.dart';
import 'package:new_walking/root.dart';
import 'package:new_walking/Controllers/authController.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'a1c9777515879c04248d1ba76bfc85c0',
    javaScriptAppKey: 'e6ed79e07f29727292874a8bb2508dc4',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(BusDataController());
  Get.put(KakaoLoginController());
  print(await KakaoSdk.origin);
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