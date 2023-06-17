import 'dart:math';

import 'package:flutter/material.dart';

class TestCliper extends StatelessWidget {
  const TestCliper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomPaint(
              painter: BlackHolePainter(),
              size: Size(double.infinity, 200.0), // Or any other size you want
            )
          ],
        ),
      ),
    );
  }
}

class BlackHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0,
      pi,
      true,
    );
    // path.lineTo(0, -1000);
    // path.lineTo(size.width, -1000);
    path.close();

    Paint borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.5) // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // Border width

    Paint mainPaint = Paint()
      ..color = Colors.blue // Main shape color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, borderPaint);
    // canvas.drawPath(path, mainPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
