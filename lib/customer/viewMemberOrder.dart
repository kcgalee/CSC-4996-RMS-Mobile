import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';

import '../widgets/request_tile.dart';
import 'Utility/navigation.dart';


class ViewMemberOrder extends StatefulWidget {
  CreateOrderInfo createOrderInfo;
  final String tableID, custID, custName;
  ViewMemberOrder({Key? key, required this.tableID,
    required this.createOrderInfo, required this.custID, required this.custName}) : super(key: key);
  @override
  State<ViewMemberOrder> createState() => _ViewMemberOrder();
}

class _ViewMemberOrder extends State<ViewMemberOrder> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:  Text('Orders by ${widget.custName}'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables/'+widget.tableID+'/tableOrders')
                      .where('custID', isEqualTo: widget.custID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                      return Center(child:Text('You have no orders'));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return OrdersPlacedTile(
                              taskName:
                              '\nOrdered: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                  + '\nQuantity: ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                  + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '')
                                  + '\nPrice: ' + (snapshot.data?.docs[index]['price'] ?? ''),
                              time: snapshot.data?.docs[index]['timePlaced'],
                              oStatus: (snapshot.data?.docs[index]['status'] ?? ''),
                            );
                          }
                      );
                    }
                  }),
            ),
          ],
        )
    );
  }
}
