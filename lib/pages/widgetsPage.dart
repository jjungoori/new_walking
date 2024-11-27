import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:new_walking/datas.dart';
import 'package:new_walking/widgets/animations.dart';
import 'package:new_walking/widgets/buttons.dart';
import 'package:rive/rive.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyTextButton(
              onPressed: (){},
              text: "text",
              color: ColorDatas.button,
            ), //center widget -> expand 효과
            MyButton(
                onPressed: (){},
                child: Text("text"),
              color: ColorDatas.button,
            ),
            SizedBox(
              height: 200,
              child:
              MySquareButton(
                title: "title",
                description: "description",
                color: ColorDatas.button,
              ),
            ),
            MyAnimatedButton(
              child: Text("text"),
              color: ColorDatas.button,
              onPressed: (){},
            ),
            SizedBox(
              height: 200,
              child: MyAnimatedSquareButton(
                  titleColor: ColorDatas.onPrimaryTitle,
                  descriptionColor: ColorDatas.onPrimaryDescription,
                  title: "title",
                  description: "description",
                  color: ColorDatas.button
              )
            ),
            SizedBox(
              height: 200,
              child: MyAnimatedAddButton()
            ),
            MyAnimatedBusButton(
              title: "asdlfj",
            )

            // Lottie.asset(
            //   'assets/videos/logoAnim.json',
            //   width: 200,
            //   height: 200,
            //   fit: BoxFit.fill,
            //   repeat: false,
            //   options: LottieOptions(enableApplyingOpacityToLayers: true),
            // )
          ],
        ),
      ),
    );
  }
}
