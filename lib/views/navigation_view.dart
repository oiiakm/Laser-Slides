import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/widgets/custom_navigation_widget.dart';
import 'package:laser_slides/viewmodel/navigation_view_model.dart';

class NavigationView extends StatelessWidget {
  final NavigationViewModel _controller = Get.put(NavigationViewModel());

  NavigationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Colors.green, Colors.teal],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomNavigationWidget(
                  index: 0,
                  icon: Icons.home,
                  onTap: () => _controller.changeView(0),
                  color: Colors.red,
                ),
                CustomNavigationWidget(
                  index: 1,
                  icon: Icons.sync_alt,
                  onTap: () => _controller.changeView(1),
                  color:  Colors.brown,
                ),
                CustomNavigationWidget(
                  index: 2,
                  icon: Icons.settings,
                  onTap: () => _controller.changeView(2),
                  color: Colors.orange,
                ),
                CustomNavigationWidget(
                  index: 3,
                  icon: Icons.question_mark,
                  onTap: () => _controller.changeView(3),
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => _controller.currentView.value),
          ),
        ],
      ),
    );
  }
}
