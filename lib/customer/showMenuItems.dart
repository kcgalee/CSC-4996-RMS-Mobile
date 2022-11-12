import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/viewOrder.dart';
import 'package:counter/counter.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import '../widgets/customSubButton.dart';
import 'Models/createOrderInfo.dart';
import 'customerHome.dart';

class ShowMenuItems extends StatefulWidget {
  final String text, restName;
  final int priority;
  final CreateOrderInfo createOrderInfo;

  const ShowMenuItems(
      {Key? key,
      required this.text,
      required this.restName,
      required this.priority,
      required this.createOrderInfo})
      : super(key: key);

  @override
  State<ShowMenuItems> createState() => _ShowMenuItems();
}

class _ShowMenuItems extends State<ShowMenuItems> {
  final orderCommentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text.toUpperCase()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrder(
                            createOrderInfo: widget.createOrderInfo)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),

      //=====================================
      //Customer User Document Stream Builder
      //=====================================
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            //Check for data in document
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
                                builder: (context) => const CustomerHome()));
                      },
                    ),
                  ],
                );
              }

              //============================
              //Table document Snapshot stream builder
              //=============================
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('tables')
                      .doc(userSnapshot.data!['tableID'])
                      .snapshots(),
                  builder: (context, tableSnapshot) {
                    if (tableSnapshot.hasData) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                                  'restaurants/${tableSnapshot.data!['restID']}/menu')
                              .where('category', isEqualTo: widget.text)
                              .snapshots(),
                          builder: (context, menuSnapshot) {
                            if (!menuSnapshot.hasData ||
                                menuSnapshot.data?.docs.length == 0) {
                              return const Center(
                                child: Text("No items to display."),
                              );
                            } else {
                              return ListView.builder(
                                  itemCount: menuSnapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, right: 20),
                                        child: Container(
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.black38,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 2.0,
                                                      offset: Offset(2.0, 2.0))
                                                ]),
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Text(menuSnapshot
                                                              .data?.docs[index]
                                                          ['itemName'] ??
                                                      '',
                                                  ),

                                                  Spacer(),
                                                  
                                                  Text(menuSnapshot
                                                              .data?.docs[index]
                                                          ['price'] ??
                                                      '\n'),
                                                ],
                                              ),
                                              onTap: () {
                                                orderCommentsController.clear();
                                                int? count = 0;
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Expanded(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AlertDialog(
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          content: Builder(
                                                            builder: (context) {
                                                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                              var height =
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height;
                                                              var width =
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width;

                                                              return SizedBox(
                                                                  height: 500,
                                                                  width: 500,
                                                                  child: Column(
                                                                      children: [
                                                                        if (menuSnapshot.data?.docs[index]['imgURL'] !=
                                                                            '')
                                                                          SizedBox(
                                                                            height:
                                                                                250,
                                                                            width:
                                                                                350,
                                                                            child:
                                                                            FittedBox(
                                                                              fit: BoxFit.fill,
                                                                              child:
                                                                              Image.network(menuSnapshot.data?.docs[index]['imgURL']),
                                                                            ),
                                                                          ),

                                                                        SizedBox(height: 10),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              menuSnapshot.data?.docs[index]['itemName'],
                                                                              style:
                                                                                  const TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight.bold,
                                                                                fontSize:
                                                                                    20,
                                                                              ),
                                                                              textAlign: TextAlign.left,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              width: 330,
                                                                              child: Text(menuSnapshot.data?.docs[index]['description'] +
                                                                                  "\n\n \$" +
                                                                                  menuSnapshot.data?.docs[index]['price'],
                                                                                  textAlign: TextAlign.left),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        Expanded(
                                                                          child: Align(
                                                                            alignment: FractionalOffset.bottomCenter,
                                                                            child: CustomTextForm(
                                                                                hintText:
                                                                                'Optional Order Comments',
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
                                                                                const Icon(Icons.fastfood))
                                                                          )
                                                                        )
                                                                      ])
                                                              );
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                Counter(
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
                                                                      "Add to Order"),
                                                                  onPressed:
                                                                      () {
                                                                    //=================================
                                                                    //ERROR HANDLING FOR BILL REQUESTED
                                                                    //=================================
                                                                    if (tableSnapshot
                                                                            .data![
                                                                        'billRequested']) {
                                                                      showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        // user must tap button!
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text('Alert!'),
                                                                            content:
                                                                                SingleChildScrollView(
                                                                              child: ListBody(
                                                                                children: const <Widget>[
                                                                                  Text('Bill requested, Can not place anymore orders.'),
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
                                                                          );
                                                                        },
                                                                      );
                                                                    }

                                                                    //=================================
                                                                    //NO ERRORS PLACE ADD ITEM TO ORDER
                                                                    //=================================
                                                                    else {
                                                                      count ==
                                                                              null
                                                                          ? count =
                                                                              1
                                                                          : count =
                                                                              count?.toInt();
                                                                      var price = double.parse(menuSnapshot
                                                                          .data
                                                                          ?.docs[index]['price']);
                                                                      price = price *
                                                                          count!;

                                                                      widget.createOrderInfo.orderSetter(
                                                                          menuSnapshot.data?.docs[index].id
                                                                              as String,
                                                                          count!,
                                                                          menuSnapshot.data?.docs[index]
                                                                              [
                                                                              'itemName'],
                                                                          price.toStringAsFixed(
                                                                              2),
                                                                          orderCommentsController
                                                                              .text,
                                                                          widget
                                                                              .priority,
                                                                          menuSnapshot
                                                                              .data
                                                                              ?.docs[index]['imgURL'] as String);

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();

                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ViewOrder(createOrderInfo: widget.createOrderInfo)));
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                                  },
                                                );
                                              },
                                            )));
                                  });
                            }
                          });
                    } else {
                      return const Text('No Data to display');
                    }

                    //=====================================
                    //End of REST MENU STREAM BUILDER
                    //=====================================
                  } // end of tableSnapshot builder

                  );
              //================================
              //End of table doc stream builder
              //===============================

            }

            //Display if userSnapshot has no data
            else {
              return const Text('No Data to display');
            }
          } //End of customer User Doc Builder

          ),
      //=====================================
      // End of Customer User Document Stream Builder
      //=====================================
    );
  }
}
