import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/showMenuItems.dart';
import 'Utility/navigation.dart';


class Order extends StatefulWidget {
  String tableID, restName, restID;
  Order({Key? key, required this.tableID, required this.restName, required this.restID}) :super(key: key);

  @override
  State<Order> createState() => _Order(tableID: tableID, restName: restName, restID: restID);
}

class _Order extends State<Order> {

  String tableID, restName, restID;
  _Order({Key? key, required this.tableID, required this.restName, required this.restID});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Text(restName,
                        style: const TextStyle(fontSize: 25,),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => ShowMenuItems(text: 'appetizer', tableID: tableID, restName: restName, restID: restID,)));
                        },
                        child: const Text('APPETIZERS',),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ShowMenuItems(text: 'entree', tableID: tableID, restName: restName, restID: restID,)));

                        },
                        child: const Text('ENTREES',),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ShowMenuItems(text: 'dessert', tableID: tableID, restName: restName, restID: restID,)));

                        },
                        child: const Text('DESSERTS',),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ShowMenuItems(text: 'drink', tableID: tableID, restName: restName, restID: restID,)));

                        },
                        child: const Text("DRINKS"),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ShowMenuItems(text: 'condiment', tableID: tableID, restName: restName, restID: restID,)));

                        },
                        child: const Text("CONDIMENTS"),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        fixedSize: const Size(330, 56),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        side: const BorderSide(
                          color: Colors.black38,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ShowMenuItems(text: 'utensil', tableID: tableID, restName: restName, restID: restID,)));

                      },
                      child: const Text("UTENSILS"),
                    ),
                    ElevatedButton(
                        child: const Text("REQUEST WAITER"),
                        onPressed: () {
                          //TODO
                          //SEND REQUEST FOR WAITER
                        }),

                    ElevatedButton(
                        child: const Text("REQUEST BILL"),
                        onPressed: () {
                          //TODO
                          //REQUEST BILL FROM WAITER
                        }),
                  ], //Children
                )
    )
    );
  }




}
