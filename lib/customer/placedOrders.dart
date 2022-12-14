import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';
import '../widgets/customSubButton.dart';
import '../widgets/customTextForm.dart';
import 'Utility/navigation.dart';
import 'customerHome.dart';

/*
This page displays all orders placed by customer users currently assigned
to the table.  Each tile will be tappable (unless it is a bill or waiter request),
editable and deletable.  The order progress will update as the waiter updates it.
The orders are selected from the tableOrders collection of the database. This
collection is located in the tables collection inside the table document the
customer user is assigned to.
 */

class PlacedOrders extends StatefulWidget {
  const PlacedOrders({Key? key}) : super(key: key);

  @override
  State<PlacedOrders> createState() => _PlacedOrders();
}

class _PlacedOrders extends State<PlacedOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Current Orders'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData) {
                    //===============================
                    //ERROR HANDLING FOR CLOSED TABLE
                    //===============================

                    if (userSnapshot.data!['tableID'] == '') {
                      return Column(
                        children: [
                          const Text('Table Closed'),
                          CustomSubButton(
                            text: "Back to Home Page",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomerHome()));
                            },
                          ),
                        ],
                      );
                    }

                    return Expanded(
                      //stream tableOrders document to show all orders at the table
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                                  'tables/${userSnapshot.data!['tableID']}/tableOrders')
                              .orderBy('timePlaced', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                (snapshot.data?.size == 0)) {
                              return const Center(
                                  child: Text('You have no active requests'));
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    return OrdersPlacedTile(
                                      taskName:
                                          '${'${'\nItem: ' + (snapshot.data?.docs[index]['itemName'] ?? '')}  x ${snapshot.data?.docs[index]['quantity'].toString() ?? ''}\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '')}' +
                                              '\nComment: ${snapshot.data?.docs[index]['orderComment']}',
                                      price: snapshot.data?.docs[index]
                                          ['price'],
                                      time: (snapshot.data?.docs[index]
                                              ['timePlaced'] ??
                                          ''),
                                      oStatus: (snapshot.data?.docs[index]
                                              ['status'] ??
                                          ''),

                                      //===================================================
                                      //Customer can edit order if no progress has been made
                                      //===================================================
                                      onPressedEdit: (BuildContext) {
                                        //Check to see if progress has been made of if the order is request waiter/request bill
                                        //checks to see if order is made by user
                                        if (snapshot.data?.docs[index]
                                                    ['status'] ==
                                                'placed' &&
                                            snapshot.data?.docs[index]
                                                    ['itemName'] !=
                                                'Request Bill' &&
                                            snapshot.data?.docs[index]
                                                    ['itemName'] !=
                                                'Request Waiter' &&
                                            snapshot.data?.docs[index]
                                                    ['custID'] ==
                                                FirebaseAuth.instance
                                                    .currentUser?.uid) {
                                          //if order is made by user and it's status is placed and its not a request waiter/bill
                                          //order can be edited.

                                          //get quantitiy of item ordered originally
                                          int currentCount = snapshot
                                              .data?.docs[index]['quantity'];
                                          int? count = 0;

                                          //get collection ref of tableOrders to send to the editOrder method
                                          String collectionRef =
                                              'tables/${userSnapshot.data!['tableID']}/tableOrders';
                                          final orderCommentsController =
                                              TextEditingController();
                                          orderCommentsController.clear();
                                          //=============================
                                          //Pop up for editing order
                                          //=============================
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return SingleChildScrollView(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    AlertDialog(
                                                      insetPadding:
                                                      const EdgeInsets.only(top: 60, left: 20, right: 20),
                                                      content: Builder(
                                                        builder: (context) {
                                                          return SizedBox(
                                                              height: MediaQuery.of(context).size.height*0.5,
                                                              width: MediaQuery.of(context).size.width,
                                                              child: Column(
                                                                  children: [
                                                                    const Text(
                                                                        'EDIT ORDER'),
                                                                    if (snapshot
                                                                            .data
                                                                            ?.docs[index]['imgURL'] !=
                                                                        '')
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.2,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child: Image.network(
                                                                            snapshot.data?.docs[index][
                                                                                'imgURL'],
                                                                            fit:
                                                                                BoxFit.cover),
                                                                      ),
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.height * 0.3,
                                                                          child:
                                                                              Expanded(
                                                                            child:
                                                                                Text(
                                                                              snapshot.data?.docs[index]['itemName'],
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Spacer(),
                                                                        Text(
                                                                            "\$ ${snapshot.data?.docs[index]['price']}"),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                color: Colors
                                                                                    .grey)),
                                                                        child: CustomTextForm(
                                                                            hintText: snapshot.data?.docs[index]['orderComment']
                                                                                as String,
                                                                            controller:
                                                                                orderCommentsController,
                                                                            validator:
                                                                                null,
                                                                            keyboardType: TextInputType
                                                                                .text,
                                                                            maxLines:
                                                                                2,
                                                                            maxLength:
                                                                                100,
                                                                            icon:
                                                                                const Icon(Icons.fastfood)))
                                                                  ]));
                                                        },
                                                      ),
                                                      actions: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                              child: const Text(
                                                                  "Cancel"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            Counter(
                                                              initial: snapshot
                                                                          .data
                                                                          ?.docs[
                                                                      index]
                                                                  ['quantity'],
                                                              min: 1,
                                                              max: 10,
                                                              bound: 1,
                                                              step: 1,
                                                              onValueChanged:
                                                                  (value) {
                                                                count = value
                                                                    as int?;
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                  "Change Order"),
                                                              onPressed: () {
                                                                //=================================
                                                                //NO ERRORS PLACE ADD ITEM TO ORDER
                                                                //=================================
                                                                count == null
                                                                    ? count = 1
                                                                    : count = count
                                                                        ?.toInt();
                                                                var price = double.parse(snapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        [
                                                                        'price']) /
                                                                    currentCount;

                                                                price = price *
                                                                    count!;

                                                                //check to see if comment was changed
                                                                if (orderCommentsController
                                                                        .text
                                                                        .toString() ==
                                                                    '') {
                                                                  updateOrder(
                                                                      snapshot.data
                                                                              ?.docs[index].id
                                                                          as String,
                                                                      count!,
                                                                      price.toStringAsFixed(
                                                                          2),
                                                                      snapshot
                                                                          .data
                                                                          ?.docs[index]['orderComment'],
                                                                      collectionRef);
                                                                }
                                                                //Send new data to database
                                                                else {
                                                                  updateOrder(
                                                                      snapshot.data
                                                                              ?.docs[index].id
                                                                          as String,
                                                                      count!,
                                                                      price.toStringAsFixed(
                                                                          2),
                                                                      orderCommentsController
                                                                          .text
                                                                          .toString(),
                                                                      collectionRef);
                                                                }

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                              });
                                        }

                                        //Alert user item can not be edited because its a different user's order
                                        else if (snapshot.data?.docs[index]
                                                ['custID'] !=
                                            FirebaseAuth
                                                .instance.currentUser?.uid) {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Cannot edit this item'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text(
                                                          'You can not edit another users order.'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        //Alert user item can not be edited bc it's a request for a bill or waiter
                                        else if (snapshot.data?.docs[index]
                                                    ['itemName'] !=
                                                'Request Bill' ||
                                            snapshot.data?.docs[index]
                                                    ['itemName'] !=
                                                'Request Waiter') {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Cannot edit this item'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text('Sorry :('),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        //ALERT USER THAT ORDER IS IN PROGRESS

                                        else if (snapshot.data?.docs[index]
                                                ['status'] ==
                                            'delivered') {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Cannot edit order'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text(
                                                          'Order is delivered!'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Cannot edit order'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text(
                                                          'Order is in progress'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      //======================================================
                                      //Customer can delete order if no progress has been made
                                      //======================================================
                                      onPressedDelete: (BuildContext) {
                                        //check to see if progress has been made, and if the order is made by the current user
                                        if (snapshot.data?.docs[index]
                                                    ['status'] ==
                                                'placed' &&
                                            snapshot.data?.docs[index]
                                                    ['custID'] ==
                                                FirebaseAuth.instance
                                                    .currentUser?.uid) {
                                          //if order status == 'placed' and order is made by the current user then it can be deleted
                                          String collectionRef =
                                              'tables/${userSnapshot.data!['tableID']}/tableOrders';
                                          deleteOrder(
                                              snapshot.data?.docs[index].id
                                                  as String,
                                              collectionRef,
                                              snapshot.data?.docs[index]
                                                  ['itemName'],
                                              snapshot.data?.docs[index]
                                                  ['tableID']);
                                        }

                                        //Alert user item can not be edited because its a different user's order
                                        else if (snapshot.data?.docs[index]
                                                ['custID'] !=
                                            FirebaseAuth
                                                .instance.currentUser?.uid) {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Cannot delete this item'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text(
                                                          'You can not delete another users order.'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        //order has been delivered
                                        else if (snapshot.data?.docs[index]
                                                ['status'] ==
                                            'delivered') {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Cannot delete order'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text(
                                                          'Order is delivered!'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        //ALERT USER THAT ORDER IS IN PROGRESS
                                        else {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Cannot edit order'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text(
                                                          'Order is delivered'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },

                                      //=============================
                                      //Tapping order shows item info
                                      //=============================
                                      onTap: () {
                                        //check to see if order is request bill/waiter
                                        if (snapshot.data?.docs[index]
                                                    ['itemName'] !=
                                                'Request Bill' &&
                                            snapshot.data?.docs[index]
                                                    ['itemName'] !=
                                                'Request Waiter') {
                                          //order is not request bill/waiter
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'restaurants/${userSnapshot.data!['restID']}/menu')
                                                      .doc(snapshot
                                                              .data?.docs[index]
                                                          ['itemID'])
                                                      .snapshots(),
                                                  builder:
                                                      (build, itemSnapshot) {
                                                    if (itemSnapshot.hasData) {
                                                      var price = 'Free';
                                                      if (itemSnapshot
                                                              .data!['price'] !=
                                                          '0.00') {
                                                        price = '\$' +
                                                            itemSnapshot
                                                                .data!['price'];
                                                      }
                                                      return AlertDialog(
                                                        title: Text(itemSnapshot
                                                            .data!['itemName']
                                                            .toString()),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              Text(itemSnapshot
                                                                      .data![
                                                                  'description']),
                                                              Text(price),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'OK'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return const Text(
                                                          'No data to show');
                                                    }
                                                  });
                                            },
                                          );
                                        } else {}
                                      },
                                    );
                                  });
                            }
                          }),
                    );
                  } else {
                    return const Text("no data found");
                  }
                })
          ],
        ));
  }

  //method will delete order from tableOrders and orders collection
  Future<void> deleteOrder(String orderID, String colectionRef, String itemName,
      String tableID) async {
    //updated table's document to show that the waiter has not been requested
    if (itemName == "Request Bill") {
      await FirebaseFirestore.instance
          .collection('tables')
          .doc(tableID)
          .update({
        'billRequested': false,
      });
    }

    //updated table's document to show that the waiter has not been requested
    if (itemName == 'Request Waiter') {
      await FirebaseFirestore.instance
          .collection('tables')
          .doc(tableID)
          .update({
        'waiterRequested': false,
      });
    }

    print(orderID);
    //deletes document from orders collection
    await FirebaseFirestore.instance.collection('orders').doc(orderID).delete();

    //deletes document from tableOrders collection
    await FirebaseFirestore.instance
        .collection(colectionRef)
        .doc(orderID)
        .delete();
  }

  //method will update order in tableOrders and orders collection
  void updateOrder(String orderID, int count, String price, String comment,
      String collectionRef) {
    //update orders document
    FirebaseFirestore.instance.collection('orders').doc(orderID).update({
      'quantity': count,
      'orderComment': comment,
      'price': price,
    });

    //update tableOrders document
    FirebaseFirestore.instance.collection(collectionRef).doc(orderID).update({
      'quantity': count,
      'orderComment': comment,
      'price': price,
    });
  }
}
