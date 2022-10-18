import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/managerTile.dart';
import 'package:restaurant_management_system/manager/editRestaurant.dart';

import 'addRestaurant.dart';

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
        appBar: AppBar(
          title: Text('Manage Restaurants'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  const AddRestaurant()
                )
            );
          },
          label: const Text('Add'),
          icon: const Icon(Icons.add_business_outlined),
          backgroundColor: Colors.black,
        ),


        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('restaurants').where('managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                return Center(child: Text("You are not managing any restaurants."),);
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return ManagerTile(
                          taskName: snapshot.data?.docs[index]['restName'] ?? '',
                          subTitle: snapshot.data?.docs[index]['address'] ?? '',
                          onPressedEdit:  (){},
                          onPressedDelete: (){}
                      );

                    }
                );
              }
            })
    );
  }

/*deleteRest() async {
    await FirebaseAuth.instance.c
  }*/

}
