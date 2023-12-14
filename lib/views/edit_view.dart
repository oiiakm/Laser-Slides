import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/database.dart';
import 'package:laser_slides/models/button_model.dart';
import 'package:laser_slides/viewmodel/edit_view_model.dart';
import 'package:laser_slides/widgets/custom_button_widget.dart';

class EditView extends StatelessWidget {
  EditView({Key? key}) : super(key: key);

  final EditViewModel _viewModel = Get.put(EditViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/edit_mode.jpg',
            fit: BoxFit.cover,
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: DatabaseHelper().getAllButtonData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final buttons = (snapshot.data!['button_config']
                        as List<Map<String, dynamic>>)
                    .map((map) => ButtonModel.fromMap(map))
                    .toList();

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 70,
                            ),
                            buildButtonRow(context, buttons, [1, 2, 3], 10.0),
                            const SizedBox(height: 20.0),
                            buildButtonRow(context, buttons, [4, 5, 6], 10.0),
                            const SizedBox(height: 20.0),
                            buildButtonRow(context, buttons, [7, 8, 9], 10.0),
                            const SizedBox(height: 20.0),
                            buildButtonRow(
                                context, buttons, [10, 11, 12], 10.0),
                            const SizedBox(height: 20.0),
                            buildButtonRowWithSpacing(
                                context, buttons, [13, 14, 15], 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, List<ButtonModel> buttons,
      List<int> ids, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons
          .where((button) => ids.contains(button.id))
          .expand((button) => [
                buildCustomButton(context, button),
                SizedBox(width: spacing),
              ])
          .toList(),
    );
  }

  Widget buildButtonRowWithSpacing(BuildContext context,
      List<ButtonModel> buttons, List<int> ids, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons
          .where((button) => ids.contains(button.id))
          .expand((button) => [
                buildCustomButton(context, button),
                SizedBox(width: spacing),
              ])
          .toList(),
    );
  }

  Widget buildCustomButton(BuildContext context, ButtonModel button) {
    return CustomButtonWidget(
      text: button.buttonName,
      backgroundColor: Colors.red,
      onPressed: () async {
        print('Pressed ${button.id}: ${button.buttonName}');
        _viewModel.showEditDialog(context, button);
      },
    );
  }
}
