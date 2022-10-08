

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'GenerateQRCode.dart';
import 'Utility/MangerNavigationDrawer.dart';

class AddTable extends StatefulWidget {
  @override
  State<AddTable> createState() => _AddTable();
}


class _AddTable extends State<AddTable> {
  final tableNumberController = TextEditingController();
  final tableCapacityController = TextEditingController();
  final tableTypeController = TextEditingController();
  @override
  Widget build(BuildContext context)=> Scaffold (
      drawer: const ManagerNavigationDrawer(),
    appBar: AppBar(
    title: Text("Add Table"),
    ),
      body: Center (
        child: SingleChildScrollView (
            padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          TextFormField(
            controller: tableNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Table number",
              prefixIcon: Icon(Icons.numbers, color: Colors.black),
            ),
          ),
              TextFormField(
                controller: tableCapacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Table Capacity",
                  prefixIcon: Icon(Icons.people, color: Colors.black),
                ),
              ),

              TextFormField(
                controller: tableTypeController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Table Type",
                  prefixIcon: Icon(Icons.type_specimen, color: Colors.black),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(child: Text("Add Table"),
                    onPressed: () =>
                    newTableData(int.parse(tableNumberController.text.trim()),
                        int.parse(tableCapacityController.text.trim()),
                        tableTypeController.text.trim()),
                ),
              )
            ], //Children
            ),
        ),
    ),
  );



  void newTableData(int tableNum, int maxCapacity, String tableType ) async {
    CollectionReference users = FirebaseFirestore.instance.collection('tables');
    String tableId = users
        .doc()
        .id
        .toString()
        .trim();
    users
        .doc(tableId)
        .set(
        {
          'tableNum': tableNum,
          'maxCapacity': maxCapacity,
          'restaurantID': 'nWF0W1HOINa3WyVRM8Em', //TODO ADD RESTAURANT ID
          'type': tableType,
          'waiterID': '',
          'available': true,
          'currentCapacity': 0,
        }
    );

    Navigator.of(context).
    push(MaterialPageRoute(builder:(context)=>GenerateQRCode(tableId, tableNum.toString())));
  }
  
}
