// import 'package:alghwalbi_core/alghwalbi_core.dart';
import 'package:drift_flutter/database/app_database/app_database.dart';
import 'package:flutter/material.dart';

class EmployeeDatabaseServices {
  const EmployeeDatabaseServices._();

  static Future<void> saveNewEmployee(
      {required EmployeeCompanion newEmp,
      required BuildContext context}) async {
    try {
      await AppDataBase().insertEmployee(newEmp);
    } catch (e) {
      if (context.mounted) {
        // AppNavigator.showMessage(
        //     context,
        //     "Error Happened While Insert New Employee To Database",
        //     MessageType.error);
      }
    }
  }
}
