import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/addEmployee.dart';
import 'package:restaurant_management_system/manager/Utility/selectCategory.dart';
import 'package:restaurant_management_system/manager/managerHome.dart';

import '../../widgets/customBackButton.dart';
import '../manageTables.dart';
import 'MangerNavigationDrawer.dart';



class SelectRestaurant extends StatefulWidget {
final String text;
  SelectRestaurant({Key? key, required this.text}) : super(key: key);
  @override
  _SelectRestaurant createState() => _SelectRestaurant(text: text);

}
class _SelectRestaurant extends State<SelectRestaurant> {

  List menuList = [];
  final uID = FirebaseAuth.instance.currentUser?.uid;
  final String text;
  _SelectRestaurant({Key? key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Select Restaurant'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
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
                  stream: FirebaseFirestore.instance.
                  collection('restaurants')
                  .where('managerID', isEqualTo: uID?.trim())
                  .where('isActive', isEqualTo: true)
                  .orderBy('restName')
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: CircularProgressIndicator(),);
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 24,right: 24,bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.grey[100],
                                    border: Border.all(color: Colors.black54,width: 2)
                                ),
                                child: ListTile(
                                  title: Text(snapshot.data?.docs[index]['restName'] ?? ''),
                                  subtitle: Text(snapshot.data?.docs[index]['address'] ?? ''),
                                  onTap: () {
                                    String? rID = snapshot.data?.docs[index].id;
                                    String? restName = snapshot.data?.docs[index]['restName'];
                                    if(text == 'table'){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ManageTables(restaurantID: rID.toString(), restName: restName.toString())));
                                    }
                                    else if (text == 'employee'){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AddEmployee(text: rID.toString(), rName: restName.toString())));
                                      }
                                    else if (text == 'menu'){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectCategory(restaurantID: rID.toString(), rName: restName.toString())));
                                    }
                                    else{

                                    }
                                  },
                                ),
                              ),
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

}