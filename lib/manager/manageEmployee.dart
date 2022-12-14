import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/managerTile.dart';
import 'package:restaurant_management_system/manager/Utility/selectRestaurant.dart';
import 'package:restaurant_management_system/manager/managerHome.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'editEmployee.dart';

/*
This page will display all employees that a manager manages and allow them
to add/edit/delete or view each employee as needed.
 */


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
                  builder: (context) =>  SelectRestaurant(text: 'employee')
              )
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.person_add_alt_1),
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

            //retrieving and displaying each employee using custom ManagerTile widget
          child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users')
                      .where('managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .where('isActive', isEqualTo: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Text("You have no employees");
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ManagerTile (
                              name: (snapshot.data?.docs[index]['fName'] ?? '') + ' ' + (snapshot.data?.docs[index]['lName'] ?? ''),
                              subTitle: (snapshot.data?.docs[index]['email'] ?? '') + '\n' + (snapshot.data?.docs[index]['phone'] ?? ''),
                              onPressedDelete: () =>  {
                                deleteWaiter(snapshot.data?.docs[index].id),
                                Navigator.pop(context),
                              },
                              onPressedEdit: (p0) =>  {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>  EditEmployee(eID: (snapshot.data?.docs[index].reference.id ?? ''),
                                        fName: (snapshot.data?.docs[index]['fName'] ?? ''),
                                        lName: (snapshot.data?.docs[index]['lName'] ?? ''),
                                        prefName: (snapshot.data?.docs[index]['prefName'] ?? ''),
                                        phone: snapshot.data?.docs[index]['phone'] ?? '')
                                    ))
                              },
                              onTap: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight:Radius.circular(24))
                                    ),
                                    backgroundColor: Colors.blueGrey.shade900,
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20,),
                                            Text('Name: '+'${snapshot.data?.docs[index]['fName']} ${snapshot.data?.docs[index]['lName']}',style: TextStyle(fontSize: 20,color: Colors.white),),
                                            const SizedBox(height: 20,),
                                            Text(snapshot.data?.docs[index]['prefName'] == '' ? 'Preferred name: N/A':'Preferred name: ${snapshot.data?.docs[index]['prefName']}',style: TextStyle(fontSize: 20,color: Colors.white),),
                                            const SizedBox(height: 20,),
                                            Text('Email: '+snapshot.data?.docs[index]['email'],style: TextStyle(fontSize: 20,color: Colors.white),),
                                            const SizedBox(height: 20,),
                                            Text('Phone: '+snapshot.data?.docs[index]['phone'],style: TextStyle(fontSize: 20,color: Colors.white),),
                                          ],
                                        ),
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
      ),

    );
  }

  //function to delete a waiter
  deleteWaiter(id) async{
    await FirebaseFirestore.instance.collection('tables').where('waiterID', isEqualTo: id).get().then(
            (tables) {
              //check if there are tables that the waiter is currently assigned to
              if (tables.size != 0){
                //for each order at that table, mark it as 'unhandled'
                tables.docs.forEach((table) async {
                  await FirebaseFirestore.instance.collection('tables/${table.id}/tableOrders').get().then(
                          (orders) async {
                            orders.docs.forEach((order) async {
                              await FirebaseFirestore.instance.collection('orders').doc(order.id).update({
                                'waiterID': 'unhandled',
                              });
                            });
                          });
                  await table.reference.update({
                    'waiterID':'',
                    'waiterName': '',
                  });
                });
              }
            });
    //Can't use delete() function to
    //remove acct from firebase authentication because it only removes the acct of the
    //user that is currently signed in (which would be the manager since they are
    //the one that is deleting the waiter account(s)). To use the delete() function
    //on an account that is not your own, you must pay $ to upgrade your firebase plan
    //to have access to cloud functions to do this.
    //As an alternative, we will flag the waiter account as inactive
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'isActive': false,
    });
  }
}
