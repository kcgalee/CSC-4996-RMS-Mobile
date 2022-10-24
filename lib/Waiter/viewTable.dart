import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/viewTableTile.dart';
import 'package:restaurant_management_system/waiter/waiterTables.dart';
import '../widgets/customRedButton.dart';
import 'package:intl/intl.dart';


class ViewTable extends StatefulWidget {
  final String tableID;
  final String tableNum;
  final bool assigned;

  const ViewTable({super.key, required this.tableID, required this.tableNum, required this.assigned});

  @override
  State<ViewTable> createState() => _ViewTableState();
}

class _ViewTableState extends State<ViewTable> {
  List<int> total = [];

  @override
  Widget build(BuildContext context) {
    if (widget.assigned == true){
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Table Orders"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Column(
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
              CustomRedButton(
                  text: 'CLOSE TABLE',
                  onPressed: () => {
                    closeTable(),
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => const WaiterTables()))
                  }
              ),],
          )
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Table Orders"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Column(
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
              CustomRedButton(
                  text: 'JOIN TABLE',
                  onPressed: () => {
                    joinTable(),
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => const WaiterTables()))
                  }
              ),],
          )
      );
    }
  }

  //in-progress
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
  }

  //in-progress
  Future closeTable() async{
    var memCount = 0;
    var members = await FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableMembers').get();
    for (var doc in members.docs){
      await doc.reference.delete();
      memCount++;
    }

    var orders = await FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').get();
    for (var doc in orders.docs){
      await doc.reference.delete();
    }

    var table = await FirebaseFirestore.instance.collection('tables').doc(widget.tableID).get();
    await table.reference.update({
      'waiterID': '',
      'waiterName': '',
    });
    
    var rID = table['restID'];
    await FirebaseFirestore.instance.collection('cpd').doc().set({
      'date': DateFormat('EEEE').format(DateTime.now()),
      'members': memCount,
      'restID': rID,
    });
  }
}
