import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import '../widgets/customBackButton.dart';
import 'GenerateQRCode.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/selectRestaurant.dart';
/*
This page is for adding new table to a restaurant
 */


class AddTable extends StatefulWidget {
  final String text, restName;
  AddTable({Key? key, required this.text, required this.restName}) : super(key: key);
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
          //Back button
          CustomBackButton(onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'table')));
          }),
          //restaurant name
          Text(widget.restName,style: const TextStyle(fontSize: 20),),
          const SizedBox(height: 20,),

        Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CustomTextForm(
              hintText: "Table number",
              controller: tableNumberController,
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 2,
              validator: (tablenum) =>
              tablenum != null && !numberPattern.hasMatch(tablenum)
                  ? 'number must be between 1 to 99 ' : null,
              icon: const Icon(Icons.numbers, color: Colors.black)
        ),),

        Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CustomTextForm(
              hintText: "Table Location",
              controller: tableLocationController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              maxLength: 20,
              validator: (tableLoc) =>
              tableLoc != null && tableLoc.trim().length > 20
                  ? 'Text must be between 1 to 20 characters' : null,
              icon: const Icon(Icons.location_on, color: Colors.black)
          ),),

      Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: CustomTextForm(
              hintText: "Table Capacity",
              controller: tableCapacityController,
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 2,
              validator: (maxCapacity) =>
              maxCapacity != null && !numberPattern.hasMatch(maxCapacity)
                  ? 'number must be between 1 to 99' : null,

              icon: const Icon(Icons.people, color: Colors.black)
          ),),

      Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: CustomTextForm(
              hintText: "Table Type",
              controller: tableTypeController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              maxLength: 20,
              validator: (tableType) =>
              tableType != null && tableType.trim().length > 20
                  ? 'Text must be between 1 to 20 characters' : null,
              icon: Icon(Icons.table_bar, color: Colors.black)
          ),),

      Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: CustomMainButton(
            text: "Add Table",
            onPressed: () async {
              if (tableNumberController.text.trim() == '' ||
                  tableNumberController.text.trim().contains(RegExp(r'[A-Z|a-z]')) ||
                  tableNumberController.text.trim() == '0' ||
                  tableCapacityController.text.trim() == '' ||
                  tableCapacityController.text.trim() == '0' || tableCapacityController.text.trim().contains(RegExp(r'[A-Z|a-z]'))){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Table could not be created.'),
                ));
              } else {
                bool status = await checkTableNumber(int.parse(tableNumberController.text.trim()));
                if(!status){
                  newTableData(int.parse(tableNumberController.text.trim()),
                      int.parse(tableCapacityController.text.trim()),
                      tableTypeController.text.trim(),
                      tableLocationController.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('A table already exists with that number.'),
                  ));
                }
              }
            }
            ),),
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
          'restName' : widget.restName,
          'type': tableType,
          'waiterID': '',
          'waiterName' : '',
          'currentCapacity': 0,
          'location' : location,
          'billRequested' : false,
          'waiterRequested' : false
        }
    );

    Navigator.of(context).
    push(MaterialPageRoute(builder:(context)=>GenerateQRCode(tableId, tableNum.toString())));
  }

  checkTableNumber(int tableNumber) async {
    bool flag = false;
    await FirebaseFirestore.instance.collection('tables').where('restID', isEqualTo: text).get().then(
            (value) {
              value.docs.forEach((element) {
                if (element['tableNum'] == tableNumber) {
                  flag = true;
                }
              });
            });
    return flag;
   }
}

