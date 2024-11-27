import 'package:flutter/material.dart';
import 'package:new_walking/datas.dart';
import 'package:new_walking/pages/splashPage.dart';
import 'package:new_walking/widgets/animations.dart';
import 'package:new_walking/widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultDatas.appBar,
      body: SafeArea(
        child: Padding(
          padding: DefaultDatas.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: DefaultDatas.noRoundPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: OverflowBox(
                          maxWidth: 154,
                          maxHeight: 154,
                          child: MyLogoAnim(),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    MyOpacityRisingWidget(
                      child: Text("워킹 스쿨버스!",
                          style: TextDatas.title
                      ),
                      startTime: 300,
                    ),
                    SizedBox(height: 12),
                    MyOpacityRisingWidget(
                      child: Text("오신 것을 환영해요!\n아이들을 쉽게 관리하고,\n학부모님들과 소통할 수 있어요!",
                          style: TextDatas.description
                      ),
                      startTime: 500,
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              MyOpacityRisingWidget(
                startTime: 900,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: DefaultDatas.borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: ColorDatas.shadow,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      )
                    ].toList()
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: MyAnimatedButton(
                  onPressed: (){},
                  child: Center(
                    child: Padding(
                      padding: DefaultDatas.buttonPadding,
                      child: Text("지금 시작하기",
                          style: TextDatas.title.copyWith(
                              color: ColorDatas.onPrimaryContent,
                              fontSize: 16
                          )
                      ),
                    ),
                  ),
                  color: ColorDatas.secondary,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
