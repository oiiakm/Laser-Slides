import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:laser_slides/utils/responsive.dart';
import 'package:laser_slides/views/edit_view.dart';
import 'package:laser_slides/views/help_view.dart';
import 'package:laser_slides/views/home_view.dart';
import 'package:laser_slides/views/network_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool isWifiConnected = false;

  final List<String> tabNames = ['Home', 'Edit Mode', 'Network', 'Help'];
  final List<Color> tabColors = [
    const Color.fromARGB(255, 36, 85, 37),
    const Color.fromARGB(189, 71, 67, 200),
    const Color.fromARGB(255, 102, 104, 102),
    const Color.fromARGB(255, 163, 60, 19),
  ];
  final List<Color> indicatorColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  final List<Widget> tabViews = [
    HomeView(),
    EditView(),
    NetworkView(),
    const HelpView(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabNames.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    _checkWifiStatus();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateWifiStatus(result);
    });
  }

  Future<void> _checkWifiStatus() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateWifiStatus(result);
  }

  void _updateWifiStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      setState(() {
        isWifiConnected = true;
      });
    } else {
      setState(() {
        isWifiConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        return Scaffold(
          appBar: buildAppBar(screenWidth),
          body: TabBarView(
            controller: _tabController,
            children: tabViews,
          ),
        );
      },
    );
  }

  PreferredSizeWidget buildAppBar(double screenWidth) {
    return PreferredSize(
      preferredSize:
          Size.fromHeight(screenWidth > 600 ? Get.height / 5 : Get.height / 8),
      child: AppBar(
        backgroundColor: tabColors[_currentIndex],
        elevation: 0,
        title: Text(
          _currentIndex == 0 ? 'Laser Slides' : tabNames[_currentIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveUtils.calculateHeaderTextSize(),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 40.0, top: 20.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                isWifiConnected ? Icons.wifi : Icons.wifi_off,
                size: 40,
                color: isWifiConnected
                    ? const Color.fromARGB(255, 1, 19, 2)
                    : const Color.fromARGB(255, 233, 19, 4),
              ),
            ),
          ),
        ],
        bottom: buildTabBar(),
      ),
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: List<Widget>.generate(tabNames.length, (index) {
        return Tab(
          child: Text(
            tabNames[index],
            style: TextStyle(
              fontSize: ResponsiveUtils.calculateHeaderTextSize(),
            ),
          ),
        );
      }),
      onTap: (index) {
        _tabController.animateTo(index);
      },
      indicator: BoxDecoration(
        color: indicatorColors[_currentIndex],
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.white,
    );
  }
}
