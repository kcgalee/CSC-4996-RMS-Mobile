import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/pastOrders.dart';
import '../widgets/pastVisitsTile.dart';
import 'Utility/navigation.dart';

class PastVisits extends StatefulWidget {
  const PastVisits({Key? key}) : super(key: key);

  @override
  State<PastVisits> createState() => _PastVisitsState();
}

class _PastVisitsState extends State<PastVisits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Past Visits',
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
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
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('custID',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .where('itemName', whereNotIn: [
                    'Request Bill',
                    'Request Waiter'
                  ]).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                      return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20,),
                            child:
                            Text('Oh no! Looks like you have yet to visit a restaurant! Dine out and fill up your stomach and history list!')
                          )
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return PastVisitsTile(
                                taskName: 'Item: ' +
                                    (snapshot.data?.docs[index]['itemName'] ??
                                        ''),
                                time: snapshot.data?.docs[index]['timePlaced'],
                                oStatus: (snapshot.data?.docs[index]
                                        ['status'] ??
                                    ''),
                                restID: snapshot.data?.docs[index]['restID'],
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PastOrders()),
                                  );
                                });
                          });
                    }
                  }),
            ),
          ],
        ));
  }
}
