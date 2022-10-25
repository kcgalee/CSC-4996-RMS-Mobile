import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
import 'package:restaurant_management_system/customer/viewOrder.dart';

import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customSubButton.dart';
import 'tableStatus.dart';
import 'order.dart';
import 'qrScanner.dart';
import 'package:restaurant_management_system/customer/Utility/navigation.dart';

class CustomerHome extends StatelessWidget {

String restName = "";
String tableID ="";
String tableNum ="";
String restID = "";
String waiterName = "";
CreateOrderInfo createOrderInfo = CreateOrderInfo(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title:  const Text("Home"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: const <Widget>[],
      ),
      body: FutureBuilder (
          future: getRestaurantId(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  CustomMainButton(text: "QR SCAN",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const QRScanner()),
                      );
                    }
                  ),
                  const SizedBox(height: 30,),
                  const Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,),
                  ),

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
                  const SizedBox(height: 20,),
                  CustomMainButton(text: "MENU",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                        builder: (context) => Order(tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));
                      }
                  ),
                  CustomSubButton(text: "CURRENT ORDER",
                    onPressed: () {

                    }
                  ),
                  CustomSubButton(text: "TABLE STATUS",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const TableStatus()),
                        );
                      }
                  ),

                  CustomSubButton(text: "PLACED ORDERS",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PlacedOrders(tableID: tableID)),
                        );
                      }
                  ),

                ], //Children
              ),
            )
            );
          }
      ),
    );
  }


    Future<String> getRestaurantId() async {

      final docRef2 = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid.toString());
      await docRef2.get().then(
              (DocumentSnapshot doc){
            final data = doc.data() as Map<String, dynamic>;
            tableID = data['tableID'].toString().trim();
          });


    final docRef = FirebaseFirestore.instance.collection('tables').doc(tableID);
    await docRef.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          restID = data['restID'].toString().trim();
        });

    final docRef3 = FirebaseFirestore.instance.collection('restaurants').doc(restID);
    await docRef3.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          restName =  data['restName'].toString().trim();
        });
    print(restName);

    createOrderInfo.setter(tableID);
    return "";
    }


}