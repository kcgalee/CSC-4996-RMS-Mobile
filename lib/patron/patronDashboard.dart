import 'package:flutter/material.dart';

class PatronDashboard extends StatefulWidget {
  const PatronDashboard({Key? key}) : super(key: key);

  @override
  State<PatronDashboard> createState() => _PatronDashboardState();
}

class _PatronDashboardState extends State<PatronDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patron Dashboard"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){

            },
            child: const Text('Request Spoon',
              style: TextStyle(
                color: Colors.white,
              ),
            )
        ),
      ),
    );
  }
}
