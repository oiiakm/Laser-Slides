import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<String> emojis = [
    '👋',
    '🤝',
    '🙋‍♂️',
    '🙋‍♀️',
    '🤚',
    '🖐️',
    '🖖',
    '🤙',
    '🤗',
    '😊',
    '😃',
    '😎',
    '🥰',
    '🌞',
    '💫',
    '✨',
    '😀',
    '😄',
    '😁',
    '😆',
    '😅',
    '🤣',
    '😂',
    '🙂',
    '🙃',
    '😉',
    '😇',
    '😍',
    '🥰',
    '😘',
    '😗',
    '😚',
    '😋',
    '😜',
    '😝',
    '😛',
    '🤑',
    '🤗',
    '🤓',
    '😎',
  ];

  late String currentEmoji = '';
  late RxString greetingMessage;
  late RxString typingText;
  int currentTextIndex = 0;
  late Timer greetingTimer;
  late Timer emojiTimer;
  late Timer typingTimer;
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    currentEmoji = _getRandomEmoji();
    greetingMessage = ''.obs;
    typingText = ''.obs;

// for animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
          animationController.forward();
        }
      });
    animationController.forward();

    _updateGreetingMessage();

    greetingTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _updateGreetingMessage();
    });

    emojiTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      currentEmoji = _getRandomEmoji();
      update(['currentEmoji']);
    });

    typingTimer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      _updateTypingAnimation();
    });
  }

  // Get a random emoji from the list
  String _getRandomEmoji() {
    return emojis[DateTime.now().second % emojis.length];
  }

  // Update the greeting message based on the current hour
  void _updateGreetingMessage() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      greetingMessage.value = 'Good Morning,';
    } else if (hour < 17) {
      greetingMessage.value = 'Good Afternoon,';
    } else {
      greetingMessage.value = 'Good Evening,';
    }
  }

  // Get a random curve for animation
  Curve getRandomCurve() {
    List<Curve> curves = [
      Curves.elasticOut,
      Curves.easeInOut,
      Curves.bounceOut,
    ];
    return curves[Random().nextInt(curves.length)];
  }

  // Update typing animation
  void _updateTypingAnimation() {
    if (currentTextIndex < greetingMessage.value.length) {
      typingText.value =
          greetingMessage.value.substring(0, currentTextIndex + 1);
      currentTextIndex++;
    } else {
      currentTextIndex = 0;
    }
  }

  @override
  void onClose() {
    greetingTimer.cancel();
    emojiTimer.cancel();
    typingTimer.cancel();
    animationController.dispose();
    super.onClose();
  }
}
