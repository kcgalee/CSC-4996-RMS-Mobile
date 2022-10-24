import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Text(restName,
                        style: const TextStyle(fontSize: 25,),),
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
                        createOrderInfo.request('Request Waiter');
                        //SEND REQUEST FOR WAITER
                      },
                    ),
                    CustomMainButton(text: "REQUEST BILL",
                      onPressed: () {
                        createOrderInfo.request('Request Bill');
                        //REQUEST BILL FROM WAITER
                      },
                    ),
                  ], //Children
                )
    )
    );
  }




}
