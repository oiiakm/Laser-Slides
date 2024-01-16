import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/viewmodel/cue_view_model.dart';
import 'package:laser_slides/widgets/custom_cue_button_widget.dart';
import 'package:laser_slides/widgets/custom_cue_navigation_icon.dart';

enum Direction { up, down, left, right, none }

class CueCommandsView extends StatelessWidget {
  CueCommandsView({Key? key}) : super(key: key);

  final CueCommandsViewModel _cueCommandsViewModel =
      Get.put(CueCommandsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ScaleTransition(
            scale: _cueCommandsViewModel.blastAnimation,
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildBackground(),
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.09,
                  left: constraints.maxWidth * 0.07,
                  child: _buildNumberMatrix(),
                ),
                Positioned(
                  bottom: -constraints.maxHeight * 0.1,
                  right: -constraints.maxWidth * 0.04,
                  child: _buildNavigationIcon(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground() {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2ecc71).withOpacity(0.7),
            const Color(0xFF3498db).withOpacity(0.7),
          ],
          stops: const [0.2, 0.9],
        ).createShader(bounds);
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2ecc71).withOpacity(0.7),
                  const Color(0xFF3498db).withOpacity(0.7),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: List.generate(
                200,
                (index) {
                  final random = Random();
                  final dropletSize = random.nextDouble() * 15 + 5;
                  final dropletOpacity = random.nextDouble() * 0.5 + 0.5;

                  return Positioned(
                    left: random.nextDouble() * Get.width,
                    top: random.nextDouble() * Get.height,
                    child: Container(
                      width: dropletSize,
                      height: dropletSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFF3498db).withOpacity(dropletOpacity),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3498db).withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: 100,
            child: Container(
              width: 250,
              height: 170,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.redAccent,
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Obx(
                  () => Text(
                    '(${_cueCommandsViewModel.currentIndices[0]}, ${_cueCommandsViewModel.currentIndices[1]})',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberMatrix() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(6, (i) {
          return Row(
            children: List.generate(10, (j) {
              return CustomCueButtonWidget(indices: '(0, ${i * 10 + j})');
            }),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationIcon() {
    return SizedBox(
      height: 500,
      width: 500,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmptyButton(),
              _buildDirectionButton(Icons.arrow_upward, 'Up', Direction.up),
              _buildEmptyButton(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDirectionButton(Icons.arrow_back, 'Left', Direction.left),
              _buildEmptyButton(),
              _buildDirectionButton(
                  Icons.arrow_forward, 'Right', Direction.right),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmptyButton(),
              _buildDirectionButton(
                  Icons.arrow_downward, 'Down', Direction.down),
              _buildEmptyButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyButton() {
    return GetBuilder<CueCommandsViewModel>(
      builder: (controller) {
        return AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            final animationValue = Curves.easeInOutBack
                .transform(controller.animationController.value);
            final animatedColor =
                Color.lerp(Colors.transparent, Colors.grey, animationValue)!;

            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: animatedColor,
                shape: BoxShape.circle,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDirectionButton(
      IconData icon, String label, Direction direction) {
    return GetBuilder<CueCommandsViewModel>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                final animationValue = Curves.easeInOutBack
                    .transform(controller.animationController.value);
                final animatedColor = Color.lerp(
                    Colors.transparent, Colors.green, animationValue)!;
                return CustomCueNavigationIcon(
                  icon: icon,
                  onPressed: () {
                    controller.move(direction);
                  },
                  color: controller.currentDirection == direction
                      ? Colors.green
                      : animatedColor,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
