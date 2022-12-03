import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class RequestTile extends StatefulWidget {
  final String tableNum;
  final String request;
  final String customerName;
  final String comment;
  Icon orderIcon;

  Color boxColor;

  var time;

  final String orderID;
  final String oStatus;


  final String tableID;
  final String orderDoc;

  final bool inactive;
  final bool tableStatus;

  RequestTile({
    super.key,
    required this.tableNum,
    required this.request,
    required this.customerName,
    required this.comment,
    required this.time,
    required this.orderIcon,
    required this.orderID,
    required this.oStatus,
    required this.tableID,
    required this.orderDoc,
    required this.inactive,
    required this.boxColor,
    required this.tableStatus,
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

  Color pTextColor = Colors.black;
  Color ipTextColor = Colors.black;
  Color dTextColor = Colors.black;



  @override
  Widget build(BuildContext context) {

    var isVisible = true;


    if (widget.oStatus == "in progress"){
      iPColor= Colors.black;
      ipTextColor = Colors.white;
      pColor = Colors.white;
      pTextColor = Colors.black;

    }
    else if (widget.oStatus =="placed"){
      pColor = Colors.black;
      pTextColor = Colors.white;
      ipTextColor = Colors.black;
      iPColor = Colors.white;

    } else {
      dColor = Colors.black;
      dTextColor = Colors.white;
    }

    convertTime(widget.time);

    // PAST REQUESTS TILE

    if (widget.inactive){
      //color for time
      Color timeColor = Colors.black;
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(right: 15,left: 10,bottom: 10,top: 10),
          decoration: BoxDecoration(color: widget.boxColor,
              borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //required fields
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xff7678ff),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0)),
                    ),
                    child: Text(widget.tableNum,
                        style: const TextStyle(color: Colors.white,fontSize: 15,)
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only( left: 10, right: 10, top: 5, bottom: 5),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0)),
                    ),
                    child: Text(widget.customerName ,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black,fontSize: 15, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.request,
                  style: const TextStyle(color: Colors.black,fontSize: 15,)),
              Text(widget.comment,
                  style: const TextStyle(color: Colors.black,fontSize: 15,)),
              Text('Time Placed: ' + newTime,
                  style: TextStyle(color: timeColor,fontSize: 15,)),

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
                          foregroundColor: pTextColor,
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
                          foregroundColor: ipTextColor,
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
                          foregroundColor: dTextColor,
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

      // CURRENT REQUESTS TILE

      //color for time
      Color timeColor = Colors.black;
      return StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1), (time) {
            Duration duration = widget.time.toDate().difference(DateTime.now());
            String hours = duration.inHours.toString().padLeft(0, '2').replaceAll('-', '');
            String minutes = duration.inMinutes.remainder(60).toString().padLeft(1, '0').replaceAll('-', '');
            if (hours != '0'){
              //if order placed an hour or more ago, then change time color to red
              timeColor = Colors.red;
                if (hours == '1'){
                  return 'Ordered $hours hr ago';
                } else {
                  return 'Ordered $hours hrs ago';
                }
            } else {
              if (int.parse(minutes) >= 35){
                //if order placed 35min or more ago, then change time color to yellow
                timeColor = Colors.yellow.shade900;
              }
              return 'Ordered $minutes mins ago';
            }
            //String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
          }),
          builder: (context, snapshot){
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15,top: 10),
              child: Container(
                padding: const EdgeInsets.only(right: 15,left: 10,bottom: 10,top: 10),
                decoration: BoxDecoration(color: widget.boxColor,
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //task name and time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              decoration: const BoxDecoration(
                                color: Color(0xff7678ff),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),
                                    bottomLeft: Radius.circular(40.0)),
                              ),
                              child: Text(widget.tableNum,
                                  style: const TextStyle(color: Colors.white,fontSize: 15,)
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only( left: 10, right: 10, top: 5, bottom: 5),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.5,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(40.0),
                                    bottomRight: Radius.circular(40.0)),
                              ),
                              child: Text(widget.customerName ,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black,fontSize: 15, fontWeight: FontWeight.bold)
                              ),
                            ),
                          ],
                        ),

                        widget.orderIcon
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(widget.request,
                        style: const TextStyle(color: Colors.black,fontSize: 15,)),
                    Text(widget.comment,
                        style: const TextStyle(color: Colors.grey,fontSize: 15,)),
                    Text((snapshot.data ?? 'Loading. . .'),
                        style: TextStyle(color: timeColor,fontSize: 15,)),

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
                                foregroundColor: pTextColor,
                                side: const BorderSide(
                                  color: Colors.black38,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),

                              onPressed: () async {
                                await updatePlaced();
                              },
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
                                foregroundColor: ipTextColor,
                                side: const BorderSide(
                                  color: Colors.black38,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),

                              onPressed: () async {
                                await updateInProgress();
                              },
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
                                foregroundColor: dTextColor,
                                side: const BorderSide(
                                  color: Colors.black38,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),

                              onPressed: () async {
                                await updateDelivered();
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
    var flag = widget.tableStatus;
    if (flag != true) {
      var status = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderID)
          .get();
      var oID = widget.orderID;

      if (status['status'] != 'placed') {
        await status.reference.update({'status': 'placed'});
        await FirebaseFirestore.instance
            .collection('tables/${widget.tableID}/tableOrders')
            .doc(oID)
            .get()
            .then((value) async {
          if (value.exists) {
            await FirebaseFirestore.instance
                .collection('tables/${widget.tableID}/tableOrders')
                .doc(oID)
                .update({'status': 'placed'});
          }
        });
      }
    }
  }

  Future updateInProgress() async {
    var flag = widget.tableStatus;
    if (flag != true){
      var status = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderID)
          .get();
      var oID = widget.orderID;

      if (status['status'] != 'in progress') {
        await status.reference.update(
            {'status': 'in progress', 'timeInProgress': Timestamp.now()});
        await FirebaseFirestore.instance
            .collection('tables/${widget.tableID}/tableOrders')
            .doc(oID)
            .get()
            .then((value) async {
          if (value.exists) {
            await FirebaseFirestore.instance
                .collection('tables/${widget.tableID}/tableOrders')
                .doc(oID)
                .update({
              'status': 'in progress',
              'timeInProgress': Timestamp.now()
            });
          }
        });
      }
    }
  }

 Future updateDelivered() async {
   var flag = widget.tableStatus;
   if (flag != true) {
      var status = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderID)
          .get();
      var oID = widget.orderID;

      if (status['status'] != 'delivered') {
        await status.reference.update({
          'status': 'delivered',
          'timeDelivered': Timestamp.now(),
        });
        await FirebaseFirestore.instance
            .collection('tables/${widget.tableID}/tableOrders')
            .doc(oID)
            .get()
            .then((value) async {
          if (value.exists) {
            await FirebaseFirestore.instance
                .collection('tables/${widget.tableID}/tableOrders')
                .doc(oID)
                .update({
              'status': 'delivered',
              'timeDelivered': Timestamp.now(),
            });
          }
        });

        //check to see if request is Waiter Request
        if (widget.request == "Requested: Waiter") {
          //if its true update table document to make waiterRequested false
          await FirebaseFirestore.instance
              .collection('tables')
              .doc(widget.tableID)
              .update({'waiterRequested': false});
        }
      }
    }
  }

  //converts firebase time into human readable time
  convertTime(time) {
    DateFormat formatter = DateFormat('h:mm:ss');
    //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
    newTime = formatter.format(time.toDate());
  }
}
