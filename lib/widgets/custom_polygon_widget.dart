import 'package:flutter/material.dart';

class CustomCircleWidget extends StatelessWidget {
  final double size;
  final Color color;

  const CustomCircleWidget({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(color),
      size: Size(size, size),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;

  CirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }


// Indicates whether the painting logic needs to be repainted.
// In this case, it always returns false, 
// implying that the painting does not depend on any external changes and does not need to be repainted.
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
