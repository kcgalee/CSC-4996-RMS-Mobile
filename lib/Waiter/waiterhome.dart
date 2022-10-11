import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/qrScannerWaiter.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';
import 'package:restaurant_management_system/Waiter/waiterRequest.dart';
import '../login/mainscreen.dart';
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        fixedSize: const Size(330, 56),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        side: const BorderSide(width: 2, color: Colors.black38,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      child: const Text('CLOCK IN',),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        fixedSize: const Size(330, 56),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        side: const BorderSide(width: 2, color: Colors.black38,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      child: const Text('CLOCK OUT',),

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(width: 2, color: Colors.black38,),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WaiterTables()),
                          );
                        },
                        child: const Text('ASSIGNED TABLES',),

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
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
                        side: const BorderSide(width: 2, color: Colors.black38,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => WaiterRequest(rName: restName)));
                      },
                      child: const Text("REQUESTS"),
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
                      side: const BorderSide(width: 2, color: Colors.black38,),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const QRScannerWaiter()));
                    },
                    child: const Text("SCAN QR CODE"),
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
