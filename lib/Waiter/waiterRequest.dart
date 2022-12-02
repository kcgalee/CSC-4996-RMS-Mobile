import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login/mainscreen.dart';
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
  String orderBy = 'timePlaced';
  bool desc = false;

  @override
  Widget build(BuildContext context) {
    if (widget.activity == 'active') {
      return Scaffold(
          backgroundColor: Color(0xffEBEBEB),
          appBar: AppBar(
            title: const Text('Current Requests',),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot){
                if (!snapshot.hasData || (snapshot.data?.exists == false)) {
                  return Center(child:CircularProgressIndicator());
                } else {
                  if (snapshot.data?['isActive'] == false){
                    return AlertDialog(
                      title: const Text('Account is Deactivated'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('Your Waiter account has been deactivated by your manager.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()
                                )
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return home();
                  }
                }
              }
          ));
    } else {
      return Scaffold(
          backgroundColor: Color(0xffEBEBEB),
          appBar: AppBar(
            title: const Text('Past Requests',),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot){
                if (!snapshot.hasData || (snapshot.data?.exists == false)) {
                  return Center(child:CircularProgressIndicator());
                } else {
                  if (snapshot.data?['isActive'] == false){
                    return AlertDialog(
                      title: const Text('Account is Deactivated'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('Your Waiter account has been deactivated by your manager.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()
                                )
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return home();
                  }
                }
              }
          ));
    }
  }

  Widget home() {
    if (widget.activity == 'active'){
      return Column(
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
                              String comment = '';
                              Icon orderIcon; //set request tile Icon
                              Color boxColor = Colors.white;//set request tile color
                              String requestedItem = '';
                              if (snapshot.data?.docs[index]['itemName'] == 'Request Waiter'){
                                requestedItem = 'Requested: Waiter';
                                orderIcon = Icon(Icons.person);
                                boxColor = Colors.indigo.shade200;
                              } else if (snapshot.data?.docs[index]['itemName'] == 'Request Bill'){
                                requestedItem = 'Requested: Bill';
                                orderIcon = Icon(Icons.sticky_note_2_rounded);
                                boxColor = Colors.indigo.shade200;
                              } else {
                                requestedItem = 'Item: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                    + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '');
                                orderIcon = Icon(Icons.circle_outlined,color: Colors.grey.shade100,);
                              }
                              if (snapshot.data?.docs[index]['orderComment'] != ''){
                                comment = 'Comments: ${snapshot.data?.docs[index]['orderComment']}';
                              } else {
                                comment = 'Comments: none';
                              }
                              return RequestTile(
                                boxColor: boxColor,
                                orderIcon: orderIcon,
                                tableNum: 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? ''),
                                request: requestedItem,
                                customerName: 'Customer: ' + (snapshot.data?.docs[index]['custName'] ?? ''),
                                comment: comment,
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
      );
    } else {
      return Column(
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
                              String comment = '';
                              String requestedItem = '';
                              Icon orderIcon;
                              Color boxColor = Colors.white; // set Request tile colore white
                              if (snapshot.data?.docs[index]['itemName'] == 'Request Waiter'){
                                requestedItem = 'Requested: Waiter';
                                orderIcon = Icon(Icons.person);
                              } else if (snapshot.data?.docs[index]['itemName'] == 'Request Bill'){
                                requestedItem = 'Requested: Bill';
                                orderIcon = Icon(Icons.sticky_note_2_rounded);
                              } else {
                                requestedItem = 'Item: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                    + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '');
                                orderIcon = Icon(Icons.circle_outlined,color: Colors.grey.shade100,);
                              }
                              if (snapshot.data?.docs[index]['orderComment'] != ''){
                                comment = 'Comments: ${snapshot.data?.docs[index]['orderComment']}';
                              } else {
                                comment = 'Comments: none';
                              }
                              return RequestTile(
                                boxColor: boxColor,
                                orderIcon: orderIcon,
                                tableNum: 'Table: ' + (snapshot.data?.docs[index]['tableNum'].toString() ?? ''),
                                request: requestedItem,
                                customerName: 'Customer: ' + (snapshot.data?.docs[index]['custName'] ?? ''),
                                comment: comment,
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
      );
    }
  }
}
