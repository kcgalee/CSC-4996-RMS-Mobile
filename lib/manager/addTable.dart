

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';

import '../widgets/customBackButton.dart';
import 'GenerateQRCode.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/selectRestaurant.dart';

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
  final numberPattern = RegExp(r'^[1-9]\d*(\.\d+)?$');
  @override
  Widget build(BuildContext context)=> Scaffold (
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: Text("Add Table"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
        child: Column(
        children: [
          CustomBackButton(onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'table')));
          }),
          CustomTextForm(
            hintText: "Table number",
            controller: tableNumberController,
            keyboardType: TextInputType.number,
            maxLines: 1,
            maxLength: 10,
            validator: (tablenum) =>
            tablenum != null && !numberPattern.hasMatch(tablenum)
                ? 'number must be between 1 to 9999999999 ' : null,
            icon: const Icon(Icons.numbers, color: Colors.black)
        ),

          CustomTextForm(
              hintText: "Table Location",
              controller: tableLocationController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              maxLength: 20,
              validator: (tableLoc) =>
              tableLoc != null && tableLoc.trim().length > 20
                  ? 'Text must be between 1 to 20 characters' : null,
              icon: const Icon(Icons.location_on, color: Colors.black)
          ),
          CustomTextForm(
              hintText: "Table Capacity",
              controller: tableCapacityController,
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 3,
              validator: (maxCapacity) =>
              maxCapacity != null && !numberPattern.hasMatch(maxCapacity)
                  ? 'number must be between 1 to 999' : null,

              icon: const Icon(Icons.people, color: Colors.black)
          ),
          CustomTextForm(
              hintText: "Table Type",
              controller: tableTypeController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              maxLength: 20,
              validator: (tableType) =>
              tableType != null && tableType.trim().length > 20
                  ? 'Text must be between 1 to 20 characters' : null,
              icon: Icon(Icons.table_bar, color: Colors.black)
          ),

          CustomMainButton(
            text: "Add Table",
            onPressed: () async =>
            {
              if(await checkTableNumber(tableNumberController.text.trim())){
                newTableData(int.parse(tableNumberController.text.trim()),
                    int.parse(tableCapacityController.text.trim()),
                    tableTypeController.text.trim(),
                    tableLocationController.text.trim()),
              }
              else {
                print("table number in use.")
              }

            }
            )

        ]),
      )


              );

  void newTableData(int tableNum, int maxCapacity, String tableType, String location ) async {
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
          'waiterName' : '',
          'currentCapacity': 0,
          'location' : location
        }
    );

    Navigator.of(context).
    push(MaterialPageRoute(builder:(context)=>GenerateQRCode(tableId, tableNum.toString())));
  }

  Future<bool> checkTableNumber(String tableNumber) async {
    return true;
   }




}

