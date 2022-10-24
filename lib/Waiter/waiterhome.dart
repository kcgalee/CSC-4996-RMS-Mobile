import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/allTables.dart';
import 'package:restaurant_management_system/Waiter/qrScannerWaiter.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';
import 'package:restaurant_management_system/Waiter/waiterRequest.dart';
import '../widgets/customSubButton.dart';
import 'Utility/waiterNavigation.dart';

class WaiterHome extends StatefulWidget {
  const WaiterHome({Key? key}) : super(key: key);

  @override
  State<WaiterHome> createState() => _WaiterHomeState();
}

class _WaiterHomeState extends State<WaiterHome> {
  String waiterName = "";
  String restName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const WaiterNavigationDrawer(),
        appBar: AppBar(
          title: const Text("Waiter Home"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: FutureBuilder(
          future: getName(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(26),
                    child: Text(waiterName,
                    style: const TextStyle(fontSize: 30,),),
                  ),
                  /*
                  CustomSubButton(
                    text: 'CLOCK IN',
                    onPressed: () {  },
                  ),

                  CustomSubButton(
                    text: 'CLOCK OUT',
                    onPressed: () {  },
                  ),*/

                  CustomSubButton(
                    text: 'ASSIGNED TABLES',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WaiterTables()),
                      );
                    },

                  ),
                  CustomSubButton(
                    text: 'VIEW ALL TABLES',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AllTables()));
                    },
                  ),
                  CustomSubButton(
                    text: 'REQUESTS',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WaiterRequest(rName: restName)));
                    },
                  ),

                  CustomSubButton(
                    text: 'SCAN QR CODE',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const QRScannerWaiter()));
                    },
                  ),

                ], //Children
              ),
            ));
            },
        ));
  }

  Future getName() async {
    var rID;
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
              if (element['prefName'] == ""){
                waiterName = element['fName'];
              } else {
                waiterName = element['prefName'];
              }
              rID = element['restaurantID'];
            }
          );
    await FirebaseFirestore.instance.collection('restaurants').doc(rID).get().then(
            (element) {
              restName = element['restaurantName'];
            }
            );
    }

}
