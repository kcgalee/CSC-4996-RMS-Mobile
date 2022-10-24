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
                Text(
                  "# Table Members",
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 30,),
            const Text(
              "Table Members",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Container(
                    height: 70.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey ,
                              blurRadius: 2.0,
                              offset: Offset(2.0,2.0)
                          )
                        ]
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Member Name"),
                          ElevatedButton(
                          child: const Text( "View Order",
                            style: TextStyle(
                            color: Colors.white,
                            ),
                          ),
                          onPressed: ()
                          {
                          showDialog(
                          context: context,
                          builder: (BuildContext context) {
                             return
                                AlertDialog(
                                  insetPadding: EdgeInsets.zero,
                                  //title: Text(snapshot.data?.docs[index]['name']),

                                  content: Builder(
                                    builder: (context) {
                                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                      var height = MediaQuery.of(context).size.height;
                                      var width = MediaQuery.of(context).size.width;

                                      return Container(
                                        // to change dimensions of alert dialog box
                                        height: height - 400,
                                        width: width - 400,
                                        child: Text("populate orders here"),
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child:  const Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                          },
                          );
                              }
    )
                        ],
                      ),
                    ),
                )
            ),

          ],
        )
    );
  }
}
