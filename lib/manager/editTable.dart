import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import '../widgets/customBackButton.dart';
import 'GenerateQRCode.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/selectRestaurant.dart';

class EditTable extends StatefulWidget {
  final String tableID, restName, restID, tableType, tableLoc;
  final int tableNum, tableMaxCap;
  EditTable({Key? key, required this.tableID, required this.restName, required this.restID,
    required this.tableNum, required this.tableType,
    required this.tableLoc, required this.tableMaxCap, }) : super(key: key);
  @override
  State<EditTable> createState() => _EditTable();
}


class _EditTable extends State<EditTable> {
  final tableNumberController = TextEditingController();
  final tableCapacityController = TextEditingController();
  final tableTypeController = TextEditingController();
  final tableLocationController = TextEditingController();
  int numb = 0;
  late Map documents;
  final numberPattern = RegExp(r'^[1-9]\d*(\.\d+)?$');
  String title = '';
  @override
  void initState() {
    title = '${widget.restName}: Table ${widget.tableNum}';

  //set default text
    tableNumberController.text = widget.tableNum.toString();
    tableCapacityController.text = widget.tableMaxCap.toString();
    tableTypeController.text = widget.tableType;
    tableLocationController.text = widget.tableLoc;
    super.initState();
  }


  @override
  Widget build(BuildContext context)=> Scaffold (
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: Text("Edit Table"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              CustomBackButton(
                  onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'table')));
              }),
              Text(title,style: const TextStyle(fontSize: 20),),

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
                      text: "update",
                      onPressed: () async {
                        bool status = await checkTableNumber(int.parse(tableNumberController.text.trim()));
                        if(tableNumberController.text == widget.tableNum.toString() &&
                            tableCapacityController.text == widget.tableMaxCap.toString() &&
                            tableLocationController.text == widget.tableLoc &&
                            tableTypeController.text == widget.tableType){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Update failed, there is no information to change.'),
                          ));
                        } else if (status){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('A table already exists with that number.'),
                          ));
                        } else {
                          newTableData(int.parse(tableNumberController.text.trim()),
                              int.parse(tableCapacityController.text.trim()),
                              tableTypeController.text.trim(),
                              tableLocationController.text.trim());
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
          'restID': widget.restID,
          'restName' : widget.restName,
          'type': tableType,
          'waiterID': '',
          'waiterName' : '',
          'currentCapacity': 0,
          'location' : location,
          'billRequested' : false
        }
    );

    Navigator.of(context).
    push(MaterialPageRoute(builder:(context)=>GenerateQRCode(tableId, tableNum.toString())));
  }

  checkTableNumber(int tableNumber) async {
    bool flag = false;
    await FirebaseFirestore.instance.collection('tables').where('restID', isEqualTo: widget.restID).get().then(
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

