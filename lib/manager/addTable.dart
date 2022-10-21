

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customSubButton.dart';
import 'package:restaurant_management_system/widgets/customTextFrom.dart';

import 'GenerateQRCode.dart';
import 'Utility/MangerNavigationDrawer.dart';

class AddTable extends StatefulWidget {
  final String text;
  AddTable({Key? key, required this.text}) : super(key: key);
  @override
  State<AddTable> createState() => _AddTable(text: text);
}


class _AddTable extends State<AddTable> {
  final String text;
  _AddTable({Key? key, required this.text});
  final tableNumberController = TextEditingController();
  final tableCapacityController = TextEditingController();
  final tableTypeController = TextEditingController();
  final tableLocationController = TextEditingController();
  int numb = 0;
  late Map documents;

  @override
  Widget build(BuildContext context)=> Scaffold (
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: Text("Add Table"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
    children: [


    CustomTextFrom(
        hintText: "Table number",
        controller: tableNumberController,
        icon: const Icon(Icons.numbers, color: Colors.black)
    ),

      CustomTextFrom(
          hintText: "Table Location",
          controller: tableLocationController,
          icon: const Icon(Icons.location_on, color: Colors.black)
      ),
      CustomTextFrom(
          hintText: "Table Capacity",
          controller: tableCapacityController,
          icon: const Icon(Icons.people, color: Colors.black)
      ),
      CustomTextFrom(
          hintText: "Table Type",
          controller: tableTypeController,
          icon: Icon(Icons.table_bar, color: Colors.black)
      ),

      CustomMainButton(
        text: "Add Table",
        onPressed: () =>
        newTableData(int.parse(tableNumberController.text.trim()),
            int.parse(tableCapacityController.text.trim()),
            tableTypeController.text.trim()),)

    ]),
  ),
      )


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
          'restID': text,
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

