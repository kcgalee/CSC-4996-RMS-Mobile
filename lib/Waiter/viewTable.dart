import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/viewTableTile.dart';
import 'package:restaurant_management_system/waiter/waiterTables.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import '../login/mainscreen.dart';
import '../widgets/customGreenButton.dart';
import '../widgets/customRedButton.dart';
import 'package:intl/intl.dart';


class ViewTable extends StatefulWidget {
  final String tableID;
  final String tableNum;
  final bool assigned;
  final int currentCapacity;
  const ViewTable({super.key, required this.tableID, required this.tableNum, required this.assigned, required this.currentCapacity});

  @override
  State<ViewTable> createState() => _ViewTableState();
}

class _ViewTableState extends State<ViewTable> {
  List<int> total = [];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Table Orders"),
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

  Widget home() {
    if (widget.assigned){
      if (widget.currentCapacity != 0){
        return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('Table: '+ widget.tableNum,style: TextStyle(fontSize: 25,),),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').orderBy('custName').orderBy('timePlaced', descending: true).snapshots(),
                      builder: (context, snapshot){
                        if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                          return Center(child: Text("No orders have been placed yet"),);
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index){
                                return ViewTableTile(
                                    taskName: "x" + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                        + ' ' + (snapshot.data?.docs[index]['itemName'].toString() ?? ''),
                                    subTitle: ' \$' + (snapshot.data?.docs[index]['price'].toString() ?? ''
                                    ));
                              }
                          );
                        }
                      }),
                ),
                CustomMainButton(
                    text: 'LEAVE TABLE',
                    onPressed: () => {
                      leaveTable(),
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => const WaiterTables()))
                    }
                ),
                CustomRedButton(
                    text: 'CLOSE TABLE',
                    onPressed: () => {
                      closeTable(),
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => const WaiterTables()))
                    }
                ),
              ],
        );
      } else {
        return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('Table: '+ widget.tableNum,style: TextStyle(fontSize: 25,),),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').orderBy('custName').orderBy('timePlaced', descending: true).snapshots(),
                      builder: (context, snapshot){
                        if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                          return Center(child: Text("No orders have been placed yet"),);
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index){
                                return ViewTableTile(
                                    taskName: "x" + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                        + ' ' + (snapshot.data?.docs[index]['itemName'].toString() ?? ''),
                                    subTitle: ' \$' + (snapshot.data?.docs[index]['price'].toString() ?? ''
                                    ));
                              }
                          );
                        }
                      }),
                ),
                CustomMainButton(
                    text: 'LEAVE TABLE',
                    onPressed: () => {
                      leaveTable(),
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => const WaiterTables()))
                    }
                ),
              ],
        );
      }
    } else {
      return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Table: '+ widget.tableNum,style: TextStyle(fontSize: 25,),),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').orderBy('custName').orderBy('timePlaced', descending: true).snapshots(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                        return Center(child: Text("No orders have been placed yet"),);
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index){
                              return ViewTableTile(
                                  taskName: "x" + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                      + ' ' + (snapshot.data?.docs[index]['itemName'].toString() ?? ''),
                                  subTitle: ' \$' + (snapshot.data?.docs[index]['price'].toString() ?? ''
                                  ));
                            }
                        );
                      }
                    }),
              ),
              CustomGreenButton(
                  text: 'JOIN TABLE',
                  onPressed: () => {
                    joinTable(),
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => const WaiterTables()))
                  }
              ),],
      );
    }
  }

  Future joinTable() async{
    String name = "";
    var user = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(user).get().then(
            (data) {
              if (data['prefName'] == ''){
                name = data['fName'];
              } else {
                name = data['prefName'];
              }
            }
    );

    var table = await FirebaseFirestore.instance.collection('tables').doc(widget.tableID).get();
    await table.reference.update({
      'waiterID': user,
      'waiterName': name,
    });

    await FirebaseFirestore.instance.collection('orders').where('tableID', isEqualTo: widget.tableID).where('waiterID', isEqualTo: 'unhandled').get().then(
          (orders) {
            if (orders.size != 0){
              orders.docs.forEach((element) {
                element.reference.update({
                  'waiterID': user,
                });
              });
            }
      });

 //ADD waiterID to customer's user document
    await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableMembers').get().then((value){
      for(int i = 0; i < value.docs.length; i++) {
        addWaiterID(value.docs[i].data()['userID']);
      }
    });


  }

  Future closeTable() async{
    var memCount = 0;
    var members = await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableMembers').get();

    await FirebaseFirestore.instance.collection('tables/${widget.tableID}/tableMembers').get().then((value){
      for(int i = 0; i < value.docs.length; i++) {
        clearTable(value.docs[i].data()['userID'], widget.tableID);
      }
    });

    for (var doc in members.docs){
      await doc.reference.delete();
      memCount++;
    }


    await FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').get().then(
            (value) {
              value.docs.forEach((element) async {
                if (element['status'] != 'delivered'){
                  await FirebaseFirestore.instance.collection('orders').doc(element.id).update({
                    'status': 'delivered',
                  });
                }
              });
            });

    var orders = await FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').get();
    for (var doc in orders.docs){
      await doc.reference.delete();
    }

    var table = await FirebaseFirestore.instance.collection('tables').doc(widget.tableID).get();
    await table.reference.update({
      'waiterID': '',
      'waiterName': '',
      'currentCapacity': 0,
      'billRequested': false,
      'waiterRequested' : false
    });
    
    var rID = table['restID'];
    await FirebaseFirestore.instance.collection('cpd').doc().set({
      'date': Timestamp.now(),
      'members': memCount,
      'restID': rID,
      'waiterID': FirebaseAuth.instance.currentUser?.uid,
    });
  }

  //Customer
  Future<void> clearTable(String userID, String tableID) async {

    var restName = '';
    var waiterName = '';

    //get restName, waiterName
    await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(
            (element) {

          waiterName = element['waiterName'];
          restName = element['restName'];
        });


    FirebaseFirestore.instance.collection('users').doc(userID).update({
      'tableID': '',
    } );


    //Set customers past visit document
    CollectionReference pastVisitCollRef = FirebaseFirestore.instance.collection('users/$userID/pastVisits');

    String visitID = pastVisitCollRef
        .doc()
        .id
        .toString()
        .trim();

    pastVisitCollRef.doc(visitID).set({
      'waiterName': waiterName,
      'date' : Timestamp.now(),
      'restName' : restName,
    });

    //update orders for past visit
    FirebaseFirestore.instance.collection('tables/$tableID/tableOrders').get().then((value) {
      for (int i = 0; i < value.size; i++) {

        if(value.docs[i].data()['itemName'] != 'Request Waiter' &&
            value.docs[i].data()['itemName'] != "Request Bill") {
          FirebaseFirestore.instance.collection('users/$userID/pastVisits/$visitID/tableOrders').doc().set(
            {
              'itemName' : value.docs[i].data()['itemName'],
              'price' : value.docs[i].data()['price'],
              'quantity' : value.docs[i].data()['quantity'],
              'orderComment' : value.docs[i].data()['orderComment'],
              'custName' : value.docs[i].data()['custName'],
              'imgURL' : value.docs[i].data()['imgURL'],
            });
        }
      }

    });


  }
  //End of clearTable

  void addWaiterID(String userID) {
    FirebaseFirestore.instance.collection('users').doc(userID).update({
      'waiterID': FirebaseAuth.instance.currentUser?.uid.toString(),
    } );
  }

  leaveTable() async {
    FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').get().then(
            (element) {
              element.docs.forEach((element) async {
                await FirebaseFirestore.instance.collection('orders').doc(element.id).update({
                  'waiterID': 'unhandled',
                });
              });
            });

    var table = await FirebaseFirestore.instance.collection('tables').doc(widget.tableID).get();
    await table.reference.update({
      'waiterID': '',
      'waiterName': '',
    });
  }

}
