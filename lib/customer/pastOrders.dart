import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/ordersPlacedTile.dart';
import '../widgets/pastOrdersTile.dart';
import 'Utility/navigation.dart';


class PastOrders extends StatefulWidget {

   PastOrders({Key? key}) : super(key: key);

  @override
  State<PastOrders> createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Past Orders',),
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
                  stream: FirebaseFirestore.instance.collection('orders')
                      .where('custID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .where('itemName', whereNotIn: ['Request Bill', 'Request Waiter'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                      return Center(child:Text('You have no orders'));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return PastOrdersTile(
                              taskName:
                              'Item: ' + (snapshot.data?.docs[index]['itemName'] ?? ''),
                              time: snapshot.data?.docs[index]['timePlaced'],
                              oStatus: (snapshot.data?.docs[index]['status'] ?? ''),
                              //restName: snapshot.data?.docs[index]['restName'],
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
