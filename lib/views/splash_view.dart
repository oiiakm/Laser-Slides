import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/viewmodel/splash_view_model.dart';

class SplashView extends StatelessWidget {
  final SplashViewModel backgroundController = Get.put(SplashViewModel());

  SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    backgroundController.startAnimations();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        Get.offNamed('/navigation_view');
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildBackground(),
          ),
          Center(
            child: AnimatedScaleTransition(
              animation: backgroundController.textAnimationController,
              child: _buildText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return GetBuilder<SplashViewModel>(
      builder: (controller) {
        return CustomPaint(
          painter: LaserPainter(
            laserPositions: controller.laserPositions,
            laserColors: controller.laserColors,
          ),
          child: Container(),
        );
      },
    );
  }

  Widget _buildText() {
    return GetBuilder<SplashViewModel>(
      builder: (controller) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.blue, Colors.white, Colors.blue],
              stops: [0.4, 0.5, 0.6],
            ).createShader(bounds);
          },
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Opacity(
              opacity: controller.textAnimationController.value,
              child: const Text(
                'Laser Slides',
                style: TextStyle(fontSize: 60, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedScaleTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const AnimatedScaleTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      ),
      child: child,
    );
  }
}

class LaserPainter extends CustomPainter {
  final List<Offset> laserPositions;
  final List<Color> laserColors;

  LaserPainter({
    required this.laserPositions,
    required this.laserColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeCap = StrokeCap.round;

    for (int i = 0; i < laserPositions.length; i++) {
      paint.color = laserColors[i];

      canvas.drawLine(
        laserPositions[i],
        Offset(laserPositions[i].dx, laserPositions[i].dy + 200),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
