import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import  'package:intl/intl.dart';


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
                    if (snapshot.data?.docs.length == 0) {
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
          ],
        )
    );
  }

  //in-progress
  Future closeTable() async{
    var snapshot = await FirebaseFirestore.instance.collection(widget.tableID + '/tableMembers').where('isHolder', isEqualTo: false).get();
    for (var doc in snapshot.docs){
      await doc.reference.delete();
    }

  }

}
