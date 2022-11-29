import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class OrdersPlacedTile extends StatelessWidget {
  late final String taskName;
  var time;
  Function(BuildContext) onPressedEdit;
  Function(BuildContext) onPressedDelete;
  final VoidCallback? onTap;

  var newTime = "";
  final String oStatus;

  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = Colors.white;
  Color iPColor = Colors.white;
  Color dColor = Colors.white;

  Color pTextColor = Colors.black;
  Color ipTextColor = Colors.black;
  Color dTextColor = Colors.black;

  var price;
  late var newPrice;

  OrdersPlacedTile({
    super.key,
    required this.taskName,
    required this.time,
    required this.oStatus,
    required this.onPressedEdit,
    required this.onPressedDelete,
    required this.onTap,
    required this.price
  });

  @override
  Widget build(BuildContext context) {
    var isVisible = true;


    if (oStatus == "in progress"){
      iPColor= Colors.black;
      ipTextColor = Colors.white;
      pColor = Colors.white;
      pTextColor = Colors.black;

    }
    else if (oStatus =="placed"){
      pColor = Colors.black;
      pTextColor = Colors.white;
      ipTextColor = Colors.black;
      iPColor = Colors.white;

    } else {
      dColor = Colors.black;
      dTextColor = Colors.white;
    }


    return InkWell(
        onTap: onTap,
      child: FutureBuilder(
        future: convertTime(time),
        builder: (context, snapshot) {
          return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
              child: Slidable(
                endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: onPressedEdit,
                        icon: Icons.edit_note,
                        label: 'EDIT',
                        backgroundColor: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SlidableAction(
                        onPressed: onPressedDelete,
                        icon: Icons.delete,
                        label: 'DELETE',
                        backgroundColor: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      )
                    ]
                ),
                child: Container(
                  padding: const EdgeInsets.only(
                      right: 15, left: 10, bottom: 10, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //task name and time
                      Text(taskName + '\n$newPrice' + '\nTime Placed $newTime',
                          style: const TextStyle(color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: isVisible,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                  fixedSize: const Size(100, 3),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  backgroundColor: pColor,
                                  foregroundColor: pTextColor,
                                  side: const BorderSide(
                                    color: Colors.black38,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),

                                onPressed: () => "hello",
                                child: Text('Placed')),
                          ),

                          Visibility(
                            visible: isVisible,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(5),
                                  fixedSize: Size(100, 30),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  backgroundColor: iPColor,
                                  foregroundColor: ipTextColor,
                                  side: const BorderSide(
                                    color: Colors.black38,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),

                                onPressed: () => "Hello",
                                child: Text('In Progress')),
                          ),

                          Visibility(
                            visible: isVisible,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                  fixedSize: Size(100, 3),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  backgroundColor: dColor,
                                  foregroundColor: dTextColor,
                                  side: const BorderSide(
                                    color: Colors.black38,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),

                                onPressed: () => "hello",
                                child: Text('Delivered')),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              )
          );
        },
      )
    );
  }


convertTime(time) {

   DateFormat formatter = DateFormat('h:mm:ss a');
   //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
   newTime = formatter.format(time.toDate());
   if(price == '0.00'){
     newPrice = 'Free';
   }
   else{
     newPrice = '\$$price';
   }
 }


  }





  //converts firebase time into human readable time
