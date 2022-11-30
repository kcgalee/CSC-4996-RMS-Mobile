import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/waiter/viewTable.dart';

import '../login/mainscreen.dart';


class WaiterTables extends StatefulWidget {
  const WaiterTables({Key? key}) : super(key: key);

  @override
  State<WaiterTables> createState() => _WaiterTablesState();
}

class _WaiterTablesState extends State<WaiterTables> {
  var waiterRID;
  List<String> tableDocList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffEBEBEB),
        appBar: AppBar(
          title: Text('Assigned Tables'),
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
                  stream: FirebaseFirestore.instance.collection('tables').where('restID', isEqualTo: waiterRID).where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text("You are not servicing any tables."),);
                    } else {
                      return GridView.builder(
                          itemCount: snapshot.data?.docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          itemBuilder:(context,index){
                            var text = (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '') + '/' + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? '');
                            return InkWell(
                              child: Container(
                                height: 100,
                                width: 80,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                      'Table ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '') + '\n' + text,
                                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewTable(tableID: snapshot.data?.docs[index].reference.id ?? '',
                                            tableNum: snapshot.data?.docs[index]['tableNum'].toString() ?? '',
                                            assigned: true, currentCapacity: snapshot.data?.docs[index]['currentCapacity'])
                                    )
                                );
                              },
                            );
                          }
                      );
                    }
                  });
            }
    );
  }

  Future getRID() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
          waiterRID = element['restID'].toString();
        }
    );
  }
}
