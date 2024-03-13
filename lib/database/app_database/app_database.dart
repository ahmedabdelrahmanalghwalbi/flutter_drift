import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart" as path;
import '../employee_database/employee_entity.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [Employee])
class AppDataBase extends _$AppDataBase {
  AppDataBase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  // get all employess
  Future<List<EmployeeData>> getEmployess() async =>
      await select(employee).get();
  // get Single Employee by id
  Future<EmployeeData> getEmployeeById(int empId) async =>
      await (select(employee)..where((tbl) => tbl.id.equals(empId)))
          .getSingle();
  //update Employee
  Future<bool> updateEmployee(EmployeeCompanion empEntity) async =>
      await update(employee).replace(empEntity);
  //insert Employee
  Future<int> insertEmployee(EmployeeCompanion empEntity) async =>
      await into(employee).insert(empEntity);
  //delete Employee (Returns the amount of rows that were deleted by this statement directly)
  Future<int> deleteEmployee(int id) async =>
      await (delete(employee)..where((tbl) => tbl.id.equals(id))).go();
}

const String dbName = "employee.sqlite";

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationDocumentsDirectory();
    final File databaseFile = File(path.join(dbFolder.path, dbName));
    return NativeDatabase(databaseFile);
  });
}
