import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_walking/datas.dart';


class MyMaskRisingWidget extends StatefulWidget {
  final Widget child;
  final int startTime; // 애니메이션 시작 시간 (초 단위)
  final double height; // 위젯의 높이

  MyMaskRisingWidget({
    required this.child,
    required this.startTime,
    required this.height
  });

  @override
  _MyMaskRisingWidgetState createState() => _MyMaskRisingWidgetState();
}

class _MyMaskRisingWidgetState extends State<MyMaskRisingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late double _height;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 생성
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // 고정된 높이 설정
    _height = widget.height;

    // 위치 애니메이션 설정: 아래에서 위로 올라오는 애니메이션
    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 1), // 아래에서 시작
      end: Offset(0, 0),   // 제자리로 올라옴
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc),
    );

    // 딜레이 후 애니메이션 시작
    Future.delayed(Duration(seconds: widget.startTime), () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRect(
          child: Container(
            height: _height, // 높이를 고정하여 변경되지 않도록 설정
            // color: Colors.red,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 위젯이 올라오는 애니메이션
                Positioned(
                  bottom: -_height * _positionAnimation.value.dy, // 위치만 애니메이션
                  child: widget.child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class MyOpacityRisingWidget extends StatefulWidget {
  final int startTime; // 애니메이션 시작 시간 (초 단위)
  VoidCallback? onEnd;
  final Widget child;

  MyOpacityRisingWidget({
    required this.child,
    required this.startTime,
    this.onEnd
  });

  @override
  _MyOpacityRisingWidgetState createState() => _MyOpacityRisingWidgetState();
}

class _MyOpacityRisingWidgetState extends State<MyOpacityRisingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 생성
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // 애니메이션 설정
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc),
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc),
    );

    // 딜레이 후 애니메이션 시작
    Future.delayed(Duration(milliseconds: widget.startTime), () {
      _controller.forward().then((value){
        if(widget.onEnd != null) widget.onEnd!();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
              offset: _positionAnimation.value * 50, // 50픽셀만큼 이동
              child: widget.child
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
