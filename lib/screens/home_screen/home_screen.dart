import 'package:drift_flutter/database/app_database/app_database.dart';
import 'package:drift_flutter/database_database_services/employee_services.dart';
import 'package:drift_flutter/route_manager/route_manager.dart';
import 'package:drift_flutter/screens/home_screen/widgets/emp_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            )),
      ),
      body: FutureBuilder<List<EmployeeData>?>(
        future: EmployeeDatabaseServices.getEmployess(context: context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                EmployeeData employee = snapshot.data![index];
                return EmployeeCard(
                  empId: employee.id,
                  userName: employee.userName,
                  firstName: employee.firstName,
                  lastName: employee.lastName,
                  email: employee.email,
                  phoneNumber: employee.phoneNumber,
                  birthDate:
                      intl.DateFormat('dd/MM/yyyy').format(employee.birthDate),
                  callback: () => setState(() {}),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Add Employee",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 18,
        ),
        onPressed: () =>
            Navigator.pushNamed(context, RouteManager.addEmployeeRoute),
      ),
    );
  }
}
