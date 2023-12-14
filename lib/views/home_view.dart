import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/models/button_model.dart';
import 'package:laser_slides/viewmodel/home_view_model.dart';
import 'package:laser_slides/widgets/custom_button_widget.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel _viewModel = Get.put(HomeViewModel());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/home.jpg',
            fit: BoxFit.cover,
          ),
          FutureBuilder<void>(
            future: _viewModel.getAllButtonData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong!"),
                );
              } else {
                return Obx(() {
                  final buttons = _viewModel.buttons;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              buildButtonRow(context, buttons, [1, 2, 3], 10.0),
                              const SizedBox(height: 20.0),
                              buildButtonRow(context, buttons, [4, 5, 6], 10.0),
                              const SizedBox(height: 20.0),
                              buildButtonRow(context, buttons, [7, 8, 9], 10.0),
                              const SizedBox(height: 20.0),
                              buildButtonRow(
                                  context, buttons, [10, 11, 12], 10.0),
                              const SizedBox(height: 20.0),
                              buildButtonRow(
                                  context, buttons, [13, 14, 15], 10.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, List<ButtonModel> buttons,
      List<int> ids, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons
          .where((button) => ids.contains(button.id))
          .expand((button) => [
                buildCustomButton(button),
                SizedBox(width: spacing),
              ])
          .toList(),
    );
  }

  Widget buildCustomButton(ButtonModel button) {
    return CustomButtonWidget(
      text: button.buttonName,
      backgroundColor: Colors.blue,
      onPressed: () {
        _viewModel.sendCommand(button);
      },
    );
  }
}
