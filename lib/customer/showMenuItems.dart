import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/editRestaurant.dart';

import 'Models/createOrderInfo.dart';



class ShowMenuItems extends StatefulWidget {
  final String text, tableID, restName, restID;
  CreateOrderInfo createOrderInfo;

  ShowMenuItems({Key? key, required this.text, required this.tableID,
    required this.restName, required this.restID, required this.createOrderInfo}) : super(key: key);

  @override
  State<ShowMenuItems> createState() => _ShowMenuItems(text: text, tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo );
}



class _ShowMenuItems extends State<ShowMenuItems> {
  CreateOrderInfo createOrderInfo;
  List menuList = [];
  final String text, tableID, restName, restID;

  _ShowMenuItems({Key? key, required this.text,  required this.tableID,
  required this.restName, required this.restID, required this.createOrderInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text('Menu Items'),
          elevation: 0,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.
            collection('menu')
                .where('category', isEqualTo: text)
                .where('restID', isEqualTo: restID)
                .snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
              return Center(child: Text("No items to display."),);
            } else {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data?.docs[index]['name'] ?? ''),
                        subtitle: Text(snapshot.data?.docs[index]['price'] ?? ''),

                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(snapshot.data?.docs[index]['name']),
                                content: Text(snapshot.data?.docs[index]['description'] +
                                "\n" + snapshot.data?.docs[index]['price']),
                                actions: <Widget>[
                                 TextButton(
                                    child:  const Text("Add to Order"),
                                    onPressed: () {
                                      int count = 1;
                                      createOrderInfo.setter(snapshot.data?.docs[index].id as String, count);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child:  const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                );
              }
            })
    );
  }



}



