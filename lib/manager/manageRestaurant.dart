import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/editRestaurant.dart';
import 'package:restaurant_management_system/manager/managerHome.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/manageRestaurantTile.dart';
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
      backgroundColor: const Color(0xffEBEBEB),
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
            Align(
              alignment: Alignment.topLeft,
              child:
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => ManagerHome(),
                      )
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              //retrieves all active restaurants that the manager has, and displays them alphabetically
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('restaurants').where('managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).where('isActive', isEqualTo: true).orderBy('restName').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text("You are not managing any restaurants."),);
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            //creates tile for restaurant
                            return ManageRestaurantTile(
                              restaurantName: snapshot.data?.docs[index]['restName'] ?? '',
                              address: (snapshot.data?.docs[index]['address'] ?? '') + '\n' + (snapshot.data?.docs[index]['city'] ?? '') + ', ' + snapshot.data?.docs[index]['state'] ?? '',
                                onPressedEdit:(p0) =>  {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => EditRestaurant(restID: snapshot.data?.docs[index].reference.id ?? '', rName: snapshot.data?.docs[index]['restName'] ?? '',
                                          rAddress: snapshot.data?.docs[index]['address'] ?? '', rCity: snapshot.data?.docs[index]['city'] ?? '', rState: snapshot.data?.docs[index]['state'] ?? '',
                                          rZip: snapshot.data?.docs[index]['zipcode'] ?? '', rEmail: snapshot.data?.docs[index]['email'] ?? '', rPhone: snapshot.data?.docs[index]['phone'] ?? '',
                                          rOpenWKday: snapshot.data?.docs[index]['openTimeWKday'] ?? '',
                                          rCloseWKday: snapshot.data?.docs[index]['closeTimeWKday'] ?? '',
                                          rOpenWKend: snapshot.data?.docs[index]['openTimeWKend'] ?? '',
                                          rCloseWKend: snapshot.data?.docs[index]['closeTimeWKend'] ?? '',
                                          holiday: snapshot.data?.docs[index]['holidayHours'] ?? '')
                                      )
                                  )
                                },
                                onPressedDelete: () =>  {
                                  deleteRestaurant(snapshot.data?.docs[index].reference.id),
                                  Navigator.pop(context),
                                },
                              onTap: (){
                                //popup to display restaurant information once it is tapped
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight:Radius.circular(24))
                                    ),
                                    backgroundColor: Colors.blueGrey.shade900,
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20,),
                                          Text('Restaurant: '+snapshot.data?.docs[index]['restName'],style: TextStyle(fontSize: 20,color: Colors.white),),
                                          const SizedBox(height: 20,),
                                          Text('Address: '+snapshot.data?.docs[index]['address'],style: TextStyle(fontSize: 20,color: Colors.white),),
                                          Text('${snapshot.data?.docs[index]['zipcode']} ${snapshot.data?.docs[index]['city']}, ${snapshot.data?.docs[index]['state']}',style: TextStyle(fontSize: 20,color: Colors.white),),
                                          const SizedBox(height: 20,),
                                          Text('Phone: '+snapshot.data?.docs[index]['phone'],style: TextStyle(fontSize: 20,color: Colors.white),),
                                          const SizedBox(height: 20,),
                                          Text('Email: '+snapshot.data?.docs[index]['email'],style: TextStyle(fontSize: 20,color: Colors.white),),
                                          const SizedBox(height: 20,),
                                          Text('Weekday Hours: ${snapshot.data?.docs[index]['openTimeWKday']} - ${snapshot.data?.docs[index]['closeTimeWKday']}',style: TextStyle(fontSize: 20,color: Colors.white),),
                                          Text('Weekend Hours: ${snapshot.data?.docs[index]['openTimeWKend']} - ${snapshot.data?.docs[index]['closeTimeWKend']}',style: TextStyle(fontSize: 20,color: Colors.white),),
                                          Text(snapshot.data?.docs[index]['holidayHours'] == '' ? 'Holiday Hours: N/A':'Holiday Hours: ${snapshot.data?.docs[index]['holidayHours']}',style: TextStyle(fontSize: 20,color: Colors.white),),
                                        ],
                                      ),
                                    )
                                );
                              },
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

  //checks if restaurant is currently in use by checking the capacity at each table
  checkRestaurant(var restID) async {
    bool status = false;
    await FirebaseFirestore.instance.collection('tables').where('restID', isEqualTo: restID).get().then(
            (tables) {
              tables.docs.forEach((table) {
                if (table['currentCapacity'] > 0){
                  status = true;
                }
              });
            });
    return status;
  }

  
 deleteRestaurant(var id) async {
  bool status = await checkRestaurant(id);
  if (status){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('This restaurant could not be deleted'),
      ));
  } else {
      var restaurant = await FirebaseFirestore.instance.collection('restaurants').doc(id).get();
      await restaurant.reference.update({
        'isActive': false,
        'deletionDate': Timestamp.now(),
      });
    }
  }
}
