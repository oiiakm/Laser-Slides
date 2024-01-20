import 'dart:math';
import 'package:flutter/material.dart';

class CustomStarWidget extends StatelessWidget {
  final double size;
  final Color color;

  const CustomStarWidget({Key? key, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(color),
      size: Size(size, size),
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    const double angle = pi / 5;

    final Path path = Path();

    for (int i = 0; i < 5; i++) {
      // we calculate the outer point coordinates using polar coordinates formula:
      double x = centerX + radius * cos(i * 2 * angle);
      double y = centerY + radius * sin(i * 2 * angle);

      if (i == 0) {
        // to move the "pen" to the first outer point
        path.moveTo(x, y);
      } else {
        // to draw a line to the outer point.
        path.lineTo(x, y);
      }
//  calculate the coordinates for the inner point
      x = centerX + radius / 2 * cos((i * 2 + 1) * angle);
      y = centerY + radius / 2 * sin((i * 2 + 1) * angle);

// again to draw a line to the inner point.
      path.lineTo(x, y);
    }
    
// After the loop, path.close() is called, 
//connecting the last inner point to the first outer point, closing the shape.
    path.close();

    // is used to actually draw the shape on the canvas.
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
