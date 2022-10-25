import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_management_system/customer/viewMemberOrder.dart';

import 'Models/createOrderInfo.dart';


class TableStatus extends StatefulWidget {
  CreateOrderInfo createOrderInfo;
  String tableID, tableNum, waiterName;
  TableStatus({Key? key, required this.createOrderInfo, required this.tableID,
  required this.tableNum, required this.waiterName}) :super(key: key);

  @override
  State<TableStatus> createState() => _TableStatusState();
}

class _TableStatusState extends State<TableStatus> {
  String restName = "";
  String restID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Table ${widget.tableNum}, Waiter ${widget.waiterName}'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.
            collection('tables/${widget.tableID}/tableMembers')
                .snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                return Center(child: Text("NO TABLE MEMBERS"),);
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey[100],
                              border: Border.all(color: Colors.black54,width: 2)
                          ),
                          child: ListTile(
                            title: Text(snapshot.data?.docs[index]['fName'] ?? ''),
                            onTap: () {
                             var custID = snapshot.data?.docs[index]['userID'];
                             var custName = snapshot.data?.docs[index]['fName'];
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>  ViewMemberOrder(createOrderInfo: widget.createOrderInfo, tableID: widget.tableID, custID: custID, custName: custName)));
                            },
                          ),
                        ),
                      );
                    }
                );
              }
            })

    );

  }
}
