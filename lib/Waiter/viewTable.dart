import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';


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
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text("Table Orders"),
          elevation: 0,
        ),
        body: Column(
          children: [
            Text('Table: '+ widget.tableNum,),
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
                          return ListTile(
                            title: Text("x" + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                + ' ' + (snapshot.data?.docs[index]['itemName'].toString() ?? '')
                                + ' \$' + (snapshot.data?.docs[index]['price'].toString() ?? '')
                            ),
                          );
                        }
                      );
                    }
                  }),
            ),
          ElevatedButton(
            onPressed: () => {
              closeTable(),
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WaiterTables()))
            },
            child: const Text("CLOSE TABLE"),
          )],
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
