import 'package:get/get.dart';

class ResponsiveUtils {
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
