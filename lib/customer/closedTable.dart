import 'package:flutter/material.dart';

import 'Utility/navigation.dart';

class ClosedTable extends StatefulWidget {
  const ClosedTable({Key? key}) : super(key: key);

  @override
  State<ClosedTable> createState() => _ClosedTableState();
}

class _ClosedTableState extends State<ClosedTable> {
  late var restName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
    appBar: AppBar(
    title: const Text('Home'),
    backgroundColor: const Color(0xff76bcff),
    foregroundColor: Colors.black,
    elevation: 0,
    ),
    body: Column(
      children: [
        const Text("Your table has been closed. \n Thank you for visiting \n "),
        Text(
            restName,
            style: const TextStyle(
            color: Colors.black54,
            fontSize: 30,
            fontWeight: FontWeight.bold)),
      ],
    )
    );
  }
}
