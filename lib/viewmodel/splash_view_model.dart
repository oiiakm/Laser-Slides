import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController with GetTickerProviderStateMixin {
  late AnimationController _animationController;//for main splash screen
  late AnimationController _laserAnimationController;
  late AnimationController textAnimationController;
  late List<Offset> laserPositions;
  late List<Color> laserColors;

  AnimationController get animationController => _animationController;

  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _laserAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      value: 0.0,
    );

    laserPositions = List.generate(20, (_) => _randomLaserPosition());
    laserColors = List.generate(20, (_) => _randomLaserColor());

    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    _laserAnimationController.dispose();
    textAnimationController.dispose();
    super.onClose();
  }

//to start animation
  void startAnimations() {
    _animationController.repeat(reverse: true);
    _laserAnimationController.repeat(
      reverse: true,
      period: const Duration(seconds: 30),
    );

    textAnimationController.forward();
    _laserAnimationController.addListener(() {
      laserPositions = List.generate(20, (_) => _randomLaserPosition());
      laserColors = List.generate(20, (_) => _randomLaserColor());
      update();
    });
  }

// generate random position for laser
  Offset _randomLaserPosition() {
    return Offset(
      Random().nextDouble() * Get.width,
      Random().nextDouble() * Get.height,
    );
  }

//generate random color for laser
  Color _randomLaserColor() {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1.0,
    );
  }
}
