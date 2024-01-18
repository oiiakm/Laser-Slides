import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laser_slides/utils/app_tour.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  int _selectedThemeIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedTheme();
  }

  _loadSelectedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedThemeIndex = prefs.getInt('themeIndex') ?? 0;
      _applyTheme(_selectedThemeIndex);
    });
  }

//apply theme
  _applyTheme(int index) {
    switch (index) {
      case 0:
        Get.changeTheme(ThemeData.light());
        break;
      case 1:
        Get.changeTheme(ThemeData.dark());
        break;
      case 2:
        Get.changeThemeMode(ThemeMode.system);
        break;
      default:
        break;
    }
  }

//save selected theme
  _saveSelectedTheme(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.green,
                Colors.black,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Choose a Theme',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < 3; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedThemeIndex = i;
                        _saveSelectedTheme(_selectedThemeIndex);
                        _applyTheme(_selectedThemeIndex);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _selectedThemeIndex == i
                            ? const Color.fromRGBO(134, 107, 50, 1)
                                .withOpacity(0.9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getThemeName(i),
                          style: TextStyle(
                            color: _selectedThemeIndex == i
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Get.to(AppTour());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 215, 48, 23),
                    backgroundColor: const Color.fromARGB(255, 128, 231, 197),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                      'Start App Tour',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//get theme name
  String _getThemeName(int index) {
    switch (index) {
      case 0:
        return 'Light Theme';
      case 1:
        return 'Dark Theme';
      case 2:
        return 'System Theme';
      default:
        return '';
    }
  }
}
