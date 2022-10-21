import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TableStatus extends StatefulWidget {
  const TableStatus({Key? key}) : super(key: key);

  @override
  State<TableStatus> createState() => _TableStatusState();
}

class _TableStatusState extends State<TableStatus> {
  String restName = "";
  String tableID ="";
  String tableNum ="";
  String restID = "";
  String waiterName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Table Status',),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Text(
              restName,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment. center,
              crossAxisAlignment: CrossAxisAlignment. center,
              children: [
                const Text(
                    "Table "
                ),
                Text(
                  tableNum,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment. center,
              crossAxisAlignment: CrossAxisAlignment. center,
              children: [
                const Text(
                  "Waiter ",
                  textAlign: TextAlign.left,
                ),
                Text(
                  waiterName,
                  textAlign: TextAlign.left,
                ),
              ],
            ),

          ],
        )
    );
  }
}
