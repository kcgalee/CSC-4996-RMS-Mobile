import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/waiter/viewTable.dart';


class AllTables extends StatefulWidget {
  const AllTables({Key? key}) : super(key: key);

  @override
  State<AllTables> createState() => _AllTables();
}

class _AllTables extends State<AllTables> {
  var waiterRID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('All Tables'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: FutureBuilder(
            future: getRID(),
            builder: (context, snapshot) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables').where('restID', isEqualTo: waiterRID).orderBy('currentCapacity').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text('There are currently no tables at this restaurant'));
                    } else {
                      return GridView.builder(
                          itemCount: snapshot.data?.docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          itemBuilder:(context,index){
                            var boxColor, text, status;
                            if (snapshot.data?.docs[index]['currentCapacity'] > 0){
                              //if table unavailable then box is red
                              boxColor = Color(0xFFE24D4D);
                            } else {
                              //green if available
                              boxColor = Color(0xFF90C68E);
                            }
                            if (snapshot.data?.docs[index]['waiterID'] == '' || snapshot.data?.docs[index]['waiterName'] == ''){
                              text = ('Table ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                  + '\n' + (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '')
                                  + '/' + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? '')
                                  + '\nWaiter unassigned');
                              status = false;
                            } else {
                              text = ('Table ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                  + '\n' + (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '')
                                  + '/' + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? '')
                                  + '\nWaiter ' + (snapshot.data?.docs[index]['waiterName']));
                              status = true;
                            }
                            return InkWell(
                              child: Container(
                                height: 100,
                                width: 80,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: boxColor,width: 2)
                                ),
                                child: Center(
                                  child: Text(text,
                                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewTable(tableID: snapshot.data?.docs[index].reference.id ?? '', tableNum: snapshot.data?.docs[index]['tableNum'].toString() ?? '', assigned: status)
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
          waiterRID = element['restID'];
        }
    );
  }
}
