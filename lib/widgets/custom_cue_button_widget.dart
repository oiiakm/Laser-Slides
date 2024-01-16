import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/viewmodel/cue_view_model.dart';

class CustomCueButtonWidget extends StatelessWidget {
  final String indices;
  CustomCueButtonWidget({Key? key, required this.indices}) : super(key: key);
  final CueCommandsViewModel _cueCommandsViewModel =
      Get.put(CueCommandsViewModel());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CueCommandsViewModel>(
      builder: (controller) {
        final List<int> currentIndex = controller.parseIndices(indices);

        return SizedBox(
          width: 80,
          height: 80,
          child: ElevatedButton(
            onPressed: () {
              controller.setCurrentIndices(indices);
              print('Button pressed at index: $indices');
              _cueCommandsViewModel.callOsc('beyond/general/startcue', indices);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  controller.currentIndices[0] == currentIndex[0] &&
                          controller.currentIndices[1] == currentIndex[1]
                      ? Colors.green
                      : Colors.redAccent.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              elevation: 4,
              shadowColor: Colors.black,
            ),
            child: Center(
              child: Text(
                (currentIndex[1] + 1).toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}
