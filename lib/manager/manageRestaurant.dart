import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/managerTile.dart';
import 'package:restaurant_management_system/manager/editRestaurant.dart';
import 'package:restaurant_management_system/widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'addRestaurant.dart';
import 'managerHome.dart';

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
        drawer: const ManagerNavigationDrawer(),
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


        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: CustomBackButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => ManagerHome()
                    )
                );
              }),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('restaurants').where('managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).where('isActive', isEqualTo: true).orderBy('restName').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text("You are not managing any restaurants."),);
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ManagerTile(
                                taskName: snapshot.data?.docs[index]['restName'] ?? '',
                                subTitle: (snapshot.data?.docs[index]['address'] ?? '') + '\n' + (snapshot.data?.docs[index]['city'] ?? '') + ', ' + snapshot.data?.docs[index]['state'] ?? '',
                                onPressedEdit:(p0) =>
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => EditRestaurant(restID: snapshot.data?.docs[index].reference.id ?? '', rName: snapshot.data?.docs[index]['restName'] ?? '',
                                          rAddress: snapshot.data?.docs[index]['address'] ?? '', rCity: snapshot.data?.docs[index]['city'] ?? '', rState: snapshot.data?.docs[index]['state'] ?? '',
                                          rZip: snapshot.data?.docs[index]['zipcode'] ?? '', rEmail: snapshot.data?.docs[index]['email'] ?? '', rPhone: snapshot.data?.docs[index]['phone'] ?? '',
                                          rOpenWKday: snapshot.data?.docs[index]['openTimeWKday'] ?? '',
                                          rCloseWKday: snapshot.data?.docs[index]['closeTimeWKday'] ?? '',
                                          rOpenWKend: snapshot.data?.docs[index]['openTimeWKend'] ?? '',
                                          rCloseWKend: snapshot.data?.docs[index]['closeTimeWKend'] ?? '')
                                      )
                                  ),
                                onPressedDelete: (p0) => {
                                deleteRestaurant(snapshot.data?.docs[index].reference.id)
                            },
                              /*() async {
                                  deleteRestaurant(snapshot.data?.docs[index].reference.id);
                                }*/
                            );

                          }
                      );
                    }
                  }),
            ),
          ],
        )
    );
  }

   deleteRestaurant(var id) async {
     var restaurant = await FirebaseFirestore.instance.collection('restaurants').doc(id).get();
     await restaurant.reference.update({
       'isActive': false,
       'deletionDate': Timestamp.now(),
     });
  }
}
