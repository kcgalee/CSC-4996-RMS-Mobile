import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/waiter/waiterHome.dart';

class AssignTables extends StatefulWidget {
  const AssignTables({super.key});

  @override
  AssignTablesState createState() => AssignTablesState();
}

class AssignTablesState extends State<AssignTables> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Assign Table"),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
        )
    );
  }
}