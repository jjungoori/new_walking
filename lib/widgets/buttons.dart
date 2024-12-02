import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/busDataController.dart';

import '../datas.dart';

class MyTextButton extends StatelessWidget {

  VoidCallback onPressed;
  String text;
  Color color;

  MyTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
        onPressed: onPressed,
        child: Center(
            child: Text(text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                )
            )
        ),
      color: color,
    );
  }
}


class MyButton extends StatelessWidget {
  VoidCallback onPressed;
  Widget child;
  Color color;


  final borderRadius = DefaultDatas.borderRadius;

  MyButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // radius: radius,
      onTap: onPressed,
      borderRadius: borderRadius,
      splashColor: ColorDatas.splashColor,
      child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius
          ),
          child: child
      ),
    );
  }
}

class MyRootButton extends StatelessWidget {

  String root;

  MyRootButton({
    super.key,
    required this.root,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
        onPressed: (){
          Get.toNamed(root);
        },
        child: Center(
            child: Text(root,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                )
            )
        ),
      color: ColorDatas.button,
    );
  }
}

class MySquareButton extends StatelessWidget {
  Color color;
  String title;
  String description;

  MySquareButton({
    super.key,
    required this.title,
    required this.description,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: MyButton(
          onPressed: (){},
          child: Padding(
            padding: DefaultDatas.buttonPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextDatas.title.copyWith(
                      color: ColorDatas.onPrimaryTitle
                    )
                ),
                Text(description,
                    style: TextDatas.description.copyWith(
                      color: ColorDatas.onPrimaryDescription
                    )
                ),
              ],
            ),
          ),
          color: ColorDatas.button,
      ),
    );
  }
}

class MyAnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;

  MyAnimatedButton({
    required this.onPressed,
    required this.child,
    required this.color,
    this.gradient,
    this.shadows,
  });

  @override
  _MyAnimatedButtonState createState() => _MyAnimatedButtonState();
}

class _MyAnimatedButtonState extends State<MyAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleDownAnimation;
  late Animation<double> _scaleUpAnimation;
  bool reverse = false;

  @override
  void initState() {
    super.initState();

    double targetSize = 0.9; // 버튼이 작아지는 정도
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleDownAnimation = Tween<double>(begin: 1.0, end: targetSize).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc),
    );

    _scaleUpAnimation = Tween<double>(begin: targetSize, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (mounted) {
      reverse = false;
      _controller.forward(from: 0.0); // 애니메이션을 처음부터 시작
    }
  }

  void _onTapCancel() {
    if (mounted) {
      Future.delayed(Duration(milliseconds: 30), () {
        if (mounted) { // mounted 상태를 다시 확인
          reverse = true;
          _controller.forward(from: 0.0);
        }
      });
    }
  }

  void _onTapUp() {
    if (mounted) {
      Future.delayed(Duration(milliseconds: 30), () {
        if (mounted) { // mounted 상태를 다시 확인
          reverse = true;
          _controller.forward(from: 0.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: !reverse ? _scaleDownAnimation.value : _scaleUpAnimation.value,
            child: ClipRRect(
              borderRadius: DefaultDatas.borderRadius,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  onTapDown: _onTapDown,
                  onTapUp: (details) => _onTapUp(),
                  onTapCancel: _onTapCancel,
                  borderRadius: DefaultDatas.borderRadius,
                  splashColor: ColorDatas.splashColor,
                  child: Ink(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.color,
                      gradient: widget.gradient,
                      borderRadius: DefaultDatas.borderRadius,
                      boxShadow: widget.shadows,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class MyAnimatedSquareButton extends StatelessWidget {
  Color color;
  String title;
  String description;
  List<BoxShadow>? shadows;
  Color titleColor;
  Color descriptionColor;

  MyAnimatedSquareButton({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.titleColor,
    required this.descriptionColor,
    this.shadows
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: MyAnimatedButton(
        onPressed: (){},
        child: Padding(
          padding: DefaultDatas.buttonPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextDatas.title.copyWith(
                      color: titleColor,
                      fontSize: 24
                  )
              ),
              Text(description,
                  style: TextDatas.description.copyWith(
                      color: descriptionColor,
                      fontSize: 16
                  )
              ),
            ],
          ),
        ),
        color: color,
        shadows: shadows,
      ),
    );
  }
}

class MyAnimatedAddButton extends StatelessWidget {

  final bool only;

  MyAnimatedAddButton({
    super.key,
    this.only = false
  });

  @override
  Widget build(BuildContext context) {
    return MyAnimatedButton(
      onPressed: (){
        BusDataController.to.addBusData(MyBusData(name: "Capybara"));
      },
      child: Padding(
        padding: DefaultDatas.buttonPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset("assets/images/plusIcon.png",
                color: only ? ColorDatas.onPrimaryTitle : ColorDatas.onBackgroundSoft,
              ),
              width: 24,
              height: 24,
            ),
            SizedBox(width: 18,),
            Text("버스 추가하기",
                style: TextDatas.description.copyWith(
                    color: only ? ColorDatas.onPrimaryTitle : ColorDatas.onBackgroundSoft,
                )
            )
          ],
        ),
      ),
      color: only ? ColorDatas.secondary : Colors.transparent,
    );
  }
}


class MyAnimatedBusButton extends StatelessWidget {
  String title;
  MyAnimatedBusButton({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: MyAnimatedButton(
        onPressed: (){},
        child: Padding(
          padding: DefaultDatas.buttonPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   child: Image.asset("assets/images/plusIcon.png"),
              //   width: 24,
              //   height: 24,
              // ),
              // SizedBox(width: 18,),
              Text(title,
                  style: TextDatas.description.copyWith(
                      color: ColorDatas.onPrimaryTitle,
                  )
              )
            ],
          ),
        ),
        color: Colors.white,
        gradient: LinearGradient(
          colors: [
            ColorDatas.primary,
            ColorDatas.secondary
          ],
          end: Alignment.topLeft,
          begin: Alignment.bottomRight
        ),
      ),
    );
  }
}
