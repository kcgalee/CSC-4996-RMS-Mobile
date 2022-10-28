import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_management_system/customer/viewMemberOrder.dart';

import '../widgets/customSubButton.dart';
import 'Models/createOrderInfo.dart';
import 'Utility/navigation.dart';
import 'customerHome.dart';


class TableStatus extends StatefulWidget {
String tableNum, waiterName;
  TableStatus({Key? key, required this.tableNum, required this.waiterName }) :super(key: key);

  @override
  State<TableStatus> createState() => _TableStatusState();
}

class _TableStatusState extends State<TableStatus> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: Text('Table ${widget.tableNum}, Waiter ${widget.waiterName}'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if(userSnapshot.hasData) {

                    //===============================
                    //ERROR HANDLING FOR CLOSED TABLE
                    //===============================

                    if(userSnapshot.data!['tableID'] == ''){
                      return Column(
                        children:  [
                          const Text('Table Closed'),

                          CustomSubButton(text: "Back to Home Page",
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerHome()));
                            },
                          ),

                        ],

                      );
                    }

                    return Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                              'tables/${userSnapshot.data!['tableID']}/tableMembers')
                              .snapshots(),
                          builder: (context, tableSnapshot) {
                            if(tableSnapshot.hasData) {
                              return ListView.builder(
                                  itemCount: tableSnapshot.data?.docs.length,
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.grey[100],
                                            border: Border.all(color: Colors.black54,width: 2)
                                        ),
                                        child: ListTile(
                                          title: Text(tableSnapshot.data?.docs[index]['fName'] ?? ''),
                                          onTap: () {
                                            var custID = tableSnapshot.data?.docs[index]['userID'];
                                            var custName = tableSnapshot.data?.docs[index]['fName'];
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) =>  ViewMemberOrder(custID: custID, custName: custName,)));
                                          },
                                        ),
                                      ),
                                    );

                                  });
                            }
                            else {
                              return Text('no items to display');
                            }
                          }),
                    );
                  }
                  else{
                    return const Text("no data found");
                  }
                })
          ],
        )

    );

  }
}
