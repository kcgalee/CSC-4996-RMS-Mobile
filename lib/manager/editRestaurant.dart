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
              return Text(restInfo['restaurantName'] + '\n' + restInfo['address']
                  + '\n' + restInfo['city'] + '\n' + restInfo['state']
                  + '\n' + restInfo['zipcode'].toString() + '\n'
                  + restInfo['phone'] + '\n' + restInfo['email'] + '\n'
                  + restInfo['openTime'] + ' to ' + restInfo['closeTime']
              );
            })
    );
  }

  Future getRestaurant() async {
   await FirebaseFirestore.instance.collection('restaurants').doc(widget.restID).get().then(
           (element) {
             restInfo = element.data() as Map<String, dynamic>;
           });
  }

}
