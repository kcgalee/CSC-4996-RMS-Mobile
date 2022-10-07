import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/dialog_box.dart';
import 'package:restaurant_management_system/Waiter/viewTable.dart';
import 'Utility/request_tile.dart';

class WaiterTables extends StatefulWidget {
  const WaiterTables({Key? key}) : super(key: key);

  @override
  State<WaiterTables> createState() => _WaiterTablesState();
}

class _WaiterTablesState extends State<WaiterTables> {
  // text controller
  final _controller = TextEditingController();

  var waiterRID;

  List<String> tableDocList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text('Assigned Tables'),
          elevation: 0,
        ),
        body: FutureBuilder(
            future: getRID(),
            builder: (context, snapshot) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables').where('restaurantID', isEqualTo: waiterRID).where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text("You are not servicing any tables."),);
                    }else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            var text = (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '') + '/' + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? '');
                            return ListTile(
                              title: Text(
                                  'Table ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')),
                              subtitle: Text(text),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewTable(tableID: snapshot.data?.docs[index].reference.id ?? '', tableNum: snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                    )
                                );
                              },
                            );
                          }
                      );
                    }
                  });
            })
    );
  }

  Future getRID() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
          print(element.reference);
          //set2.add(element);
          waiterRID = element['restaurantID'].toString();
          print(waiterRID);
        }
    );
  }

  //original
  Future getTables() async {
    await FirebaseFirestore.instance.collection('tables').where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get().then(
          (snapshot) => snapshot.docs.forEach(
              (element) {
            print(element.reference.id.toString());
            tableDocList.add(element.reference.id.toString());
          }),
    );
    //tableDocList.add(element.reference.id); to get doc id
  }
}
