// import 'package:alghwalbi_core/alghwalbi_core.dart';
import 'package:drift_flutter/database/app_database/app_database.dart';
import 'package:drift_flutter/database_database_services/employee_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:drift/drift.dart' as drift;

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = intl.DateFormat('dd/MM/yyyy')
            .format(picked)
            .toString(); // You can format the date as per your requirement
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Employee Screen"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'User Name'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if ((value?.isEmpty ?? true) ||
                        (value?.contains('@') ?? true)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if ((value?.isEmpty ?? true) || value!.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      EmployeeCompanion newEmpCompanion = EmployeeCompanion(
                          birthDate: drift.Value(_selectedDate!),
                          email: drift.Value(_emailController.text),
                          firstName: drift.Value(_firstNameController.text),
                          lastName: drift.Value(_lastNameController.text),
                          phoneNumber: drift.Value(_phoneNumberController.text),
                          userName: drift.Value(_nameController.text));
                      // AppNavigator.showLoading(context);
                      await EmployeeDatabaseServices.saveNewEmployee(
                          newEmp: newEmpCompanion, context: context);
                      // AppNavigator.resume();
                    } else {
                      // await AppNavigator.showMessage(context,
                      //     "Please Provide Valid Data", MessageType.info);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }
}
