import 'package:flutter/material.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('LaserSlides Overview:'),
              _point(
                  'Laser Slides is a simple OSC (Open Sound Control) app for modifying messages on phones/tablets.'),
              _point(
                  'Designed for laser presentations, it controls BEYOND laser software by Pangolin.'),
              _point('Developed by Amit Kumar'),
              _sectionHeader('Usage Instructions:'),
              _point('Find the IP in BEYOND\'s OSC settings.'),
              _point('Input the IP in LaserSlides\' "network" button.'),
              _point('Activate "edit mode" to customize buttons.'),
              _sectionHeader('Editing Buttons:'),
              _point('Edit "button 1" by adding a name to the label.'),
              _point(
                  'Specify the BEYOND PATH for the image in the button pressed field.'),
              _sectionHeader('Understanding BEYOND PATH:'),
              _point(
                  'Follow a grid layout: first cell is 0 0, first row from 0 0 to 0 9, second row from 0 10 to 0 19, and so on.'),
              _point(
                  'Example command: `beyond/general/startcue 0 0` for the first cell.'),
              _sectionHeader('Default Commands:'),
              _point(
                  'Use default commands from beyond/general/startcue 0 1 to beyond/general/startcue 0 15'),
              _sectionHeader('OSC References:'),
              _point(
                  'Find all OSC command references at (https://wiki.pangolin.com/beyond:osc_commands).'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _point(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            color: Colors.blue,
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
