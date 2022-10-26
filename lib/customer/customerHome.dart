
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';
import 'package:restaurant_management_system/customer/placedOrders.dart';
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
        title: const Text('Home'),
        backgroundColor: const Color(0xff76bcff),
        foregroundColor: Colors.black,
        elevation: 0,

      ),
      body: FutureBuilder (
          future: getRestaurantId(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Color(0xff76bcff),
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
                          //const SizedBox(height: 20,),
                          CustomMainButton(text: "QR SCAN",
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const QRScanner()),
                              );
                            }
                          ),
                          const SizedBox(height: 20,),

                         if(tableID != '')
                         StreamBuilder(
                              stream: FirebaseFirestore.instance.
                              collection('tables').doc(tableID)
                                  .snapshots(),
                              builder: (context, snapshot) {
                    if(snapshot.data!['currentCapacity'] == 0) {
                      deleteRestInfo();
                    }


                      if(snapshot.data!['currentCapacity'] != 0) {
                             return Column(
                            children: [
                              Row(
                              children:  [
                                Text(
                                  snapshot.data!['restName'] ?? 'Welcome',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                                ),
                              ],
                            ),
                              Row(
                                children:  [
                                  const Text(
                                    'Table ' ,
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data!['tableNum']?.toString() ?? "Please scan the QR code at your table once seated.",
                                    style: const TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                              if (snapshot.data!['waiterName'] != '')
                              Row(
                                children:  [
                                   const Text(
                                    'Waiter ',
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data!['waiterName'] ?? '',
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),

                            ]
                          );
                           } else{
                             return Column(
                               children: [
                             Row(
                             children:  const [
                             Text(
                              "Welcome",
                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                                   ),
                                ]
                             ),

                                 Row(
                                   children: const [
                                     Text(
                                       "Please scan the QR code at your table once seated.",
                                       style: TextStyle(fontSize: 13, color: Colors.white),
                                     ),
                                   ],
                                 ),

                                ]
                             );
                           }
                          }//builder

      ),

                          if(tableNum == '')
                          Row(
                            children:  const [
                              Text(
                                "Welcome",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                              ),

                            ],
                          ),

                          if(tableNum == '')
                          Row(
                            children: const [
                              Text(
                                "Please scan the QR code at your table once seated.",
                                style: TextStyle(fontSize: 13, color: Colors.white),
                              ),
                            ],
                          ),
                          //const SizedBox(height: 40,),
                        ],
                      ),
                  ),
                  const SizedBox(height: 60,),
                  CustomMainButton(text: "MENU",
                      onPressed: () {
                        if (restName != "") {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => Order(tableID: tableID, restName: restName, restID: restID, createOrderInfo: createOrderInfo)));
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

                      }
                  ),
                  CustomSubButton(text: "CURRENT ORDER",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PlacedOrders(tableID: tableID)),
                        );
                      }
                  ),
                  CustomSubButton(text: "TABLE STATUS",
                      onPressed: () {
                        if (restName != "") {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>  TableStatus(createOrderInfo: createOrderInfo, tableID: tableID, tableNum: tableNum, waiterName: waiterName)));
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

    print(restID);

    final docRef3 = FirebaseFirestore.instance.collection('restaurants').doc(restID);
    await docRef3.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          restName =  data['restName'].toString().trim();
        });
      await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(
              (element) {
            tableNum = element['tableNum'].toString();
          });

      await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(
              (element) {
            waiterName = element['waiterName'];
          });

    createOrderInfo.setter(tableID);
    return "";
    }

  deleteRestInfo(){
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
      'tableID' : ''
    });
  }//deleteRI

}