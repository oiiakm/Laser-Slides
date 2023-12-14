import 'dart:io';
import 'package:get/get.dart';
import 'package:laser_slides/database.dart';
import 'package:laser_slides/models/button_model.dart';
import 'package:osc/osc.dart';

class HomeViewModel extends GetxController {
  final RxString outgoingIpAddress = ''.obs;
  final RxString outgoingPort = ''.obs;
  final RxString startPath = '/'.obs;

  final buttons = <ButtonModel>[].obs;

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

  void sendCommand(ButtonModel button) async {
    List<Object> result = getArgumentAndCommand(button.buttonPressed);

    String command = result.isNotEmpty ? result[0] as String : '';
    List<dynamic> arguments = result.length > 1
        ? (result[1] as List<String?>)
            .map((arg) => arg == null ? null : int.tryParse(arg) ?? arg)
            .toList()
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

  Future<void> sendOSCCommand(String command, String outgoingIpAddress,
      int outgoingPort, String startPath, List<dynamic> arguments) async {
    try {
      print('Command sent: $command');
      print('Arguments sent: $arguments');
      final oscMessage =
          OSCMessage(startPath + command, arguments: arguments.cast<Object>());

      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      final oscBytes = oscMessage.toBytes();

      socket.send(oscBytes, InternetAddress(outgoingIpAddress), outgoingPort);

      socket.close();

      print('Command sent successfully: $command');
    } catch (e) {
      print('Error sending command: $e');
    }
  }
}
