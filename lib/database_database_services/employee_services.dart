import 'package:drift_flutter/database/app_database/app_database.dart';
import 'package:drift_flutter/route_manager/route_services.dart';
import 'package:flutter/material.dart';

class EmployeeDatabaseServices {
  const EmployeeDatabaseServices._();

  static AppDataBase appDatabase = AppDataBase();

  // insert new Employee in ddatabase
  static Future<void> saveNewEmployee(
      {required EmployeeCompanion newEmp,
      required BuildContext context}) async {
    try {
      int val = await appDatabase.insertEmployee(newEmp);
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
            message: e.toString(),
            MessageType.error);
      }
    }
  }

  // get all employess from database
  static Future<List<EmployeeData>?> getEmployess(
      {required BuildContext context}) async {
    try {
      return await appDatabase.getEmployess();
    } catch (e) {
      if (context.mounted) {
        await AppNavigator.showMessage(context,
            "Error While Getting Employees from Database", MessageType.error,
            message: e.toString());
      }
      return null;
    }
  }

  // get employee Data by id
  static Future<EmployeeData?> getEmployeeDataById(
      {required BuildContext context, required int empId}) async {
    try {
      return await appDatabase.getEmployeeById(empId);
    } catch (e) {
      if (context.mounted) {
        await AppNavigator.showMessage(context,
            "Error While Getting Employee Data by Id", MessageType.error,
            message: e.toString());
      }
      return null;
    }
  }

  //delete Employee By Id

  static Future<void> deleteEmployeeById(
      {required BuildContext context, required int empId}) async {
    try {
      int? val = await appDatabase.deleteEmployee(empId);

      if (val != null && val == 1) {
        if (context.mounted) {
          await AppNavigator.showMessage(
              context,
              "Employee Deleted Successfully with id :-  ${empId.toString()}",
              MessageType.success);
        }
      } else {
        if (context.mounted) {
          await AppNavigator.showMessage(
              context,
              "Employee Not Deleted with id :-  ${empId.toString()}",
              MessageType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        await AppNavigator.showMessage(context,
            "Error While Getting Employee Data by Id", MessageType.error,
            message: e.toString());
      }
    }
  }

  //update employee in database
  static Future<void> updateEmployee(
      {required EmployeeCompanion newEmp,
      required BuildContext context}) async {
    try {
      bool val = await appDatabase.updateEmployee(newEmp);
      if (val == true) {
        if (context.mounted) {
          await AppNavigator.showMessage(
              context,
              "Employee Updated Successfully with id :-  ${newEmp.id.value.toString()}",
              MessageType.success);
        }
      } else {
        if (context.mounted) {
          await AppNavigator.showMessage(
              context,
              "Employee Not Updated with id :-  ${newEmp.id.value.toString()}",
              MessageType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        await AppNavigator.showMessage(
            context,
            "Error Happened While Update Employee To Database",
            message: e.toString(),
            MessageType.error);
      }
    }
  }
}
