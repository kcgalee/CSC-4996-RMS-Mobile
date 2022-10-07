

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
  final tableLocationController = TextEditingController();
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
          TextField(
            controller: tableNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Table number",
              prefixIcon: Icon(Icons.numbers, color: Colors.black),
            ),
          ),
              TextField(
                controller: tableLocationController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Table Location",
                  prefixIcon: Icon(Icons.location_pin, color: Colors.black),
                ),
              ),

              TextField(
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
                       setState(() {}),
                ),
              )
            ], //Children
            ),
        ),
    ),
  );



  void newTableData() {
    CollectionReference users = FirebaseFirestore.instance.collection('tables');
    users
        .doc()
        .set(
        {
          'tableNum': tableNumberController.toString().trim(),
          'maxCapacity': int.parse(tableCapacityController.toString().trim()),
          'restaurantID': '', //TODO ADD RESTAURANT ID
          'type': tableTypeController.toString().trim(),
          'waiterID' : '',
          'available' : true,
          'currentCapacity' : 0
        }


    );

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GenerateQRCode()));
  }
  
  
  
  
}
