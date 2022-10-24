import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Models/createOrderInfo.dart';


class TableStatus extends StatefulWidget {
  CreateOrderInfo createOrderInfo;
  TableStatus({Key? key, required this.createOrderInfo}) :super(key: key);

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
                    "Table: "
                ),
                Text(
                  widget.createOrderInfo.tableNum.toString(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment. center,
              crossAxisAlignment: CrossAxisAlignment. center,
              children: [
                const Text(
                  "Waiter: ",
                  textAlign: TextAlign.left,
                ),
                Text(
                  widget.createOrderInfo.waiterName,
                  textAlign: TextAlign.left,
                ),
              ],
            ),

          ],
        )
    );
  }
}
