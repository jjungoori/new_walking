import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/authController.dart';
import 'package:new_walking/Controllers/userDataController.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:new_walking/datas.dart';
import 'package:new_walking/widgets/animations.dart';
import '../datas.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: DefaultDatas.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyOpacityRisingWidget(
              child: Text(
                '오신 것을 환영해요!',
                style: TextDatas.splashTitle,
              ),
              startTime: 2000,
              onEnd: () async{
                while(AuthViewModel.to.isLoading.value){
                  await Future.delayed(Duration(milliseconds: 100));
                }
                if (AuthViewModel.to.isLoggedIn.value) {
                  while(UserDataController.to.isLoading.value){
                    await Future.delayed(Duration(milliseconds: 100));
                  }
                  Get.offAllNamed('/busSelection');
                }
                else{
                  Get.offAllNamed('/login');
                }
              },
            ),
            Center(
              child:const MyLogoAnim(),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}

class MyLogoAnim extends StatefulWidget {
  const MyLogoAnim({super.key});

  @override
  State<MyLogoAnim> createState() => _MyLogoAnimState();
}

class _MyLogoAnimState extends State<MyLogoAnim> {
  Artboard? _riveArtboard;
  RiveFile? file;

  Future<void> preload() async{
    await rootBundle.load('assets/videos/logoAnim.riv').then(
          (data) async {
            file = RiveFile.import(data);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if(file == null){
      preload().then((value) {
        final artboard = file!.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
        }
        setState(() => _riveArtboard = artboard);
      });
    }
    else{
      final artboard = file!.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
      }
      setState(() => _riveArtboard = artboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: _riveArtboard == null
          ? const SizedBox() // 로딩 중 상태를 보여줌
          : Rive(
        artboard: _riveArtboard!,
      ),
    );
  }
}


