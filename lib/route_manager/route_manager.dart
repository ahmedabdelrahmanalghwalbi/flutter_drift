import 'package:drift_flutter/screens/add_emp_screen/add_employee_screen.dart';
import 'package:drift_flutter/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String homeScreenRoute = '/';
  static const String addEmploeeRoute = '/add_employee';
  RouteManager._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteManager.addEmploeeRoute:
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());

      default:
        return _errorRotue();
    }
  }

  static Route<dynamic> _errorRotue() => MaterialPageRoute(
      builder: (_) => const Scaffold(
              body: Center(
            child: Text("Page Not Defined"),
          )));
}
