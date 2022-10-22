import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';

import '../widgets/request_tile.dart';


class PlacedOrders extends StatefulWidget {
  final String tableID;
  const PlacedOrders({Key? key, required this.tableID}) : super(key: key);
  @override
  State<PlacedOrders> createState() => _PlacedOrders();
}

class _PlacedOrders extends State<PlacedOrders> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Placed Orders',),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Text("Orders Placed",
              style: TextStyle(fontSize: 30,),),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables/'+widget.tableID+'/tableOrders').orderBy('timePlaced', descending: true).snapshots(),
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
