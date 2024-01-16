import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/viewmodel/navigation_view_model.dart';
import 'package:laser_slides/views/navigation_view.dart';

class CustomNavigationWidget extends StatelessWidget {
  final int index;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const CustomNavigationWidget({
    required this.index,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final NavigationViewModel controller = Get.find();

    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          final isSelected = controller.selectedIcon.value == index;
          return Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: isSelected ? Colors.white.withOpacity(0.5) : color,
                width: 2,
              ),
              color: isSelected ? color : Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.7),
                  offset: Offset(-3, -3),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.teal.withOpacity(0.7),
                  offset: Offset(-3, -3),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 40,
              ),
            ),
          );
        }),
      ),
    );
  }
}
