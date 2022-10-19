import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/viewTableTile.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';

import '../widgets/customRedButton.dart';


class ViewTable extends StatefulWidget {
  final String tableID;
  final String tableNum;

  const ViewTable({super.key, required this.tableID, required this.tableNum});

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Table: '+ widget.tableNum,style: TextStyle(fontSize: 25,),),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').where('isHolder', isNotEqualTo: true).snapshots(),
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


                            /*ListTile(
                            title: Text("x" + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                + ' ' + (snapshot.data?.docs[index]['itemName'].toString() ?? '')
                                + ' \$' + (snapshot.data?.docs[index]['price'].toString() ?? '')
                            ),
                          );*/
                        }
                      );
                    }
                  }),
            ),
             CustomRedButton(
              text: 'CLOSE TABLE',
              onPressed: () => {
                closeTable(),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const WaiterTables()))
              }
            ),],
        )
    );
  }

  //in-progress
  Future closeTable() async{
    var members = await FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableMembers').where('isHolder', isEqualTo: false).get();
    for (var doc in members.docs){
      await doc.reference.delete();
    }

    var orders = await FirebaseFirestore.instance.collection('tables/' + widget.tableID + '/tableOrders').where('isHolder', isEqualTo: false).get();
    for (var doc in orders.docs){
      await doc.reference.delete();
    }

    var table = await FirebaseFirestore.instance.collection('tables').doc(widget.tableID).get();
    await table.reference.update({
      'waiterID': ''
    });
  }

}
