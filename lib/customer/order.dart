import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/customerHome.dart';
import 'package:restaurant_management_system/customer/showMenuItems.dart';
import 'package:restaurant_management_system/customer/viewOrder.dart';
import '../widgets/customIconButton.dart';
import '../widgets/customSubButton.dart';
import 'Models/createOrderInfo.dart';
import 'Utility/navigation.dart';

/*
This page displays the seven menu options for the customer to choose from.
When a button is selected the category, priority of the category and restaurant
name will be sent to the showMenuItems page.
 */

class Order extends StatefulWidget {
  String tableID, restName, restID;
  CreateOrderInfo createOrderInfo;
  Order({Key? key, required this.tableID, required this.restName,
    required this.restID, required this.createOrderInfo}) :super(key: key);

  @override
  State<Order> createState() => _Order(tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo);
}

class _Order extends State<Order> {
  CreateOrderInfo createOrderInfo;
  String tableID, restName, restID;
  _Order({Key? key, required this.tableID, required this.restName, required this.restID, required this.createOrderInfo});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          drawer: const NavigationDrawer(),
          appBar: AppBar(
            title: const Text('Menu'),
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
                            builder: (context) => ViewOrder(createOrderInfo: createOrderInfo)));

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
            //===============================
            //Start of user doc stream builder
            //=================================

            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
                  builder: (context, userSnapshot) {

                //CHECK THAT SNAPSHOT HAS DATA
                if(userSnapshot.hasData) {


                  //===============================
                  //ERROR HANDLING FOR CLOSED TABLE
                  //===============================
                  if(userSnapshot.data!['tableID'] == ''){
                    return Column(
                      children:  [
                        const Text('Table Closed'),

                        CustomSubButton(text: "Back to Home Page",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CustomerHome()));
                          },
                        ),

                      ],

                    );
                  }

                  if (userSnapshot.data!['tableID'] != '') {
                    return Column(
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
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),),
                        ),
                        CustomIconButton(text: "APPETIZERS",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowMenuItems(text: 'appetizer',
                                          restName: restName,
                                          priority: 3,
                                          createOrderInfo: createOrderInfo,)));
                          }, iconInput: Icons.kebab_dining,
                        ),
                        CustomIconButton(text: "ENTREES",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowMenuItems(text: 'entree',
                                          restName: restName,
                                          priority: 3,
                                          createOrderInfo: createOrderInfo,)));
                          }, iconInput: Icons.lunch_dining,
                        ),
                        CustomIconButton(text: "DESSERTS",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowMenuItems(text: 'dessert',
                                            restName: restName,
                                            priority: 3,
                                            createOrderInfo: createOrderInfo)));
                          }, iconInput: Icons.icecream,
                        ),
                        CustomIconButton(text: "DRINKS",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowMenuItems(text: 'drink',
                                            restName: restName,
                                            priority: 2,
                                            createOrderInfo: createOrderInfo)));
                          }, iconInput: Icons.liquor,
                        ),
                        CustomIconButton(text: "CONDIMENTS",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowMenuItems(text: 'condiment',
                                            restName: restName,
                                            priority: 1,
                                            createOrderInfo: createOrderInfo)));
                          }, iconInput: Icons.battery_6_bar,
                        ),
                        CustomIconButton(text: "UTENSILS",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowMenuItems(text: 'utensil',
                                            restName: restName,
                                            priority: 1,
                                            createOrderInfo: createOrderInfo)));
                          }, iconInput: Icons.restaurant,
                        ),
                        CustomIconButton(text: "OTHER",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowMenuItems(text: 'other',
                                            restName: restName,
                                            priority: 1,
                                            createOrderInfo: createOrderInfo)));
                          }, iconInput: Icons.baby_changing_station,
                        ),
                        const SizedBox(height: 20),


                      ], //Children
                    );
                  }


                  //===========================
                  //table closed error handling
                  //===========================

                }


                  return const Text('no data to show');

            } )
                //======================
                //End of user doc stream builder
                //======================
      )

    );
  }






}
