import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/login/mainscreen.dart';

import 'Utility/MangerNavigationDrawer.dart';

class ManagerHome extends StatefulWidget {


  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome>{
String managerName = '';

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
          future: getName(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Text("Hello, " + managerName,
                        style: const TextStyle(fontSize: 25,),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO SHOW ALL RESTAURNATS
                        },
                        child: const Text('MANAGE RESTAURANTS',),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO SHOW ALL EMPLOYEES
                        },
                        child: const Text('MANAGE EMPLOYEES',),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO SHOW RATINGS
                        },
                        child: const Text('SEE RATINGS',),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO CREATE ADD TABLES FEATURE
                        },
                        child: const Text("ADD TABLE"),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO REMOVE TABLES

                        },
                        child: const Text("REMOVE TABLE"),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        fixedSize: const Size(330, 56),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        side: const BorderSide(
                          color: Colors.black38,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        //TODO ADD TO MENU

                      },
                      child: const Text("MANAGE MENU"),
                    ),
                    

                  ], //Children
                ));
          },
        ));
  }

  Future getName() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
              managerName = element['fName'];
            }

    );

  }
}
