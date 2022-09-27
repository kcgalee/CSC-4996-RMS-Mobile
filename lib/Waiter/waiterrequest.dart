import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/dialog_box.dart';

import 'Utility/request_tile.dart';

class WaiterRequest extends StatefulWidget {
  const WaiterRequest({Key? key}) : super(key: key);

  @override
  State<WaiterRequest> createState() => _WaiterRequestState();
}

class _WaiterRequestState extends State<WaiterRequest> {
  // text controller
  final _controller = TextEditingController();
  Stream getRequests = FirebaseFirestore.instance.collection('orders').where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots();
  var waiterRID;
  //final Stream queryTables = FirebaseFirestore.instance.collection('tables').where('restaurantID', isEqualTo: waiterRID).snapshots();

  List<String> tableDocList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text('Requests'),
        elevation: 0,
      ),
        body: StreamBuilder(
            stream: getRequests,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                    child: CircularProgressIndicator()
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return RequestTile(
                        taskName: "Table: " + snapshot.data.docs[index]['tableName']
                            + ' Requested: ' + snapshot.data.docs[index]['itemID'],
                        // taskCompleted: snapshot.data.docs[index]['tableName'][1],
                        // onChanged: ,
                        //deleteFunction: deleteFunction

                      );
                    }
                );
              }

              })
        );
  }

}
