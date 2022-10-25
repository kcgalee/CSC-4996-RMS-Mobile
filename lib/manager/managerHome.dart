import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/selectRestaurant.dart';
import 'package:restaurant_management_system/manager/addTable.dart';
import 'package:restaurant_management_system/manager/manageEmployee.dart';
import 'package:restaurant_management_system/manager/manageRestaurant.dart';

import '../widgets/customSubButton.dart';
import 'Utility/MangerNavigationDrawer.dart';

class ManagerHome extends StatefulWidget {


  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome>{
String greeting = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        appBar: AppBar(
          title: const Text("Manager Home"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: FutureBuilder(
          future: getManagerName(),
          builder: (context, snapshot) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || (snapshot.data?.exists == false)) {
                      return Center(child:CircularProgressIndicator());
                    } else {
                        if (snapshot.data?['isActive'] == false){
                          //kylie
                          return pendingActivation();
                        } else {
                          return SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(26),
                                      child: Text(greeting,
                                        style: const TextStyle(fontSize: 25,),),
                                    ),
                                          CustomSubButton(
                                            text: 'MANAGE RESTAURANTS',
                                            onPressed:  () {
                                              //TODO SHOW ALL RESTAURANTS
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const ManageRestaurant()
                                                  )
                                              );
                                            },
                                          ),

                                          CustomSubButton(
                                            text: 'MANAGE EMPLOYEES',
                                            onPressed: () {
                                              //TODO SHOW ALL EMPLOYEES
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const ManageEmployee()
                                                  )
                                              );
                                            },
                                          ),
                                          /*  CustomSubButton(
                                              text: 'SEE RATINGS',
                                              onPressed:  () {
                                                //TODO SHOW RATINGS
                                              },
                                            ),
                                           */
                                          CustomSubButton(
                                            text: 'ADD TABLE',
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'table')));
                                              //TODO CREATE ADD TABLES FEATURE
                                            },
                                          ),
                                          CustomSubButton(
                                            text: 'REMOVE TABLE',
                                            onPressed: () {
                                              //TODO REMOVE TABLES

                                            },
                                          ),
                                          CustomSubButton(
                                            text: 'MANAGE MENU',
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'menu')));
                                              //TODO ADD TO MENU
                                            },
                                          )

                                        ], //Children
                                      ),
                                    ));
                                }
                            }
                      }
            );
            },
        ));
  }

  Future getManagerName() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
              greeting = 'Hello, ' + element['fName'] + "!";
            }

    );

  }

  Widget pendingActivation() {
    return AlertDialog(
      title: const Text('Pending Account Activation'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Your Manager account is still under approval. Please check back after 24 hours.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }


}
