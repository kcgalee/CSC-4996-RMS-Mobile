import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/request_tile.dart';


class WaiterRequest extends StatefulWidget {
  final String rName;
  const WaiterRequest({Key? key, required this.rName}) : super(key: key);

  @override
  State<WaiterRequest> createState() => _WaiterRequestState();
}

class _WaiterRequestState extends State<WaiterRequest> {
  // text controller
  final _controller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Requests',),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Text(widget.rName,
              style: TextStyle(fontSize: 30,),),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('orders')
                      .where('waiterID', whereIn: [[FirebaseAuth.instance.currentUser?.uid],['']])
                      .where('status', isNotEqualTo: 'delivered')
                      .orderBy('status')
                      .orderBy('timePlaced', descending: false).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                      return Center(child:Text('You have no active requests'));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            String text = '';
                            if (snapshot.data?.docs[index]['itemName'] == 'Request Waiter'){
                              text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                  + '\nRequested: Waiter'
                                  + '\nQuantity: ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                  + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '');
                            } else if (snapshot.data?.docs[index]['itemName'] == 'Request Bill'){
                              text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                  + '\nRequested: Bill'
                                  + '\nQuantity: ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                  + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '');
                            } else {
                              text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                  + '\nRequested: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                  + '\nQuantity: ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                  + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '');
                            }
                            return RequestTile(
                              taskName: text,
                              //for debugging
                              // + '\nStatus: ' + (snapshot.data?.docs[index]['status'] ?? ''),
                              time: snapshot.data?.docs[index]['timePlaced'],
                              orderID: (snapshot.data?.docs[index].reference.id ?? ''),
                              oStatus: (snapshot.data?.docs[index]['status'] ?? ''),
                              tableID: snapshot.data?.docs[index]['tableID'],
                              orderDoc: snapshot.data?.docs[index].reference.id ?? '',
                            );
                          }
                      );
                    }
                  }),
            ),
          ],
        )
    );
  }
}
