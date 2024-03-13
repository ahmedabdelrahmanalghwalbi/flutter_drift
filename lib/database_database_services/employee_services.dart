import 'package:drift_flutter/database/app_database/app_database.dart';
import 'package:drift_flutter/route_manager/route_services.dart';
import 'package:flutter/material.dart';

class EmployeeDatabaseServices {
  const EmployeeDatabaseServices._();

  static Future<void> saveNewEmployee(
      {required EmployeeCompanion newEmp,
      required BuildContext context}) async {
    try {
      int val = await AppDataBase().insertEmployee(newEmp);
      if (context.mounted) {
        await AppNavigator.showMessage(
            context,
            "New Employee Inserted Successfully with id :-  ${val.toString()}",
            MessageType.success);
      }
    } catch (e) {
      if (context.mounted) {
        await AppNavigator.showMessage(
            context,
            "Error Happened While Insert New Employee To Database",
            MessageType.error);
      }
    }
  }
}
