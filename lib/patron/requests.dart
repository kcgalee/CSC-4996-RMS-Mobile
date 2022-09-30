import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/login/mainscreen.dart';
import 'package:restaurant_management_system/patron/placeOrder.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Stream getRequests = FirebaseFirestore.instance.collection('orders').where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots();
  var waiterID;
  List<String> tableDocList = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Requests"),
      ),
      body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await getRID();
                  addOrder();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> placeOrder()));
                },
                child: const Text('Request Spoon',
                  style: TextStyle(

                    color: Colors.white,

                  ),
                )
            ),
              ElevatedButton(
                  child: Text("Sign out"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => MainScreen()));
                  }),
            ],
          )

      ),
    );
  }


  Future <void> addOrder() async {
    FirebaseFirestore.instance
        .collection('orders')
        .add({
      'custID' : 'ocLOG8A5DaVdVCArxFLXnZj29H2',
      'itemID' : 'Spoon',
      'price'  : '3.99',
      'waiterID' : waiterID,
      'tableNum' : '1',
      'status' : 'placed',
      'tableID' : '67VixP11beDjcl39waX9'
    });
    print(waiterID);
  }


  Future getRID() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
          print(element.reference);
          //item.fromFirestore();
          //set2.add(element);
          waiterID = element['waiterID'].toString().trim();
          print(waiterID);
        }
    );
  }
}