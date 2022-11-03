import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class RequestTile extends StatefulWidget {
  final String taskName;
  var time;

  final String orderID;
  final String oStatus;


  final String tableID;
  final String orderDoc;

  final bool inactive;


  RequestTile({
    super.key,
    required this.taskName,
    //  required this.taskCompleted,
    //required this.onChanged,
    // required this.deleteFunction,
    required this.time,
    required this.orderID,
    required this.oStatus,
    required this.tableID,
    required this.orderDoc,
    required this.inactive,
  });

  @override
  State<RequestTile> createState() => _RequestTileState();
}



class _RequestTileState extends State<RequestTile> {
  var newTime = "";
  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = Colors.white;
  Color iPColor = Colors.white;
  Color dColor = Colors.white;

  Color pTexColor = Colors.black;
  Color ipTexColor = Colors.black;
  Color dTexColor = Colors.black;


  @override
  Widget build(BuildContext context) {
    /*@override
    void dispose() {

      super.dispose();
    }*/

    var isVisible = true;


    if (widget.oStatus == "in progress"){
      iPColor= Colors.black;
      ipTexColor = Colors.white;
      pColor = Colors.white;
      pTexColor = Colors.black;

    }
    else if (widget.oStatus =="placed"){
      pColor = Colors.black;
      pTexColor = Colors.white;
      ipTexColor = Colors.black;
      iPColor = Colors.white;

    } else {
      dColor = Colors.black;
      dTexColor = Colors.white;
    }

    convertTime(widget.time);

    if (widget.inactive){
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
              Text(widget.taskName + '\nTime Placed: ' + newTime,
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
                          foregroundColor: pTexColor,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),

                        onPressed: () => updatePlaced(),
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
                          foregroundColor: ipTexColor,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),

                        onPressed: () => updateInProgress(),
                        child: Text('In Progress')),
                  ),

                  Visibility(
                    visible: isVisible,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          fixedSize: Size(100, 30),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: dColor,
                          foregroundColor: dTexColor,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),

                        onPressed: () {
                          updateDelivered();
                        },
                        child: const Text('Delivered')
                    ),
                  )

                ],
              ),

            ],
          ),
        ),
      );
    } else {
      return StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1), (time) {
            Duration duration = DateTime.now().difference(widget.time.toDate());
            //String hours = duration.inHours.toString().padLeft(0, '2');
            String minutes = duration.inMinutes.toString().padLeft(1, '0');
            //String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
            return '\nOrdered ${minutes} minutes ago';
          }),
          builder: (context, snapshot){
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
                    Text(widget.taskName + (snapshot.data ?? '\nLoading. . .'),
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
                                foregroundColor: pTexColor,
                                side: const BorderSide(
                                  color: Colors.black38,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),

                              onPressed: () => updatePlaced(),
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
                                foregroundColor: ipTexColor,
                                side: const BorderSide(
                                  color: Colors.black38,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),

                              onPressed: () => updateInProgress(),
                              child: Text('In Progress')),
                        ),

                        Visibility(
                          visible: isVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(5),
                                fixedSize: Size(100, 30),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                backgroundColor: dColor,
                                foregroundColor: dTexColor,
                                side: const BorderSide(
                                  color: Colors.black38,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),

                              onPressed: () {
                                updateDelivered();
                              },
                              child: const Text('Delivered')
                          ),
                        )

                      ],
                    ),

                  ],
                ),
              ),
            );
          }
      );
    }
    //Duration duration = DateTime.now().difference(DateTime.parse(time.toDate().toString()));
  }


  Future updatePlaced() async {
    var status = await FirebaseFirestore.instance.collection('orders').doc(widget.orderID).get();
    if (status['status'] != 'placed'){
      await status.reference.update({
        'status': 'placed'
      });
      await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableOrders').doc(widget.orderDoc).get().then(
              (value) async {
                if (value.exists){
                  await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableOrders').doc(widget.orderDoc).update({
                    'status': 'placed'
                  });
                }
              });
    }
  }

  Future updateInProgress() async {
    var status = await FirebaseFirestore.instance.collection('orders').doc(widget.orderID).get();
    if (status['status'] != 'in progress'){
      await status.reference.update({
        'status': 'in progress'
      });
      await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableOrders').doc(widget.orderDoc).get().then(
              (value) async {
            if (value.exists){
              await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableOrders').doc(widget.orderDoc).update({
                'status': 'in progress'
              });
            }
          });
    }
  }

 Future updateDelivered() async {
   var status = await FirebaseFirestore.instance.collection('orders').doc(widget.orderID).get();
   if (status['status'] != 'delivered'){
     await status.reference.update({
       'status': 'delivered',
       'timeDelivered': Timestamp.now(),
     });
     await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableOrders').doc(widget.orderDoc).get().then(
             (value) async {
           if (value.exists){
             await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableOrders').doc(widget.orderDoc).update({
               'status': 'delivered',
               'timeDelivered': Timestamp.now(),
             });
           }
         });
   }
 }

  //converts firebase time into human readable time
  convertTime(time) {
    DateFormat formatter = DateFormat('h:mm:ss ');
    //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
    newTime = formatter.format(time.toDate());
  }
}
