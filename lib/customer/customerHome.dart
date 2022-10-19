import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';

import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customSubButton.dart';
import 'order.dart';
import 'qrScanner.dart';
import 'package:restaurant_management_system/customer/Utility/navigation.dart';
import 'package:restaurant_management_system/customer/requests.dart';

class CustomerHome extends StatelessWidget {

String restName = "";
String tableID ="";
String restID = "";
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                    textAlign: TextAlign.left,
                  ),

                    Text(
                      restName,
                      textAlign: TextAlign.left,
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