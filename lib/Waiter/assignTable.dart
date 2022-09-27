import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Utility/request_tile.dart';

class AssignTable extends StatefulWidget {
  final String tableID;
  final String tableName;
  const AssignTable({super.key, required this.tableID, required this.tableName});


  @override
  State<AssignTable> createState() => _AssignTableState();
}

class _AssignTableState extends State<AssignTable> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text("Assign Table"),
          elevation: 0,
        ),
      body: Text("Table Name: " + widget.tableName + "\nTable ID: " + widget.tableID)
    );
  }

}
