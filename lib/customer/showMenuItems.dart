import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/viewOrder.dart';
import 'package:restaurant_management_system/manager/editRestaurant.dart';
import 'package:counter/counter.dart';
import 'Models/createOrderInfo.dart';
import 'package:restaurant_management_system/widgets/customSubButton.dart';


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
        appBar: AppBar(
          title: Text(text.toUpperCase()),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                TextButton(
                  onPressed: (){
                        Navigator.push(context,
                        MaterialPageRoute(
                     builder: (context) => ViewOrder(tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.
            collection('restaurants/$restID/menu')
                .where('category', isEqualTo: text)
                .snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
              return Center(child: Text("No items to display."),);
            } else {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return  Padding(
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
                                  children: [
                                    Text(snapshot.data?.docs[index]['itemName'] ?? ''),
                                    Spacer(),
                                    Text(snapshot.data?.docs[index]['price'] ?? ''),
                                  ],
                                ),


                                onTap: () {
                                  int? count = 0;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column (
                                          mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          AlertDialog(
                                            insetPadding: EdgeInsets.zero,
                                            title: Text(snapshot.data?.docs[index]['itemName']),

                                            content: Builder(
                                              builder: (context) {
                                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                var height = MediaQuery.of(context).size.height;
                                                var width = MediaQuery.of(context).size.width;

                                                return Container(
                                                  height: height - 600,
                                                  width: width - 400,
                                                  child: Text(snapshot.data?.docs[index]['description'] +
                                                "\n" + snapshot.data?.docs[index]['price']),
                                                );
                                              },
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child:  const Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              Counter(
                                                min: 1,
                                                max: 10,
                                                bound: 1,
                                                step: 1,
                                                onValueChanged: (value) {
                                                  count = value as int?;
                                                },
                                              ),
                                              TextButton(
                                                child:  const Text("Add to Order"),
                                                onPressed: () {
                                                      count == null ? count = 1 : count = count?.toInt();
                                                 createOrderInfo.orderSetter(snapshot.data?.docs[index].id as String, count!, snapshot.data?.docs[index]['itemName'], snapshot.data?.docs[index]['price']);
                                                  Navigator.of(context).pop();
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ViewOrder(tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));

                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );

                                    },
                                  );
                                },
                              )
                          )
                      );

                    }
                );
              }
            })
    );
  }



}



