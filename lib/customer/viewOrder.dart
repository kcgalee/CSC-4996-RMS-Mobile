import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
import '../widgets/customMainButton.dart';
import '../widgets/customSubButton.dart';
import '../widgets/customTextForm.dart';
import '../widgets/orderTile.dart';
import 'Models/createOrderInfo.dart';
import 'customerHome.dart';

/*
The view order page shows all of the items currently on a customers order before
it is placed.  The page allows the customer to edit/delete an item from their order.
All the items in the order are saved in the createOrderInfo object created when
the user selects the "Menu" button on the customer home page. When the "Place Order"
is selected at the bottom of the page, the each item will be added to the database
from the createOrderInfo class
 */

class ViewOrder extends StatefulWidget {
  CreateOrderInfo createOrderInfo;

  ViewOrder({Key? key, required this.createOrderInfo}) : super(key: key);

  @override
  State<ViewOrder> createState() => _ViewOrder();
}



class _ViewOrder extends State<ViewOrder> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body:


        //=====================================
        //Customer User Document Stream Builder
        //=====================================
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, userSnapshot) {

              //Check for data in document
              if(userSnapshot.hasData) {


                //===============================
                //ERROR HANDLING FOR CLOSED TABLE
                //===============================

                if(userSnapshot.data!['tableID'] == ''){
                  return Column(
                    children:  [
                      const Text('Table Closed'),

                      CustomSubButton(text: "Back to Home Page",
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerHome()));
                        },
                      ),

                    ],

                  );
                }


                //============================
                //Table document Snapshot stream builder
                //=============================
                if (widget.createOrderInfo.itemCount >= 1) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('tables')
                          .doc(userSnapshot.data!['tableID'])
                          .snapshots(),
                      builder: (context, tableSnapshot) {

                        num totalPrice = 0;
                        for (int i = 0; i < widget.createOrderInfo.itemCount; i++) {
                          totalPrice = totalPrice + double
                              .parse(
                              widget.createOrderInfo.price[i]);
                        }
                        return Column(
                          children: [

                            Expanded(
                                child: SizedBox(
                                    height: 200.0,
                                    child: ListView.builder(
                                        itemCount: widget.createOrderInfo
                                            .itemID.length,
                                        itemBuilder: (context, index) {
                                          return OrderTile(
                                            imgURL: widget.createOrderInfo.imgURL[index],
                                            taskName: "${widget
                                                .createOrderInfo
                                                .itemName[index]}"
                                                " x ${widget.createOrderInfo
                                                .count[index]}"
                                                '\nComment: ${widget.createOrderInfo
                                                .orderComments[index]}',
                                            price: widget.createOrderInfo
                                                .price[index],
                                            createOrderInfo: widget
                                                .createOrderInfo,

                                            //================================
                                            //User selects edit
                                            //==================================
                                            onPressedEdit: (BuildContext ) {

                                              //Check to see if progress has been made
                                              int currentCount = widget.createOrderInfo.count[index];
                                              int? count = 0;
                                              final orderCommentsController = TextEditingController();
                                              orderCommentsController.clear();
                                              //=============================
                                              //Pop up for editing order
                                              //=============================
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context)
                                                  {
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
                                                                            const Padding(
                                                                              padding: EdgeInsets.only(bottom: 10),
                                                                              child: Text('EDIT ORDER',
                                                                                style:
                                                                                TextStyle(
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold,
                                                                                  fontSize:
                                                                                  20,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            if (widget.createOrderInfo.imgURL[index] != '')
                                                                              SizedBox(
                                                                                height:
                                                                                MediaQuery.of(context).size.height *0.2 ,
                                                                                width:
                                                                                MediaQuery.of(context).size.width,
                                                                                child:
                                                                                Image.network(
                                                                                    widget.createOrderInfo.imgURL[index], fit: BoxFit.cover),
                                                                              ),
                                                                            const SizedBox(
                                                                                height: 20),
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: MediaQuery.of(context).size.height * 0.3,
                                                                                  child: Expanded(
                                                                                      child: Text(
                                                                                        widget.createOrderInfo.itemName[index],
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                const Spacer(),
                                                                                Text(
                                                                                    "\$ ${widget.createOrderInfo.price[index]}"),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                                height: 20),
                                                                            Container(
                                                                                decoration: BoxDecoration(
                                                                                    border: Border.all(color: Colors.grey)
                                                                                ),
                                                                              child: CustomTextForm(
                                                                                  hintText:
                                                                                  widget.createOrderInfo.orderComments[index],
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
                                                                                  const Icon(Icons.fastfood)
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
                                                                      initial: widget.createOrderInfo.count[index],
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
                                                                      onPressed:
                                                                          () {
                                                                        //=================================
                                                                        //NO ERRORS PLACE ADD ITEM TO ORDER
                                                                        //=================================
                                                                        count ==
                                                                            null
                                                                            ? count =
                                                                        1
                                                                            : count =
                                                                            count
                                                                                ?.toInt();
                                                                        var price = double
                                                                            .parse(
                                                                            widget.createOrderInfo.price[index])/currentCount;

                                                                        price =
                                                                            price *
                                                                                count!;


                                                                        if(orderCommentsController.text.toString() == ''){
                                                                          widget.createOrderInfo.updateOrder(index, count!, price.toStringAsFixed(2), widget.createOrderInfo.orderComments[index]);
                                                                        }
                                                                        //Send new data to database
                                                                        else {
                                                                          widget.createOrderInfo.updateOrder(index, count!, price.toStringAsFixed(2), orderCommentsController.text.toString());
                                                                        }

                                                                        Navigator.of(
                                                                            context)
                                                                            .pop();
                                                                        Navigator.pop(context);
                                                                        Navigator.push(
                                                                            context, MaterialPageRoute(
                                                                            builder: (
                                                                                context) => ViewOrder(createOrderInfo: widget.createOrderInfo)));


                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ));
                                                  });



                                            },

                                            onPressedDelete: (BuildContext ) {
                                              //Delete order from createOrderInfo object
                                              widget.createOrderInfo.deleteItem(index);

                                              //Reload page with new order list
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (
                                                      context) => ViewOrder(createOrderInfo: widget.createOrderInfo)));
                                            },
                                          );
                                        }
                                    )
                                )
                            ),





                          //==================
                          //TOTAL PRICE AND PLACE ORDER BUTTON
                          //==================

                          Container(
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Total : \$ ${totalPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                        ],
                                      ),
                                    ),
                                    CustomMainButton(
                                        text: "PLACE ORDER",
                                        onPressed: () {
                                          //======================================
                                          //Error Handling for NO assigned waiter
                                          //=====================================
                                          if (tableSnapshot.data!['waiterID'] ==
                                              '') {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Alert!'),
                                                  content:
                                                  SingleChildScrollView(
                                                    child: ListBody(
                                                      children: const <Widget>[
                                                        Text(
                                                            'Waiter Must be assigned to your table before you can submit an order.'),
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

                                          //===================================
                                          //Error Handling for NO items in cart
                                          //===================================
                                          else if (widget.createOrderInfo.itemID.isEmpty) {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Alert!'),
                                                  content: SingleChildScrollView(
                                                    child: ListBody(
                                                      children: const <Widget>[
                                                        Text('No items in order.'),
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
                                          //ERROR HANDLING FOR BILL REQUESTED
                                          //=================================
                                          else if (tableSnapshot.data!['billRequested']) {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Alert!'),
                                                  content: SingleChildScrollView(
                                                    child: ListBody(
                                                      children: const <Widget>[
                                                        Text('Bill requested, cannot place anymore orders.'),
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


                                          //=======================
                                          //NO ERRORS PLACE ORDER
                                          //=======================
                                          else {
                                            widget.createOrderInfo.placeOrder(
                                                tableSnapshot.data!.id,
                                                tableSnapshot.data!['tableNum'].toString(),
                                                tableSnapshot.data!['waiterID'],
                                                tableSnapshot.data!['restID']);
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                                builder: (
                                                    context) => const PlacedOrders()));
                                          } //end of else
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } // end of order

                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: SizedBox(
                              width:
                              MediaQuery.of(context).size.width * 0.7,
                              child:
                              Image.asset('assets/images/loading.png',)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text("No Orders Added Yet!")
                        )
                      ],
                    )
                  );
                }
                //================================
                //End of table doc stream builder
                //===============================


              }

              //Display if userSnapshot has no data
              else {
                return
                  const Text('No Data to display');
              }

            } //End of customer User Doc Builder

        ),
        //=====================================
        // End of Customer User Document Stream Builder
        //=====================================


      );
  }



}