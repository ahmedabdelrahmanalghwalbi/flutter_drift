import 'package:drift_flutter/route_manager/route_manager.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
      ),
      body: const Column(
        children: [],
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
            Navigator.pushNamed(context, RouteManager.addEmploeeRoute),
      ),
    );
  }
}
