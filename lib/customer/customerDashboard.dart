import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/requests.dart';
import 'package:restaurant_management_system/customer/navigation.dart';


class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key? key}) : super(key: key);

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  Stream getRequests = FirebaseFirestore.instance.collection('orders').where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots();
var waiterID;
  List<String> tableDocList = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text("Customer Dashboard"),
      ),
      body: Center(
        child: Column(
            children: [
              ElevatedButton(
                child: Text("Requests"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => Requests()));
              }),
            ],)

      ),
    );
  }
  

  Future <void> addOrder() async {
 FirebaseFirestore.instance
     .collection('orders')
     .add({
        'custID' : 'ocLOG8A5DaVdVCArxFLXnZj29H2',
        'itemName' : 'Spoon',
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
