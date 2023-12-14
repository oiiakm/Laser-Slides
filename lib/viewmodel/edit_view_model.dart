import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/database.dart';
import 'package:laser_slides/models/button_model.dart';

class EditViewModel extends GetxController {
  final nameController = Rx<String>('');
  final pressedController = Rx<String>('');

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

  void showEditDialog(BuildContext context, ButtonModel button) async {
    nameController.value = button.buttonName;
    pressedController.value = button.buttonPressed;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Button'),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: nameController.value),
                onChanged: (value) => nameController.value = value,
                decoration: const InputDecoration(labelText: 'Button Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller:
                    TextEditingController(text: pressedController.value),
                onChanged: (value) => pressedController.value = value,
                decoration: const InputDecoration(labelText: 'Button Pressed'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final String updatedButtonName = nameController.value;
                  final String updatedButtonPressed = pressedController.value;
                  await updateButton(
                      button.id, updatedButtonName, updatedButtonPressed);

                  Get.back();
                  update();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
