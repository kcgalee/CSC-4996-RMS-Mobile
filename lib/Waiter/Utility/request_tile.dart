import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:flutter_slidable/flutter_slidable.dart';


class RequestTile extends StatelessWidget {

 final String taskName;
 var time;
  //final bool taskCompleted;
 // Function(bool?)? onChanged;
  //Function(BuildContext)? deleteFunction;
 var newTime = "";
 final String orderID;
 final String oStatus;

 //iPColor for in progress button, dColor for delivered button, these are the base default colors.
 Color iPColor = Color(0x36F1D385);
 Color dColor = Color(0x3090C68E);


 RequestTile({
    super.key,
    required this.taskName,
  //  required this.taskCompleted,
    //required this.onChanged,
   // required this.deleteFunction,
    required this.time,
    required this.orderID,
    required this.oStatus,
  });

  @override
  Widget build(BuildContext context) {
    var isVisible = true;


    if (oStatus == "in progress"){
      iPColor = Color(0xFFF1D385);
    }

    return FutureBuilder(
      future: convertTime(time),
      builder: (context, snapshot) {
        return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15,top: 25),
            child: Container(
              padding: const EdgeInsets.only(right: 5,left: 10,bottom: 10,top: 10),
              decoration: BoxDecoration(color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54)
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    //checkbox
                    /*Checkbox(
                      value: taskCompleted,
                      onChanged: onChanged,
                      activeColor: Colors.black,
                    ),*/

                    //task name and time
                    Text(taskName + '\n' + newTime,
                    style: const TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.bold)),

                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Visibility(
                        visible: isVisible,
                        child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
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
                              borderRadius: BorderRadius.circular(40)),
                        ),

                          onPressed: () => updateInProgress(),
                          child: const Text('in progress')),
                    )),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
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
                              borderRadius: BorderRadius.circular(40)),
                        ),

                        onPressed: () => updateDelivered(),
                        child: const Text('delivered')
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }

  Future updateInProgress() async {
    var status = await FirebaseFirestore.instance.collection('orders').doc(orderID).get();
    if (status['status'] == 'placed'){
      await status.reference.update({
        'status': 'in progress'
      });

    }
  }

 Future updateDelivered() async {
   var status = await FirebaseFirestore.instance.collection('orders').doc(orderID).get();
   if ((status['status'] == 'placed') || (status['status'] == 'in progress')){
     await status.reference.update({
       'status': 'delivered'
     });
   }
 }

  //converts firebase time into human readable time
  convertTime(time) {
    DateFormat formatter = DateFormat('MMM d, yyyy \nh:mm:s a');
    //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
    newTime = formatter.format(time.toDate());
  }
}
