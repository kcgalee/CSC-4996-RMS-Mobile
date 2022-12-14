import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';
import 'package:restaurant_management_system/customer/order.dart';
import 'package:restaurant_management_system/customer/pastOrders.dart';
import 'package:restaurant_management_system/customer/pastVisits.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
import 'package:restaurant_management_system/customer/submitReview.dart';
import 'package:restaurant_management_system/customer/tableStatus.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import '../widgets/customSquareButton.dart';
import '../widgets/customSubButton.dart';
import '../widgets/pastVisitsTile.dart';
import 'qrScanner.dart';
import 'package:restaurant_management_system/customer/Utility/navigation.dart';

/*
This is the main page for customer users. After log in the customer user will
end up on this page.  If the customer is not assigned to a table then the page
will display the Scan QR code button, and the users past visits.
When the customer user is assigned to a table the page will display buttons that
the user can use to create orders, view placed orders, view table members, and
leave a review.
 */

class CustomerHome extends StatefulWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  late var openTimeWk,
      openTimeWkEnd,
      closeTimeWk,
      closeTimeWkEnd,
      address,
      holiday,
      phone;
  late double restRating;
  late var ratingCount;

  CreateOrderInfo createOrderInfo =
  CreateOrderInfo(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          drawer: const NavigationDrawer(),
          appBar: AppBar(
            title: const Text('Home'),
            backgroundColor: const Color(0xff76bcff),
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Container(
            color: const Color(0xffEBEBEB),
          child: SingleChildScrollView(
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

                      if (userSnapshot.hasData) {

                        //===================================
                        //User not assigned to a table
                        //====================================
                        if (userSnapshot.data!['tableID'] == '') {
                          return Column(
                              children: [
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
                                      Row(children: const [
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 20, left: 20),
                                                    child: Text(
                                                      "PAST VISITS",
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
                                                  stream: FirebaseFirestore.instance
                                                      .collection('users/${userSnapshot.data?.id}/pastVisits')
                                                      .orderBy('date', descending: true)
                                                      .snapshots(),
                                                  builder: (context, pastVisitSnapshot) {
                                                    if (!pastVisitSnapshot.hasData ||
                                                        (pastVisitSnapshot.data?.size == 0)) {
                                                      return Center(
                                                          child:
                                                          Column(
                                                            children: const [
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Text('You have no past orders.'),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                            ],
                                                          ));
                                                    } else {
                                                      return SizedBox(
                                                        height: 420.0,
                                                        child: ListView.builder(
                                                            itemCount:
                                                            pastVisitSnapshot.data?.docs.length,
                                                            itemBuilder: (context, index) {
                                                              return PastVisitsTile(
                                                                  time: pastVisitSnapshot.data?.docs[index]['date'],
                                                                  waiterName: pastVisitSnapshot.data?.docs[index]['waiterName'],
                                                                  restName: pastVisitSnapshot.data?.docs[index]['restName'],
                                                                  onPressed: () {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => PastOrders(visitID: pastVisitSnapshot.data?.docs[index].id as String)),
                                                                    );
                                                                  });
                                                            }),
                                                      );
                                                    }
                                                  }),
                                            ],
                                          )
                                      )
                                    )
                                ),
                              ]
                          );
                        } else {

                          //==============================
                          //User assigned to a table
                          //================================
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
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.50,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          tableSnapshot
                                                              .data!['restName'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                    ),

                                                    //=======================
                                                    //Restaurant Info Button
                                                    //=======================
                                                    IconButton(
                                                        icon: const Icon(
                                                            Icons.info),
                                                        color: Colors.white,
                                                        onPressed: () async => {
                                                          //Retrieve restaurant open/closing time
                                                          await getRestInfo(
                                                              tableSnapshot
                                                                  .data![
                                                              'restID']),

                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext
                                                            context) =>

                                                            //display restaurant open/closing time, address, phone number
                                                            AlertDialog(
                                                              title: Text(tableSnapshot
                                                                  .data![
                                                              'restName'] +
                                                                  " Info",
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              content: SingleChildScrollView(
                                                                child: ListBody(
                                                                  children: <Widget>[
                                                                    Column(
                                                                      children: [
                                                                        //Restaurant rating


                                                                        if(restRating != -1)
                                                                          Row(
                                                                            children: [
                                                                              RatingBar.builder(
                                                                                itemSize: 40.0,
                                                                                ignoreGestures: true,
                                                                                initialRating: restRating,
                                                                                minRating: 1,
                                                                                direction: Axis.horizontal,
                                                                                allowHalfRating: true,
                                                                                itemCount: 5,
                                                                                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                                                itemBuilder: (context, _) => const Icon(
                                                                                  Icons.star,
                                                                                  color: Colors.amber,
                                                                                ),
                                                                                onRatingUpdate: (restRating) {
                                                                                  restRating;
                                                                                },
                                                                              ),
                                                                              Text('${restRating.toString()}'),
                                                                            ],
                                                                          ),

                                                                        if(restRating != -1 && ratingCount == 1)
                                                                          Text('($ratingCount Review)'),

                                                                        if(restRating != -1 && ratingCount > 1)
                                                                          Text('($ratingCount Reviews)'),

                                                                        const Text(
                                                                            '\nAddress',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.black)),
                                                                        Text(address,
                                                                        ),
                                                                        const Text(
                                                                            '\nPhone Number',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.black)),
                                                                        Text(
                                                                            phone),
                                                                        const Text(
                                                                            "\nWeekday Hours",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.black)),
                                                                        Text(openTimeWk +
                                                                            ' - ' +
                                                                            closeTimeWk),
                                                                        const Text(
                                                                            "\nWeekend Hours",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.black)),
                                                                        Text(openTimeWkEnd +
                                                                            ' - ' +
                                                                            closeTimeWkEnd),

                                                                        if(holiday != '')
                                                                        const Text(
                                                                            "\nHoliday Hours",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.black)),
                                                                        if(holiday != '')
                                                                        Center(
                                                                         child: Text(holiday),
                                                                        )

                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: const Text('OK'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          ),
                                                        })
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
                                                        text: "PAST VISITS",
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    const PastVisits()),
                                                          );
                                                        }),
                                                    const SizedBox(height: 20),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 35, right: 35),
                                                      child: Row(
                                                        children: [
                                                          CustomSquareButton(
                                                              text: "REQUEST WAITER",
                                                              onPressed: () {
                                                                if (tableSnapshot.data![
                                                                'waiterID'] !=
                                                                    '') {


                                                                  //Display message that waiter has been requested
                                                                  if (tableSnapshot
                                                                      .data!['waiterRequested'] ==
                                                                      false) {
                                                                    createOrderInfo
                                                                        .request(
                                                                        'Request Waiter',
                                                                        tableSnapshot
                                                                            .data!.id,
                                                                        tableSnapshot
                                                                            .data!['tableNum']
                                                                            .toString(),
                                                                        tableSnapshot
                                                                            .data![
                                                                        'waiterID'],
                                                                        tableSnapshot
                                                                            .data!['restID']);
                                                                    showDialog<void>(
                                                                      context: context,
                                                                      barrierDismissible:
                                                                      false,
                                                                      // user must tap button!
                                                                      builder: (
                                                                          BuildContext
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
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              child:
                                                                              const Text(
                                                                                  'OK'),
                                                                              onPressed: () {
                                                                                Navigator
                                                                                    .of(
                                                                                    context)
                                                                                    .pop();
                                                                                Navigator
                                                                                    .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) => const PlacedOrders()),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                  //Waiter has been requested
                                                                  else
                                                                  if (tableSnapshot
                                                                      .data!['waiterRequested'] ==
                                                                      true) {
                                                                    showDialog<void>(
                                                                      context: context,
                                                                      barrierDismissible:
                                                                      false,
                                                                      // user must tap button!
                                                                      builder: (
                                                                          BuildContext
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
                                                                                    'Waiter has already been requested.'),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              child:
                                                                              const Text(
                                                                                  'OK'),
                                                                              onPressed: () {
                                                                                Navigator
                                                                                    .of(
                                                                                    context)
                                                                                    .pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
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
                                                          Spacer(),

                                                    //=====================
                                                    //BILL REQUESTED BUTTON
                                                    //======================
                                                    CustomSquareButton(
                                                        text: "REQUEST BILL",
                                                        onPressed: () {
                                                          if (tableSnapshot.data![
                                                          'billRequested'] !=
                                                              true && tableSnapshot.data!['waiterID'] != '') {
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
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => const PlacedOrders()),
                                                                              );
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
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ]);
                                        } else {
                                          return const CircularProgressIndicator();
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

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const <Widget>[
                            CircularProgressIndicator(
                            ),
                          ],
                        ),
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
          )
      )),
    );
  }

  //for restInfo icon gets the data from restaurant collection
  getRestInfo(String restID) async {
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restID)
        .get()
        .then((element) {
      openTimeWk = element['openTimeWKday'];
      closeTimeWk = element['closeTimeWKday'];

      openTimeWkEnd = element['openTimeWKend'];
      closeTimeWkEnd = element['closeTimeWKend'];
      holiday = element['holidayHours'];
      phone = element['phone'];
      address =
      '${element['address']}\n${element['zipcode']} ${element['city']}, ${element['state']}';
    });

    restRating = 0;

    //gets all ratings from restaurant and calculates average rating
    await FirebaseFirestore.instance.collection('reviews').where('restID', isEqualTo: restID).get()
        .then((element) {
      int count = 0;
        for (int i = 0; i < element.docs.length; i++) {
          if (element.docs[i]['restRating'] != null) {
            restRating = element.docs[i]['restRating'] + restRating;
            count++;
          }
        }
        ratingCount = count;
          if (count != 0) {
            restRating = restRating/count;
          }

          else {
            restRating = -1;
          }
    });
  }

}