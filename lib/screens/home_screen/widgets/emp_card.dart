import 'package:drift_flutter/database_database_services/employee_services.dart';
import 'package:drift_flutter/route_manager/route_manager.dart';
import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final int empId;
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? birthDate;
  final VoidCallback callback;

  const EmployeeCard(
      {required this.userName,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.birthDate,
      required this.empId,
      required this.callback,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pushNamed(context, RouteManager.editEmployeeRoute,
            arguments: empId);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Username: $userName',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Phone Number: $phoneNumber',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Birth Date: ${birthDate.toString()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () async {
                        await EmployeeDatabaseServices.deleteEmployeeById(
                            empId: empId, context: context);
                        Future.delayed(
                            const Duration(seconds: 1), () => callback());
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 30,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
