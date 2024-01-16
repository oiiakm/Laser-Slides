import 'package:get/get.dart';
import 'package:laser_slides/routes/route_error.dart';
import 'package:laser_slides/views/master_commands_view.dart';
import 'package:laser_slides/views/cue_commands_view.dart';
// import 'package:laser_slides/test/general_commands_view.dart';
import 'package:laser_slides/views/navigation_view.dart';
import 'package:laser_slides/views/general_commands_view.dart';
import 'package:laser_slides/views/splash_view.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: '/', page: () => SplashView()),
    GetPage(name: '/route_error', page: () => const RouteErrorView()),
    GetPage(name: '/navigation_view', page: () => NavigationView()),
    // GetPage(name: '/general_command_view', page: () => GeneralCommandView()),
    GetPage(name: '/general_commands_view', page: () => GeneralCommandsView()),
    GetPage(name: '/cue_commands_view', page: () => CueCommandsView()),
    GetPage(name: '/master_commands_view', page: () => MasterCommandsView()),
  ];
}
