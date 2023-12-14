import 'package:get/get.dart';
import 'package:laser_slides/routes/route_error.dart';
import 'package:laser_slides/views/dashboard_view.dart';
import 'package:laser_slides/views/splash_view.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: '/', page: () => const SplashView()),
    GetPage(name: '/route_error', page: () => const RouteErrorView()),
    GetPage(name: '/dashboard_view', page: () => const DashboardView()),
  ];
}
