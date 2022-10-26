import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
import 'package:restaurant_management_system/customer/showMenuItems.dart';
import 'package:restaurant_management_system/customer/viewOrder.dart';
import '../widgets/customMainButton.dart';
import '../widgets/customSubButton.dart';
import 'Models/createOrderInfo.dart';
import 'Utility/navigation.dart';


class Order extends StatefulWidget {
  String tableID, restName, restID;
  CreateOrderInfo createOrderInfo;
  Order({Key? key, required this.tableID, required this.restName, required this.restID, required this.createOrderInfo}) :super(key: key);

  @override
  State<Order> createState() => _Order(tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo);
}

class _Order extends State<Order> {
  CreateOrderInfo createOrderInfo;
  String tableID, restName, restID;
  _Order({Key? key, required this.tableID, required this.restName, required this.restID, required this.createOrderInfo});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: Text('Menu'),
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
        body: Center(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child:
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                          ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26.0),
                      child: Text(restName,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    ),
                    CustomSubButton(text: "APPETIZERS",
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ShowMenuItems(text: 'appetizer', tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo,)));
                        },
                    ),
                    CustomSubButton(text: "ENTREES",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ShowMenuItems(text: 'entree', tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo,)));
                      },
                    ),
                    CustomSubButton(text: "DESSERTS",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ShowMenuItems(text: 'dessert', tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));
                      },
                    ),
                    CustomSubButton(text: "DRINKS",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ShowMenuItems(text: 'drink', tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));
                      },
                    ),
                    CustomSubButton(text: "CONDIMENTS",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ShowMenuItems(text: 'condiment', tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));
                      },
                    ),
                    CustomSubButton(text: "UTENSILS",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ShowMenuItems(text: 'utensil', tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));

                      },
                    ),
                    CustomMainButton(text: "REQUEST WAITER",
                      onPressed: () {
                        if (restName != "") {
                          createOrderInfo.request('Request Waiter', tableID);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PlacedOrders(tableID: tableID)));
                        }
                        if (restName == "") {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Alert!'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text('Scan a QR Code first to access the menu! One will be provided by the restaurant you are at.'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        //SEND REQUEST FOR WAITER
                      },
                    ),
                    CustomMainButton(text: "REQUEST BILL",
                      onPressed: () async {
                        bool test = await checkBillRequested();
                        if( test == true){
                          print("this is true");
                        }
                        else{
                          print('bill requested');
                          createOrderInfo.billRequest('Request Bill', tableID);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  PlacedOrders(tableID: tableID)));
                          //REQUEST BILL FROM WAITER
                        }
                      },
                    ),



                  ], //Children
                )
    )
    );
  }

  Future<bool> checkBillRequested() async {
    bool texter = true;
    await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(
            (element) {
           texter = element['billRequested'];
        });
    return texter;
  }




}
