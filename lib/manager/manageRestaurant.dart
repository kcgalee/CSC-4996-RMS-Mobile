import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/dialog_box.dart';
import 'package:restaurant_management_system/Waiter/viewTable.dart';

class ManageRestaurant extends StatefulWidget {
  const ManageRestaurant({Key? key}) : super(key: key);

  @override
  State<ManageRestaurant> createState() => _ManageRestaurant();
}

class _ManageRestaurant extends State<ManageRestaurant> {

  List restaurantList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text('Manage Restaurants'),
          elevation: 0,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('restaurants').where('managerUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                return Center(child: Text("You are not managing any restaurants."),);
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data?.docs[index]['restaurantName'] ?? ''),
                        subtitle: Text(snapshot.data?.docs[index]['address'] ?? ''),
                        onTap: () {
                        },
                      );
                    }
                );
              }
            })
    );
  }

}
