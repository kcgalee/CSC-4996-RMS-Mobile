import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/waiter/viewTable.dart';

import '../login/mainscreen.dart';
/*
This page is for viewing all tables at the restaurant the waiter is working at,
on this page the waiter will see if there are any customers and if any waiters are attending to them,
 */

class AllTables extends StatefulWidget {
  const AllTables({Key? key}) : super(key: key);

  @override
  State<AllTables> createState() => _AllTables();
}

class _AllTables extends State<AllTables> {
  var waiterRID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffEBEBEB),
        appBar: AppBar(
          title: Text("All Tables"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
            builder: (context, snapshot){
              if (!snapshot.hasData || (snapshot.data?.exists == false)) {
                return Center(child:CircularProgressIndicator());
              } else {
                if (snapshot.data?['isActive'] == false){
                  return AlertDialog(
                    title: const Text('Account is Deactivated'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Your Waiter account has been deactivated by your manager.'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()
                              )
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return home();
                }
              }
            }
        ));
  }

  Widget home() {
    return FutureBuilder(
            future: getRID(),
            builder: (context, snapshot) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables').where('restID', isEqualTo: waiterRID).orderBy('currentCapacity').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.data?.docs.length == 0){
                      return const Center(child: Text('There are currently no tables at this restaurant'));
                    }
                    else {
                      return GridView.builder(
                          itemCount: snapshot.data?.docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          itemBuilder:(context,index){
                            var boxColor, text, status;
                            if (snapshot.data?.docs[index]['currentCapacity'] > 0){
                              //if table unavailable then box is red
                              boxColor = Colors.redAccent;
                            } else {
                              //green if available
                              boxColor = Colors.greenAccent;
                            }
                            if (snapshot.data?.docs[index]['waiterID'] == '' || snapshot.data?.docs[index]['waiterName'] == ''){
                              text = ('Table ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                  + '\n' + (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '')
                                  + '/' + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? '')
                                  + '\nWaiter unassigned');
                              status = false;
                            } else {
                              text = ('Table ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                  + '\n' + (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '')
                                  + '/' + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? '')
                                  + '\nWaiter ' + (snapshot.data?.docs[index]['waiterName']));
                              status = true;
                            }
                            return InkWell(
                              child: Container(
                                height: 100,
                                width: 80,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: boxColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: boxColor,width: 2)
                                ),
                                child: Center(
                                  child: Text(text,
                                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewTable(tableID: snapshot.data?.docs[index].reference.id ?? '',
                                            tableNum: snapshot.data?.docs[index]['tableNum'].toString() ?? '',
                                            assigned: status,  currentCapacity: snapshot.data?.docs[index]['currentCapacity'])
                                    )
                                );
                              },
                            );
                          }
                      );
                    }
                  });
            });
  }

  Future getRID() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
          waiterRID = element['restID'];
        }
    );
  }
}
