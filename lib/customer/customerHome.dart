import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/Models/restaurantInfo.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customSubButton.dart';
import 'order.dart';
import 'qrScanner.dart';
import 'package:restaurant_management_system/customer/Utility/navigation.dart';
import 'package:restaurant_management_system/customer/requests.dart';

class CustomerHome extends StatelessWidget {

String restName = "";
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
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => Order()));
                    }
                ),
                CustomSubButton(text: "CURRENT ORDER",
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => Order()));
                  }
                ),

              ], //Children
            )
            );
          }
      ),
    );
  }


    Future<String> getRestaurantId() async {

    String tableID ="";
    String restID = "";

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
          restID = data['restaurantID'].toString().trim();
        });

    final docRef3 = FirebaseFirestore.instance.collection('restaurants').doc(restID);
    await docRef3.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          restName =  data['restaurantName'].toString().trim();
        });
    if (restName != '') {
      restName = "to " + restName;
    }


    return "";
    }


}