import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/viewmodel/commands_view_model.dart';
import 'package:laser_slides/viewmodel/network_view_model.dart';
import 'package:laser_slides/views/cue_commands_view.dart';

class CueCommandsViewModel extends GetxController
    with GetTickerProviderStateMixin {
  final CommandsViewModel _commandsViewModel = Get.put(CommandsViewModel());
  final NetworkViewModel _networkViewModel = Get.put(NetworkViewModel());

  RxList<int> currentIndices = <int>[0, 0].obs;
  Direction currentDirection = Direction.none;

  void setCurrentIndices(String indices) {
    final List<int> parsedIndices = parseIndices(indices);
    currentIndices.assignAll(parsedIndices);
    currentDirection = Direction.none;
    update();
  }

  void move(Direction direction) {
    currentDirection = direction;

    switch (direction) {
      case Direction.up:
        if (currentIndices[1] >= 10) {
          currentIndices[1] -= 10;
          print(
              'Moved Up to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc('beyond/general/startcue', currentIndices);
        }
        break;
      case Direction.down:
        if (currentIndices[1] < 50) {
          currentIndices[1] += 10;
          print(
              'Moved Down to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc('beyond/general/startcue', currentIndices);
        }
        break;
      case Direction.left:
        if (currentIndices[1] > 0) {
          currentIndices[1]--;
          print(
              'Moved Left to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc('beyond/general/startcue', currentIndices);
        }
        break;
      case Direction.right:
        if (currentIndices[1] < 59) {
          currentIndices[1]++;
          print(
              'Moved Right to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc('beyond/general/startcue', currentIndices);
        }
        break;
      case Direction.none:
        break;
    }

    update();
  }

  List<int> parseIndices(String indices) {
    final List<String> parts = indices.split(', ');
    return [
      int.parse(parts[0].substring(1)),
      int.parse(parts[1].substring(0, parts[1].length - 1))
    ];
  }

  late AnimationController animationController;
  late AnimationController blastController;
  late Animation<double> blastAnimation;
  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    blastController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    blastAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: blastController,
        curve: Curves.easeInOut,
      ),
    );

    blastController.forward();
    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    blastController.dispose();
    super.onClose();
  }

  Future<void> callOsc(command, arguments) async {
    Map<String, dynamic> networkData = await _networkViewModel.fetchData();

    _commandsViewModel.sendOSCCommand(
      command,
      networkData['outgoingIpAddress'],
      networkData['outgoingPort'],
      networkData['startPath'],
      currentIndices.toList(),
    );
  }
}
