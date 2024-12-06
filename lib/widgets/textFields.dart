import 'package:flutter/material.dart';
import 'package:new_walking/datas.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? title;

  const MyTextField({
    Key? key,
    required this.hintText,
    this.title,
    this.controller,
    this.prefixIcon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward(); // 포커스 시 애니메이션 실행
      } else {
        _controller.reverse(); // 포커스 해제 시 애니메이션 되돌림
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
            child: Text(
              widget.title!,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ),
        Stack(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  obscureText: widget.isPassword,
                  cursorColor: ColorDatas.secondary,
                  cursorHeight: 24.0,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: widget.prefixIcon != null
                        ? Icon(widget.prefixIcon, color: Colors.grey[600])
                        : null,
                    filled: true,
                    fillColor: ColorDatas.onBackgroundSoft.withOpacity(Tween(
                      begin: 0.03,
                      end: 0.1,
                    ).animate(_animation).value),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 22.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    suffixIcon: widget.isPassword
                        ? Icon(Icons.visibility, color: Colors.grey[600])
                        : null,
                  ),
                  style: const TextStyle(fontSize: 16.0),
                );
              }
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _UnderlinePainter(
                      progress: _animation.value,
                      color: ColorDatas.secondary, // 언더라인 색상
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _UnderlinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final startX = size.width * (1 - progress) / 2;
    final endX = size.width * (1 + progress) / 2;

    canvas.drawLine(Offset(startX, 0), Offset(endX, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
