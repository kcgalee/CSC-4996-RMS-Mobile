import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';
import 'package:restaurant_management_system/customer/order.dart';
import 'package:restaurant_management_system/customer/pastOrders.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
import 'package:restaurant_management_system/customer/submitReview.dart';
import 'package:restaurant_management_system/customer/tableStatus.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import '../widgets/customSubButton.dart';
import '../widgets/pastOrdersTile.dart';
import 'qrScanner.dart';
import 'package:restaurant_management_system/customer/Utility/navigation.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  CreateOrderInfo createOrderInfo =
      CreateOrderInfo(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: const Color(0xff76bcff),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              //=====================================
              //Customer User Document Stream Builder
              //=====================================

              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    //User not assigned to a table
                    if (userSnapshot.hasData) {
                      if (userSnapshot.data!['tableID'] == '') {
                        return Column(children: [
                          Container(
                              padding: const EdgeInsets.all(40),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: Color(0xff76bcff),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0,
                                  )
                                ],
                              ),
                              child: Column(children: [
                                CustomMainButton(
                                    text: "QR SCAN",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const QRScanner()),
                                      );
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(children:  const [
                                  Text(
                                    "Welcome!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.white),
                                  ),
                                ]),
                                Row(
                                  children: const [
                                    Text(
                                      "Please scan the QR code at your table once seated.",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ])),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: Column(
                            children: [
                              Row(
                                children: const [
                                  Padding(
                                      padding: EdgeInsets.only(left: 20),
                                    child:
                                      Text("PAST ORDERS",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  )
                                ],
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('orders')
                                      .where('custID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                      .where('itemName', whereNotIn: ['Request Bill', 'Request Waiter', 'condiment', 'utensil'])
                                      .orderBy('itemName')
                                      .orderBy('timePlaced', descending: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                                      return Center(child:Text('You have no past orders'));
                                    } else {
                                      return
                                        SizedBox(
                                            height: 400.0,
                                            child: ListView.builder(
                                            itemCount: snapshot.data?.docs.length,
                                            itemBuilder: (context, index) {
                                              return PastOrdersTile(
                                                taskName:
                                                'Item: ' + (snapshot.data?.docs[index]['itemName'] ?? ''),
                                                time: snapshot.data?.docs[index]['timePlaced'],
                                                oStatus: (snapshot.data?.docs[index]['status'] ?? ''),
                                                restID: (snapshot.data?.docs[index]['restID'] ?? ''),
                                                //restName: snapshot.data?.docs[index]['restName'],
                                              );
                                            }
                                        ),

                                      );

                                    }
                                  }),
                            ],
                          )),
                        ]);
                      } else {
                        if (userSnapshot.data!['tableID'] != '') {
                          return SingleChildScrollView(
                            child: Center(
                              child: Column(children: [
                                //============================
                                //Table document Snapshot stream builder
                                //=============================
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('tables')
                                        .doc(userSnapshot.data!['tableID'])
                                        .snapshots(),
                                    builder: (context, tableSnapshot) {
                                      if (tableSnapshot.hasData) {
                                        return Column(children: [
                                          Container(
                                              padding: const EdgeInsets.all(40),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                                color: Color(0xff76bcff),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(5.0, 5.0),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 1.0,
                                                  )
                                                ],
                                              ),
                                              child: Column(children: [

                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(children: [
                                                  Text(
                                                    tableSnapshot
                                                        .data!['restName'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 40,
                                                        color: Colors.white),
                                                  ),
                                                ]),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Table ",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      tableSnapshot
                                                          .data!['tableNum']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                if (tableSnapshot
                                                        .data!['waiterName'] !=
                                                    '')
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Waiter ",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        tableSnapshot
                                                            .data!['waiterName']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                              ])),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Center(
                                              child: Column(
                                            children: [
                                              //Menu Button
                                              CustomMainButton(
                                                  text: "MENU",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => Order(
                                                              tableID:
                                                                  tableSnapshot
                                                                      .data!.id,
                                                              restName:
                                                                  tableSnapshot
                                                                          .data![
                                                                      'restName'],
                                                              restID:
                                                                  tableSnapshot
                                                                          .data![
                                                                      'restID'],
                                                              createOrderInfo:
                                                                  createOrderInfo)),
                                                    );
                                                  }),

                                              //Current Order Button
                                              CustomSubButton(
                                                  text: "CURRENT ORDER",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const PlacedOrders()),
                                                    );
                                                  }),

                                              //Table Status Button
                                              CustomSubButton(
                                                  text: "TABLE STATUS",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => TableStatus(
                                                              tableNum: tableSnapshot
                                                                  .data![
                                                                      'tableNum']
                                                                  .toString(),
                                                              waiterName:
                                                                  tableSnapshot
                                                                          .data![
                                                                      'waiterName'])),
                                                    );
                                                  }),

                                              //Submit Review Button
                                              CustomSubButton(
                                                  text: "SUBMIT REVIEW",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SubmitReview()),
                                                    );
                                                  }),

                                              CustomSubButton(
                                                  text: "REQUEST WAITER",
                                                  onPressed: () {
                                                    if (tableSnapshot.data![
                                                            'waiterID'] !=
                                                        '') {
                                                      createOrderInfo.request(
                                                          'Request Waiter',
                                                          tableSnapshot
                                                              .data!.id,
                                                          tableSnapshot
                                                              .data!['tableNum']
                                                              .toString(),
                                                          tableSnapshot.data![
                                                              'waiterID'],
                                                          tableSnapshot
                                                              .data!['restID']);

                                                      //Display message that waiter has been requested
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Alert!'),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                      'Waiter has been requested!'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }

                                                    //NO WAITER AT TABLE ERROR
                                                    else {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Alert!'),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                      'Waiter Must be assigned to your table before you can submit a request.'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }),

                                              //=====================
                                              //BILL REQUESTED BUTTON
                                              //======================
                                              CustomSubButton(
                                                  text: "REQUEST BILL",
                                                  onPressed: () {
                                                    if (tableSnapshot.data![
                                                            'billRequested'] !=
                                                        true) {
                                                      createOrderInfo
                                                          .billRequest(
                                                              'Request Bill',
                                                              tableSnapshot
                                                                  .data!.id,
                                                              tableSnapshot
                                                                  .data![
                                                                      'tableNum']
                                                                  .toString(),
                                                              tableSnapshot
                                                                      .data![
                                                                  'waiterID'],
                                                              tableSnapshot
                                                                      .data![
                                                                  'restID']);

                                                      //Display message that bill has been requested
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Alert!'),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                      'Bill request sent!'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }

                                                    //NO WAITER AT TABLE ERROR
                                                    else if (tableSnapshot
                                                                .data![
                                                            'waiterID'] ==
                                                        '') {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Alert!'),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                      'Waiter Must be assigned to your table before you can submit a request.'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                    //BILL ALREADY REQUESTED ERROR
                                                    else if (tableSnapshot
                                                                .data![
                                                            'billRequested'] ==
                                                        true) {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Alert!'),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                      'Bill has already been requested.'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }),

                                              CustomSubButton(
                                                  text: "PAST ORDERS",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                           PastOrders()),
                                                    );
                                                  }),

                                            ],
                                          )),
                                        ]);
                                      } else {
                                        return const Center(
                                          child: Text("ERROR, NO TABLE"),
                                        );
                                      } //end of if document has data
                                    } // end of tableSnapshot builder

                                    ),

                                //================================
                                //End of table doc stream builder
                                //===============================
                              ]),
                            ),
                          );
                        }
                      }
                    }

                    return const Center(
                      child: Text("ERROR, NO TABLE"),
                    );

                    //================================
                  } //End of customer User Doc Builder
                  //===============================

                  ),
              //=====================================
              // End of Customer User Document Stream Builder
              //=====================================
            ]),
          ),
        ));
  }
}
