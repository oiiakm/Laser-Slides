import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/models/button_model.dart';
import 'package:laser_slides/widgets/custom_master_commands_button.dart';
import 'package:laser_slides/widgets/custom_star_widget.dart';
import 'package:laser_slides/viewmodel/commands_view_model.dart';

class MasterCommandsView extends StatelessWidget {
  final CommandsViewModel _viewModel = Get.put(CommandsViewModel());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MasterCommandsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2B3E5A),
              Color(0xFF415D87),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildBackgroundStars(),
            Align(
              alignment: Alignment.center,
              child: FutureBuilder<void>(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildButtonRow(context, buttons, [10]),
                                  const SizedBox(height: 40),
                                  _buildButtonRow(context, buttons, [11, 12]),
                                  const SizedBox(height: 40),
                                  _buildButtonRow(
                                      context, buttons, [13, 14, 15]),
                                  const SizedBox(height: 40),
                                  _buildButtonRow(context, buttons, [16, 17]),
                                  const SizedBox(height: 40),
                                  _buildButtonRow(context, buttons, [18]),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(ButtonModel button) {
    return CustomButton(
      buttonName: button.buttonName,
      buttonId: button.id,
      path: button.buttonPressed,
      backgroundColor: Colors.blue,
      onPressed: () {
        _viewModel.getOSCParameters(button);
      },
      onEditPressed: () {
        _viewModel.showEditDialog(scaffoldKey.currentContext!, button);

        print(button.buttonName);
        print(button.id);
      },
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(27, 38, 44, 1),
            Color.fromRGBO(72, 87, 104, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 0.7],
        ),
      ),
    );
  }

  Widget _buildBackgroundStars() {
    return Stack(
      children: List.generate(
        180,
        (index) => Positioned(
          left: getRandomPosition(),
          top: getRandomPosition(),
          child: CustomStarWidget(
            size: Random().nextInt(30).toDouble() + 10,
            color: getRandomColor(),
          ),
        ),
      ),
    );
  }

  double getRandomPosition() {
    return Random().nextDouble() * Get.width;
  }

  Color getRandomColor() {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextDouble(), //for transparency
    );
  }

  Widget _buildButtonRow(
      BuildContext context, List<ButtonModel> buttons, List<int> ids) {
    List<Widget> buttonWidgets = [];

    for (int i = 0; i < ids.length; i++) {
      int id = ids[i];
      ButtonModel button = buttons.firstWhere((button) => button.id == id);

      buttonWidgets.add(_buildCustomButton(button));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttonWidgets,
    );
  }
}
