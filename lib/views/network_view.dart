import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _viewModel.animation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: _viewModel.animation.value * 2,
                      colors: [
                        Colors.transparent,
                        Colors.blue.withOpacity(_viewModel.animation.value),
                        Colors.red.withOpacity(_viewModel.animation.value),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.6, 1.0],
                    ),
                  ),
                );
              },
            ),
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
                          const SizedBox(height: 20.0),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: _viewModel
                                          .listenForIncomingMessages.value ==
                                      1,
                                  onChanged: (value) {
                                    _viewModel.listenForIncomingMessages.value =
                                        value == true ? 1 : 0;
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
                          const SizedBox(height: 30.0),
                          Center(
                              child: ElevatedButton(
                            onPressed: () async {
                              await _viewModel.updateData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 76, 63, 63)
                                      .withOpacity(0.9),
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 60.0),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          GetBuilder<NetworkViewModel>(
            builder: (controller) {
              Color backgroundColor =
                  controller.isWifiConnected.value ? Colors.green : Colors.red;
              Color textColor = controller.isWifiConnected.value
                  ? Colors.white
                  : Colors.black;

              return AnimatedBuilder(
                animation: _viewModel.wifiAnimationController,
                builder: (context, child) {
                  return Positioned(
                    top: 200 - _viewModel.wifiAnimation.value,
                    right: 50 - _viewModel.wifiAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Icon(Icons.wifi, color: textColor, size: 50)),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
