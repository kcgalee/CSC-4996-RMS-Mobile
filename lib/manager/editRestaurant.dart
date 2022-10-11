import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/dialog_box.dart';
import 'package:restaurant_management_system/Waiter/viewTable.dart';

class EditRestaurant extends StatefulWidget {
  final String restID;

  const EditRestaurant({Key? key, required this.restID}) : super(key: key);



  @override
  State<EditRestaurant> createState() => _EditRestaurant();
}

class _EditRestaurant extends State<EditRestaurant> {
  var restInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text('Edit Restaurant'),
          elevation: 0,
        ),
        body: FutureBuilder(
            future: getRestaurant(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(),);
              } else {
                return Text(
                    snapshot.data['restaurantName'] + '\n' + snapshot.data['address']
                    + '\n' + snapshot.data['city'] + '\n' + snapshot.data['state']
                    + '\n' + snapshot.data['zipcode'].toString() + '\n'
                    + snapshot.data['phone'] + '\n' + snapshot.data['email'] + '\n'
                    + snapshot.data['openTime'] + ' to ' + snapshot.data['closeTime']
                );
              }
            })
    );
  }

  Future getRestaurant() async {
   return await FirebaseFirestore.instance.collection('restaurants').doc(widget.restID).get();
  }

}
