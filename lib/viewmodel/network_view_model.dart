import 'dart:io';
import 'package:get/get.dart';
import 'package:laser_slides/database.dart';
import 'package:laser_slides/models/network_model.dart';

class NetworkViewModel extends GetxController {
  final RxString outgoingIpAddress = ''.obs;
  final RxString outgoingPort = ''.obs;
  final RxString startPath = '/'.obs;
  final RxString incomingIpAddress = '192.168.137.192'.obs;
  final RxString incomingPort = ''.obs;
  final RxInt listenForIncomingMessages = 1.obs;

  Future<Map<String, dynamic>> fetchData() async {
    try {
      final snapshot = await DatabaseHelper().getAllNetworkData();
      final networkData =
          (snapshot['network_config'] as List<Map<String, dynamic>>).first;
      outgoingIpAddress.value = networkData['outgoingIpAddress'] ?? '';
      outgoingPort.value = networkData['outgoingPort']?.toString() ?? '';
      startPath.value = networkData['startPath'] ?? '';
      listenForIncomingMessages.value =
          networkData['listenForIncomingMessages'] ?? 0;
      incomingIpAddress.value = networkData['incomingIpAddress'] ?? '';
      incomingPort.value = networkData['incomingPort']?.toString() ?? '';
      return networkData;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateData() async {
    try {
      final updatedNetworkData = NetworkModel(
        id: 1,
        outgoingIpAddress: outgoingIpAddress.value,
        outgoingPort: int.parse(outgoingPort.value),
        startPath: startPath.value,
        incomingIpAddress: incomingIpAddress.value,
        incomingPort: int.parse(incomingPort.value),
        listenForIncomingMessages: listenForIncomingMessages.value,
      );

      await DatabaseHelper().updateNetworkData(1, updatedNetworkData);
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  Future<String> deviceIPV4() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return 'waiting...';
  }
}
