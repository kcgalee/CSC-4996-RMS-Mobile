import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
import '../widgets/customSubButton.dart';
import '../widgets/orderTile.dart';
import 'Models/createOrderInfo.dart';



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
         title: const Text('Home'),
         backgroundColor: const Color(0xff76bcff),
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
                   if(userSnapshot.hasData) {
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
                                               taskName: "${widget
                                                   .createOrderInfo
                                                   .itemName[index]}"
                                                   "\n${widget.createOrderInfo
                                                   .count[index]}"
                                                   "\n${widget.createOrderInfo
                                                   .price[index]}",
                                               createOrderInfo: widget
                                                   .createOrderInfo,
                                             );
                                           }
                                       )
                                   )
                               ),

                               CustomSubButton(text: "PLACE ORDER",
                                   onPressed: () {
                                     if (tableSnapshot.data!['waiterID'] ==
                                         '') {
                                       print("no waiter");
                                     }
                                     else
                                     if (widget.createOrderInfo.itemID.isEmpty) {
                                       //TODO error for no items in order
                                        print('no items');
                                     }
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
                   }
                   else {
                     return
                       const Text('No Data to display');
                   }

                           //================================
                           //End of table doc stream builder
                           //===============================





                   //================================
                 } //End of customer User Doc Builder
               //===============================

             ),
             //=====================================
             // End of Customer User Document Stream Builder
             //=====================================


       );
 }


}