import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/views/setting_view.dart';
import 'package:laser_slides/views/dashboard_view.dart';
import 'package:laser_slides/views/help_view.dart';
import 'package:laser_slides/views/network_view.dart';

class NavigationViewModel extends GetxController {
  var currentView = Rx<Widget>(DashboardView());
  var selectedIcon = RxInt(0);

  // Change view based on the selected index
  void changeView(int index) {
    switch (index) {
      case 0:
        _changeView(DashboardView(), 0);
        break;
      case 1:
        _changeView(NetworkView(), 1);
        break;
      case 2:
        _changeView(const SettingView(), 2);
        break;
      case 3:
        _changeView(const HelpView(), 3);
        break;

      default:
        break;
    }
  }

  // method to update the current view and selected icon
  void _changeView(Widget view, int index) {
    currentView.value = view;
    selectedIcon.value = index;
  }
}
