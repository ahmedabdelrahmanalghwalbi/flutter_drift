import 'package:drift/drift.dart';

class Employee extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().named("user_name")();
  TextColumn get firstName => text().named("first_name")();
  TextColumn get lastName => text().named("last_name")();
  TextColumn get email => text().named("email")();
  TextColumn get phoneNumber => text().named("phone_number")();
  DateTimeColumn get birthDate => dateTime().named('birth_date')();
}
