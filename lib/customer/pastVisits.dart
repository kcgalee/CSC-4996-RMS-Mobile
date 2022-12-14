import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/pastOrders.dart';
import '../widgets/pastVisitsTile.dart';
import 'Utility/navigation.dart';
import 'customerHome.dart';

/*
This page will display restaurants visited by the current user. Each tile
will be tappable and will send the user to the pastOrders page where
they can see the orders their table placed from that particular visit.
The visits are selected from the pastVisits collection in the current users
collection from the database.
 */


class PastVisits extends StatefulWidget {
  const PastVisits({Key? key}) : super(key: key);

  @override
  State<PastVisits> createState() => _PastVisitsState();
}

class _PastVisitsState extends State<PastVisits> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const CustomerHome()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                //Stream all past visits from the pastVisits collection in the user's user collection
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users/${FirebaseAuth.instance.currentUser?.uid}/pastVisits')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                        //no past visits
                        return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20,),
                              child:
                              Text('Oh no! Looks like you have yet to visit a restaurant! Dine out and fill up your stomach and history list!')
                            )
                        );
                      } else {
                        //past visits exist
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              return PastVisitsTile(
                                  time: snapshot.data?.docs[index]['date'],
                                  waiterName: snapshot.data?.docs[index]['waiterName'],
                                  restName: snapshot.data?.docs[index]['restName'],

                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PastOrders(visitID: snapshot.data?.docs[index].id as String)),
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
