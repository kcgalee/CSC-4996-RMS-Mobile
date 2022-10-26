import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/allTables.dart';
import 'package:restaurant_management_system/Waiter/qrScannerWaiter.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';
import 'package:restaurant_management_system/Waiter/waiterRequest.dart';
import '../widgets/customMainButton.dart';
import '../widgets/customSubButton.dart';
import 'Utility/waiterNavigation.dart';

class WaiterHome extends StatefulWidget {
  const WaiterHome({Key? key}) : super(key: key);

  @override
  State<WaiterHome> createState() => _WaiterHomeState();
}

class _WaiterHomeState extends State<WaiterHome> {
  String waiterName = "";
  String managerName = "";
  String restName = "";
  String greeting = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const WaiterNavigationDrawer(),
        appBar: AppBar(
          title: const Text("Waiter Home"),
          backgroundColor: const Color(0xff7678ff),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: getName(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(40),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Color(0xff7678ff),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(5.0, 5.0),
                                blurRadius: 10.0,
                                spreadRadius: 1.0,
                              )
                            ],
                          ),
                          child:
                          Column(
                              children: [
                                CustomMainButton(
                                  text: 'SCAN QR CODE',
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => const QRScannerWaiter()));
                                  },
                                ),
                                const SizedBox(height: 20,),
                                Text(greeting,
                                  style: const TextStyle(fontSize: 30,color: Colors.white),),
                              ]
                          )
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
                      const SizedBox(height: 60,),

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

                    ], //Children
                  ),
                ));
          },
        ));
  }

  Future getName() async {
    var rID;
    var managerID;
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
          if (element['prefName'] == ""){
            waiterName = element['fName'];
          } else {
            waiterName = element['prefName'];
          }
          rID = element['restID'];
        }
    );
    await FirebaseFirestore.instance.collection('restaurants').doc(rID).get().then(
            (element) {
          restName = element['restName'];
          managerID = element['managerID'];
        }
    );
    await FirebaseFirestore.instance.collection('users').doc(managerID).get().then(
            (element) {
          if (element['prefName'] == ''){
            managerName = element['fName'];
          } else {
            managerName = element['prefName'];
          }
        });
    //greeting text constructed here
    greeting = 'Hello, ${waiterName}!\n${restName}\nManager: ${managerName}';
  }

}
