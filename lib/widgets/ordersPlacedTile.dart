import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:flutter_slidable/flutter_slidable.dart';


class OrdersPlacedTile extends StatelessWidget {
  late final String taskName;
  var time;
  //final bool taskCompleted;
  // Function(bool?)? onChanged;
  //Function(BuildContext)? deleteFunction;

  var newTime = "";
  final String oStatus;

  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = Color(0xffffebee);
  Color iPColor = Color(0xfff9fbe7);
  Color dColor = Color(0xffe8f5e9);



  OrdersPlacedTile({
    super.key,
    required this.taskName,
    //  required this.taskCompleted,
    //required this.onChanged,
    // required this.deleteFunction,
    required this.time,
    required this.oStatus,
  });

  @override
  Widget build(BuildContext context) {
    var isVisible = true;
    if (oStatus == "delivered"){
      dColor = Colors.green.shade300;
    }

    if (oStatus == "in progress"){
      iPColor= Colors.orange.shade300;
    }

    else if (oStatus =="placed"){
      pColor = Colors.redAccent;
    }


    return FutureBuilder(
      future: convertTime(time),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,top: 25),
          child: Container(
            padding: const EdgeInsets.only(right: 15,left: 10,bottom: 10,top: 10),
            decoration: BoxDecoration(color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //task name and time
                Text(taskName + '\n' + newTime,
                    style: const TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                            backgroundColor: pColor,
                            foregroundColor: Colors.black54,
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
                            fixedSize: Size(100,30),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: iPColor,
                            foregroundColor: Colors.black54,
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
                            foregroundColor: Colors.black54,
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
        );
      },
    );
  }

  convertTime(time) {
    DateFormat formatter = DateFormat('h:mm:ss a');
    //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
    newTime = formatter.format(time.toDate());
  }



  }





  //converts firebase time into human readable time
