import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/selectRestaurant.dart';
import 'package:restaurant_management_system/manager/manageEmployee.dart';
import 'package:restaurant_management_system/manager/manageRestaurant.dart';
import '../login/mainscreen.dart';
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
          backgroundColor: const Color(0xff57c269),
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        //obtains manager name from database to greet the user
        body: FutureBuilder(
          future: getManagerName(),
          builder: (context, snapshot) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || (snapshot.data?.exists == false)) {
                      return Center(child:CircularProgressIndicator());
                    } else {
                    //if manager account is not active, then show pending activation widget
                        if (snapshot.data?['isActive'] == false){
                          return pendingActivation();
                        } else {
                          //else show manager dashboard
                          return SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(40),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        color: Color(0xff57c269),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(5.0, 5.0),
                                            blurRadius: 10.0,
                                            spreadRadius: 1.0,
                                          )
                                        ],
                                      ),
                                      child: Text(greeting,
                                        style: const TextStyle(fontSize: 25,color: Colors.white),),
                                    ),
                                    const SizedBox(height: 50,),
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
                                          CustomSubButton(
                                            text: 'MANAGE TABLES',
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'table')));
                                              //TODO CREATE ADD TABLES FEATURE
                                            },
                                          ),
                                          CustomSubButton(
                                            text: 'MANAGE MENU',
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'menu')));
                                              //TODO ADD TO MENU
                                            },
                                          ),
                                          CustomSubButton(
                                            text: 'RESTAURANT RATINGS',
                                            onPressed:  () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'restaurant ratings')));
                                              //TODO SHOW RATINGS
                                            },
                                          ),
                                          CustomSubButton(
                                            text: 'WAITER RATINGS',
                                            onPressed:  () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'waiter ratings')));
                                              //TODO SHOW RATINGS
                                            },
                                          ),
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

  //retrieves manager first name from firebase
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
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => const MainScreen()
                )
            );
          },
        ),
      ],
    );
  }
}
