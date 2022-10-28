import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';

import '../widgets/request_tile.dart';
import 'Utility/navigation.dart';

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
          title: const Text('Placed Orders'),
          backgroundColor: const Color(0xff76bcff),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if(userSnapshot.hasData) {
                    return Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(
                                'tables/${userSnapshot.data!['tableID']}/tableOrders')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                            return Center(
                                child: Text('You have no active requests'));
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index){
                                  return OrdersPlacedTile(
                                      taskName: '\nItem: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                          + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                          + '\nPlaced by ' + (snapshot.data?.docs[index]['custName'] ?? '')
                                          + '\nPrice: \$' + (snapshot.data?.docs[index]['price'] ?? ''),
                                      time:(snapshot.data?.docs[index]['timePlaced'] ?? '') ,
                                      oStatus: (snapshot.data?.docs[index]['status'] ?? ''),
                                  );


                                });
                          }
                        }),
                  );
                  }
                  else{
                    return const Text("no data found");
                  }
                })
          ],
        ));
  }
}
