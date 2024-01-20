import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/database.dart';
import 'package:laser_slides/models/button_model.dart';
import 'package:osc/osc.dart';

class CommandsViewModel extends GetxController {
  final RxString outgoingIpAddress = ''.obs;
  final RxString outgoingPort = ''.obs;
  final RxString startPath = '/'.obs;
  final nameController = Rx<String>('');
  final pressedController = Rx<String>('');
  final buttons = <ButtonModel>[].obs;

// fetch all button data
  Future<void> getAllButtonData() async {
    try {
      final data = await DatabaseHelper().getAllButtonData();
      final buttonList = (data['button_config'] as List)
          .map((map) => ButtonModel.fromMap(map))
          .toList();
      buttons.assignAll(buttonList);
    } catch (e) {
      print('Error fetching button data: $e');
    }
  }

// final buttonList = (data['button_config'] as List).map((map) => ButtonModel.fromMap(map)).toList();:
// This line extracts the 'button_config' key from the data map, assuming it contains a list.
// It then maps each item in the list to a ButtonModel by using the fromMap constructor and converts it to a list.
// The resulting list is stored in the variable buttonList.

// buttons.assignAll(buttonList);:
//  This line assigns the list of ButtonModel objects to a variable named buttons.
//  The use of assignAll suggests that buttons is likely an observable or reactive
//  list that triggers updates when its content changes.

//returning the argument and command
  List<Object> getArgumentAndCommand(String input) {
    List<String> parts = input.trim().split(' ');

    if (parts.isNotEmpty) {
      String command = parts[0];

      List<String?> arguments =
          parts.sublist(1).map((arg) => arg == 'null' ? null : arg).toList();

      return [command, arguments];
    }

    return [];
  }

// calling OSC command and passing the OSC parameters
  void getOSCParameters(ButtonModel button) async {
    // we can use dynamic also in case of List<Object>
    List<Object> result = getArgumentAndCommand(button.buttonPressed);

    String command = result.isNotEmpty ? result[0] as String : '';
    List<dynamic> arguments = result.length > 1
        ? (result[1] as List<String?>).map((arg) {
            if (arg == null) {
              return null;
            } else if (int.tryParse(arg) != null) {
              return int.parse(arg);
            } else if (double.tryParse(arg) != null) {
              return double.parse(arg);
            } else {
              return arg;
            }
          }).toList()
        : [];

    print("Command: $command");
    print("Arguments: $arguments");

    final snapshot = await DatabaseHelper().getAllNetworkData();
    final networkData =
        (snapshot['network_config'] as List<Map<String, dynamic>>).first;
    outgoingIpAddress.value = networkData['outgoingIpAddress'] ?? '';
    outgoingPort.value = networkData['outgoingPort'].toString();
    startPath.value = networkData['startPath'] ?? '';

    sendOSCCommand(
      command,
      outgoingIpAddress.value,
      int.parse(outgoingPort.value),
      startPath.value,
      arguments,
    );
  }

// sending the OSC command to the device
  Future<void> sendOSCCommand(String command, String outgoingIpAddress,
      int outgoingPort, String startPath, List<dynamic> arguments) async {
    try {
      print('Command sent: $command');
      print('Arguments sent: $arguments');
      final oscMessage =
          OSCMessage(startPath + command, arguments: arguments.cast<Object>());
//bind to any ipv4 address and a random port numberfor the host
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      final oscBytes = oscMessage.toBytes();

      socket.send(oscBytes, InternetAddress(outgoingIpAddress), outgoingPort);

      socket.close();

      print('Command sent successfully: $command');
    } catch (e) {
      print('Error sending command: $e');
    }
  }

// for updating the button data
  Future<void> updateButton(
      int id, String updatedButtonName, String updatedButtonPressed) async {
    await DatabaseHelper().updateButton(
      id,
      ButtonModel(
        id: id,
        buttonName: updatedButtonName,
        buttonPressed: updatedButtonPressed,
      ),
    );
  }

// showing dialog for editing the button
  void showEditDialog(BuildContext context, ButtonModel button) {
    nameController.value = button.buttonName;
    pressedController.value = button.buttonPressed;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Container(
            alignment: Alignment.center,
            width: 350,
            height: 400,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 49, 165, 191),
                  Color.fromARGB(255, 220, 44, 140)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                    'Edit Button',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller:
                        TextEditingController(text: nameController.value),
                    onChanged: (value) => nameController.value = value,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: const InputDecoration(
                      labelText: 'Button Name',
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Color(0xFF004E64),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller:
                        TextEditingController(text: pressedController.value),
                    onChanged: (value) => pressedController.value = value,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: const InputDecoration(
                      labelText: 'Button Pressed',
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Color(0xFF004E64),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    final String updatedButtonName = nameController.value;
                    final String updatedButtonPressed = pressedController.value;
                    await updateButton(
                      button.id,
                      updatedButtonName,
                      updatedButtonPressed,
                    );
                    Get.back();
                    update();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
