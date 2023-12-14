import 'package:get/get.dart';

class ResponsiveUtils {
  double screenWidth = Get.width;
  static double calculateButtonWidth() {
    double screenWidth = Get.width;

    if (screenWidth > 600) {
      return screenWidth / 5;
    } else {
      return screenWidth / 4;
    }
  }

  static double calculateButtonHeight() {
    double screenWidth = Get.width;

    if (screenWidth > 600) {
      return screenWidth / 15;
    } else {
      return screenWidth / 7;
    }
  }

  static double calculateTextSize() {
    double screenWidth = Get.width;

    if (screenWidth > 600) {
      return screenWidth / 45;
    } else {
      return screenWidth / 27;
    }
  }

  static double calculateHeaderTextSize() {
    double screenWidth = Get.width;

    if (screenWidth > 600) {
      return screenWidth / 45;
    } else {
      return screenWidth / 25;
    }
  }

  static double calculateNetworkContainerWidth() {
    double screenWidth = Get.width;

    if (screenWidth > 600) {
      return screenWidth / 2.5;
    } else {
      return screenWidth / 1.2;
    }
  }

  static double calculateNetworkContainerHeight() {
    double screenHeight = Get.height;

    if (screenHeight > 600) {
      return screenHeight / 1.4;
    } else {
      return screenHeight / 0.8;
    }
  }
}
