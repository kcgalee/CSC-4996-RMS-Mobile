import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/pastOrdersTile.dart';
import 'Utility/navigation.dart';

/*
This page will display all the orders placed by a table from a past visit.
The items are selected from the pastVisits collection in the current users
collection from the database.
 */

class PastOrders extends StatefulWidget {
String visitID;
   PastOrders({Key? key, required this.visitID}) : super(key: key);

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
                    stream: FirebaseFirestore.instance
                        .collection('users/${FirebaseAuth.instance.currentUser?.uid}'
                        '/pastVisits/${widget.visitID}/tableOrders')
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
                                (snapshot.data?.docs[index]['itemName'] ?? ''),
                                comment: snapshot.data?.docs[index]['orderComment'],
                                price: (snapshot.data?.docs[index]['price'] ?? ''),
                                quantity: snapshot.data?.docs[index]['quantity'],
                                custName: snapshot.data?.docs[index]['custName'],
                                imgURL: snapshot.data?.docs[index]['imgURL'],
                              );
                            }
                        );
                      }
                    }),
              ),
              const SizedBox(height: 20)
            ],
          )
      );
  }
}
