import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/viewmodel/commands_view_model.dart';
import 'package:laser_slides/viewmodel/network_view_model.dart';
import 'package:laser_slides/views/cue_commands_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CueCommandsViewModel extends GetxController
    with GetTickerProviderStateMixin {
  final CommandsViewModel _commandsViewModel = Get.put(CommandsViewModel());
  final NetworkViewModel _networkViewModel = Get.put(NetworkViewModel());

  RxList<int> currentIndices = <int>[0, 0].obs;
  Direction currentDirection = Direction.none;

  // Set current indices based on input string
  void setCurrentIndices(String indices) {
    final List<int> parsedIndices = parseIndices(indices);
    currentIndices.assignAll(parsedIndices);
    currentDirection = Direction.none;
    update();
  }

  // Parse indices from string to List<int>
  List<int> parseIndices(String indices) {
    final List<String> parts = indices.split(', ');
    return [
      int.parse(parts[0].substring(1)),
      int.parse(parts[1].substring(0, parts[1].length - 1))
    ];
  }
  
  // function to adjust current indices based on direction
  Future<void> move(Direction direction) async {
    String savedCommand = await getSavedCommand();
    currentDirection = direction;

    switch (direction) {
      case Direction.up:
        if (currentIndices[1] >= 10) {
          currentIndices[1] -= 10;
          print(
              'Moved Up to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc(savedCommand, currentIndices);
        }
        break;
      case Direction.down:
        if (currentIndices[1] < 50) {
          currentIndices[1] += 10;
          print(
              'Moved Down to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc(savedCommand, currentIndices);
        }
        break;
      case Direction.left:
        if (currentIndices[1] > 0) {
          currentIndices[1]--;
          print(
              'Moved Left to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc(savedCommand, currentIndices);
        }
        break;
      case Direction.right:
        if (currentIndices[1] < 59) {
          currentIndices[1]++;
          print(
              'Moved Right to matrix indices (${currentIndices[0]}, ${currentIndices[1]})');
          callOsc(savedCommand, currentIndices);
        }
        break;
      case Direction.none:
        break;
    }

    update();
  }



  // Animation controllers and variables
  late AnimationController animationController;
  late AnimationController blastController;
  late Animation<double> blastAnimation;

  @override
  void onInit() {
    //animation controller for background
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    //animation controller while cue view starts
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

  //call OSC command using network data
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

  //dialog to update command
  Future<void> showCommandDialogue() async {
    final TextEditingController newController = TextEditingController();
    final TextEditingController oldController = TextEditingController();
    String savedCommand = await getSavedCommand();
    oldController.text = savedCommand;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            height: Get.height * 0.6,
            width: Get.width * 0.3,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 238, 141, 93),
                  Color.fromRGBO(103, 210, 229, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Update Command",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Current Command',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: oldController,
                  readOnly: true,
                  style: const TextStyle(fontSize: 18),
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter new Command',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: newController,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Enter new Command',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Note: Don\'t write parameters in the command',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String newCommand = newController.text;

                        updateCueCommand(newCommand);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Update saved command in SharedPreferences
  Future<void> updateCueCommand(String command) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('newCommand', command);
  }

  // Retrieve saved command from SharedPreferences
  Future<String> getSavedCommand() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('newCommand') ?? 'beyond/general/cuedown';
  }
}
