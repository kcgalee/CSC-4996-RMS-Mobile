import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
import 'package:restaurant_management_system/widgets/orderTile.dart';

import '../widgets/customSubButton.dart';
import '../widgets/dialog_box.dart';
import '../widgets/request_tile.dart';
import 'Models/createOrderInfo.dart';



class ViewOrder extends StatefulWidget {
  final tableID, restName, restID;
  CreateOrderInfo createOrderInfo;

  ViewOrder({Key? key, required this.tableID,
    required this.restName, required this.restID, required this.createOrderInfo}) : super(key: key);

  @override
  State<ViewOrder> createState() => _ViewOrder(tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo );
}



class _ViewOrder extends State<ViewOrder> {
  CreateOrderInfo createOrderInfo;

  final tableID, restName, restID;

  _ViewOrder({Key? key, required this.tableID,
    required this.restName, required this.restID, required this.createOrderInfo});

  final _controller = TextEditingController();
  List<String> tableDocList = [];

  //List of task
  List toDoList = [];

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  //save new task
  void saveNewTask() {
    setState(() {
      toDoList.add([ _controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  // create new task
  void createNewTask() {
    showDialog(context: context, builder: (context) {
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancle: () => Navigator.of(context).pop(),
      );
    },);
  }

  //delete tasks
  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Current Order',),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Expanded(
                child:
                ListView.builder(
                    itemCount: createOrderInfo.itemID.length,
                    itemBuilder: (context, index) {
                      return OrderTile(
                        taskName: createOrderInfo.itemName[index] + "\n" +
                            createOrderInfo.count[index].toString()
                            + "\n" + createOrderInfo.price[index].toString(),
                        createOrderInfo: createOrderInfo,
                      );
                    }
                )
            ),

            CustomSubButton(text: "PLACE ORDER",
                onPressed: () {
                createOrderInfo.placeOrder();
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PlacedOrders(tableID: tableID)));
                }
            ),

          ],
        )
    );
  }


}