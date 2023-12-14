import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/utils/responsive.dart';
import 'package:laser_slides/viewmodel/network_view_model.dart';
import 'package:laser_slides/widgets/custom_text_field_widget.dart';

class NetworkView extends StatelessWidget {
  final NetworkViewModel _viewModel = Get.put(NetworkViewModel());

  NetworkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/network.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _viewModel.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return Center(
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: ResponsiveUtils.calculateNetworkContainerHeight(),
                    width: ResponsiveUtils.calculateNetworkContainerWidth(),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(183, 171, 230, 206),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                'Outgoing Settings',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextFieldWidget(
                              labelText: 'Outgoing IP Address',
                              hintText: '255.255.255.255',
                              initialValue: _viewModel.outgoingIpAddress.value,
                              onChanged: (value) =>
                                  _viewModel.outgoingIpAddress.value = value,
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextFieldWidget(
                              labelText: 'Outgoing Port',
                              hintText: '8000',
                              initialValue: _viewModel.outgoingPort.value,
                              onChanged: (value) =>
                                  _viewModel.outgoingPort.value = value,
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextFieldWidget(
                              labelText: 'Start Path',
                              initialValue: _viewModel.startPath.value,
                              onChanged: (value) =>
                                  _viewModel.startPath.value = value,
                              hintText: '',
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                              child: Text(
                                'Incoming Settings',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value: _viewModel
                                            .listenForIncomingMessages.value ==
                                        1,
                                    onChanged: (value) {
                                      _viewModel.listenForIncomingMessages
                                          .value = value == true ? 1 : 0;
                                    },
                                  ),
                                ),
                                const Text('Listen for incoming messages'),
                              ],
                            ),
                            CustomTextFieldWidget(
                              readOnly: true,
                              labelText: 'Incoming IP Address',
                              hintText: '192.168.137.192',
                              initialValue: _viewModel.incomingIpAddress.value,
                              onChanged: (value) =>
                                  _viewModel.incomingIpAddress.value = value,
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextFieldWidget(
                              labelText: 'Incoming Port',
                              hintText: '8090',
                              initialValue: _viewModel.incomingPort.value,
                              onChanged: (value) =>
                                  _viewModel.incomingPort.value = value,
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                                child: ElevatedButton(
                              onPressed: () async {
                                await _viewModel.updateData();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 24.0),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
