import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/editRestaurant.dart';



class ShowMenuItems extends StatefulWidget {
  final String text, tableID, restName, restID;

  ShowMenuItems({Key? key, required this.text, required this.tableID, required this.restName, required this.restID}) : super(key: key);

  @override
  State<ShowMenuItems> createState() => _ShowMenuItems(text: text, tableID: tableID, restName: restName, restID: restID );
}

class _ShowMenuItems extends State<ShowMenuItems> {

  List menuList = [];
  final String text, tableID, restName, restID;
  _ShowMenuItems({Key? key, required this.text,  required this.tableID, required this.restName, required this.restID});

  @override
  Widget build(BuildContext context) {
    print(text);
    print("." + restID + ".");
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
              print(restID);
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
                        },
                      );
                    }
                );
              }
            })
    );
  }

}