import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';

import '../widgets/request_tile.dart';
import 'Utility/navigation.dart';


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
        drawer: const NavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Placed Orders',),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
              ),
            ),
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
                                  '\nItem: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                  + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                  + '\nPlaced by ' + (snapshot.data?.docs[index]['custName'] ?? '')
                                  + '\nPrice: \$' + (snapshot.data?.docs[index]['price'] ?? '')
                                  ,
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
