

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restaurant_management_system/Models/restaurantInfo.dart';

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
  var documents;

  @override
  Widget build(BuildContext context)=> Scaffold (
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: Text("Add Table"),
      ),
      body: FutureBuilder(
      future: getRestInfo(),
  builder: (context, snapshot) {
  return SingleChildScrollView(
  child: Center(
  child: Column(
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
      child: ElevatedButton(child: const Text("Add Table"),
        onPressed: () =>
            newTableData(int.parse(tableNumberController.text.trim()),
                int.parse(tableCapacityController.text.trim()),
                tableTypeController.text.trim()),
      ),
    )




  ]),
      )
        );
           }),
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

  getRestInfo() async {
    var uID = FirebaseAuth.instance.currentUser?.uid.toString();
    final docRef = FirebaseFirestore.instance.collection('restaurants').where(
        'managerID', isEqualTo: uID).snapshots();
    documents = await docRef.toList();
  }


}

