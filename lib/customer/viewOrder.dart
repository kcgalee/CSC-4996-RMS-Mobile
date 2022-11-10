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
                     return StreamBuilder(
                         stream: FirebaseFirestore.instance
                             .collection('tables')
                             .doc(userSnapshot.data!['tableID'])
                             .snapshots(),
                         builder: (context, tableSnapshot) {
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
                                                   "\n\$${widget.createOrderInfo
                                                   .price[index]}",
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
                                                                           MediaQuery
                                                                               .of(
                                                                               context)
                                                                               .size
                                                                               .height;
                                                                       var width =
                                                                           MediaQuery
                                                                               .of(
                                                                               context)
                                                                               .size
                                                                               .width;

                                                                       return SizedBox(
                                                                           height: 500,
                                                                           width: 500,
                                                                           child: Column(
                                                                               children: [
                                                                                 const Text('EDIT ORDER'),
                                                                                 if (widget.createOrderInfo.imgURL[index] == '')
                                                                                   SizedBox(
                                                                                     height:
                                                                                     250,
                                                                                     width:
                                                                                     350,
                                                                                     child:
                                                                                     Image
                                                                                         .network(
                                                                                         widget.createOrderInfo.imgURL[index]),
                                                                                   ),
                                                                                 const SizedBox(
                                                                                     height: 20),
                                                                                 Text(
                                                                                   widget.createOrderInfo.itemName[index],
                                                                                   style:
                                                                                   const TextStyle(
                                                                                     fontWeight:
                                                                                     FontWeight
                                                                                         .bold,
                                                                                     fontSize:
                                                                                     20,
                                                                                   ),
                                                                                 ),
                                                                                 Text(
                                                                                     "\$ ${widget.createOrderInfo.price[index]}"),
                                                                                 const SizedBox(
                                                                                     height: 20),
                                                                                 CustomTextForm(
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

                                                                             //Send new data to database
                                                                             widget.createOrderInfo.updateOrder(index, count!, price.toStringAsFixed(2), orderCommentsController.text.toString());

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
                               //PLACE ORDER BUTTON
                               //==================

                               CustomMainButton(text: "PLACE ORDER",
                                   onPressed: () {

                                    //======================================
                                     //Error Handling for NO assigned waiter
                                     //=====================================
                                     if (tableSnapshot.data!['waiterID'] == '') {
                                       showDialog<void>(
                                         context: context,
                                         barrierDismissible: false, // user must tap button!
                                         builder: (BuildContext context) {
                                           return AlertDialog(
                                             title: const Text('Alert!'),
                                             content: SingleChildScrollView(
                                               child: ListBody(
                                                 children: const <Widget>[
                                                   Text('Waiter Must be assigned to your table before you can submit an order.'),
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

                                   }
                               ),

                             ],
                           );
                         } // end of tableSnapshot builder

                     );
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