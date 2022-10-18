import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/managerTile.dart';
import 'package:restaurant_management_system/manager/addEmployee.dart';

import 'Utility/MangerNavigationDrawer.dart';
import 'editEmployee.dart';

class ManageEmployee extends StatefulWidget {
  const ManageEmployee({Key? key}) : super(key: key);

  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Manage Employee"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>  AddEmployee()
              )
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.person_add_alt_1),
        backgroundColor: Colors.black,
      ),


      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').where('managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Text("You have no employees");
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ManagerTile (
                              taskName: (snapshot.data?.docs[index]['fName'] ?? '') + ' ' + (snapshot.data?.docs[index]['lName'] ?? ''),
                              subTitle: snapshot.data?.docs[index]['email'] ?? '',
                              onPressedDelete: (){},
                              onPressedEdit: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>  EditEmployee(eID: (snapshot.data?.docs[index].reference.id ?? ''),
                                        fName: (snapshot.data?.docs[index]['fName'] ?? ''),
                                        lName: (snapshot.data?.docs[index]['lName'] ?? ''),
                                        prefName: (snapshot.data?.docs[index]['lName'] ?? ''),
                                        email: snapshot.data?.docs[index]['email'] ?? '')
                                ));
                              },

                            );
                          }
                      );
                    }
                  }),
          ),
        ],
      ),

    );
  }
}
