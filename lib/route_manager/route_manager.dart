import 'package:drift_flutter/screens/add_emp_screen/add_employee_screen.dart';
import 'package:drift_flutter/screens/edit_emp_screen/edit_emp_screen.dart';
import 'package:drift_flutter/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String homeScreenRoute = '/';
  static const String addEmployeeRoute = '/add_employee';
  static const String editEmployeeRoute = '/edit_employee';
  RouteManager._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteManager.homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteManager.addEmployeeRoute:
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());
      case RouteManager.editEmployeeRoute:
        return MaterialPageRoute(
            builder: (_) => EditEmployeeScreen(
                  empId: args as int,
                ));
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
