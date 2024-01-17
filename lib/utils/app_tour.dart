import 'package:feature_introduction/introduction_card.dart';
import 'package:feature_introduction/introduction_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/views/navigation_view.dart';

class AppTour extends StatelessWidget {
  final List<IndroductionCard> list = [
    IndroductionCard(
      imageUrl: 'assets/home.gif',
      imageHeight: Get.height * 0.8,
      imageWidth: Get.width * 0.8,
    ),
    IndroductionCard(
      imageUrl: 'assets/network.gif',
      imageHeight: Get.height * 0.8,
      imageWidth: Get.width * 0.8,
    ),
  ];

  AppTour({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IntroductionOnboarding(
          introductionCardList: list,
          onTapSkipButton: () {
            Get.off(() => NavigationView());
          },
          skipTextStyle: const TextStyle(
            color: Color.fromARGB(255, 207, 32, 32),
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
