import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/database.dart';
import 'package:laser_slides/models/network_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkViewModel extends GetxController with GetTickerProviderStateMixin {
  final RxString outgoingIpAddress = ''.obs;
  final RxString outgoingPort = ''.obs;
  final RxString startPath = '/'.obs;
  final RxString incomingIpAddress = '192.168.137.192'.obs;
  final RxString incomingPort = ''.obs;
  final RxInt listenForIncomingMessages = 1.obs;

// fetches the network data
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

// for updating the network data
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

// for getting the device's IP address
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

  late AnimationController controller;
  late Animation<double> animation;
  late AnimationController wifiAnimationController;
  late Animation<double> wifiAnimation;
  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    wifiAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    wifiAnimation = Tween<double>(begin: -60, end: 70).animate(
      CurvedAnimation(
        parent: wifiAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _checkWifiStatus();

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateWifiStatus(result);
    });
  }

  @override
  void onClose() {
    controller.dispose();
    wifiAnimationController.dispose();
    super.onClose();
  }

  late RxBool isWifiConnected = false.obs;
//to check wifi status
  Future<void> _checkWifiStatus() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateWifiStatus(result);
  }

//to update wifi status
  void _updateWifiStatus(ConnectivityResult result) {
    isWifiConnected.value = (result == ConnectivityResult.wifi);
  }
}
