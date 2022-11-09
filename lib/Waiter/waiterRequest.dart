import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/request_tile.dart';


class WaiterRequest extends StatefulWidget {
  final String rName;
  final String activity;
  const WaiterRequest({Key? key, required this.rName, required this.activity}) : super(key: key);

  @override
  State<WaiterRequest> createState() => _WaiterRequestState();
}

class _WaiterRequestState extends State<WaiterRequest> {
  // text controller
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.activity == 'active'){
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Current Requests',),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Column(
            children: [
              const SizedBox(height: 20,),
              Text(widget.rName,
                style: TextStyle(fontSize: 30,),),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('orders')
                        .where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .where('status', isNotEqualTo: 'delivered')
                        .orderBy('status')
                        .orderBy('priority')
                        .orderBy('timePlaced', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                        return Center(child:Text('You have no current requests'));
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              String text = '';
                              if (snapshot.data?.docs[index]['itemName'] == 'Request Waiter'){
                                text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                    + '\nRequested: Waiter'
                                    + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '');
                              } else if (snapshot.data?.docs[index]['itemName'] == 'Request Bill'){
                                text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                    + '\nRequested: Bill'
                                    + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '');
                              } else {
                                text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                    + '\nItem: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                    + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                    + '\nPlaced by ' + (snapshot.data?.docs[index]['custName'] ?? '');
                              }
                              if (snapshot.data?.docs[index]['orderComment'] != ''){
                                text += '\nComments: ${snapshot.data?.docs[index]['orderComment']}';
                              } else {
                                text += '\nComments: none';
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
                                inactive: false,
                              );
                            }
                        );
                      }
                    }),
              ),
            ],
          )
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Past Requests',),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Column(
            children: [
              const SizedBox(height: 20,),
              Text(widget.rName,
                style: TextStyle(fontSize: 30,),),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('orders')
                        .where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .where('status', isEqualTo: 'delivered')
                        .orderBy('timePlaced', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                        return Center(child:Text('You have no past requests'));
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              String text = '';
                              if (snapshot.data?.docs[index]['itemName'] == 'Request Waiter'){
                                text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                    + '\nRequested: Waiter'
                                    + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '');
                              } else if (snapshot.data?.docs[index]['itemName'] == 'Request Bill'){
                                text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                    + '\nRequested: Bill'
                                    + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '');
                              } else {
                                text = 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? '')
                                    + '\nItem: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                    + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                    + '\nPlaced by ' + (snapshot.data?.docs[index]['custName'] ?? '');
                              }
                              if (snapshot.data?.docs[index]['orderComment'] != ''){
                                text += '\nComments: ${snapshot.data?.docs[index]['orderComment']}';
                              } else {
                                text += '\nComments: none';
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
                                inactive: true,
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
}
