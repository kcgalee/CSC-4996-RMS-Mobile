import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/allTables.dart';
import 'package:restaurant_management_system/Waiter/qrScannerWaiter.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';
import 'package:restaurant_management_system/Waiter/waiterRequest.dart';
import '../login/mainscreen.dart';
import '../widgets/customMainButton.dart';
import '../widgets/customSubButton.dart';
import 'Utility/waiterNavigation.dart';
import 'package:badges/badges.dart';

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
  Widget build(BuildContext context){
    return Scaffold(
        drawer: const WaiterNavigationDrawer(),
        appBar: AppBar(
          title: const Text("Waiter Home"),
          backgroundColor: const Color(0xff7678ff),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
            builder: (context, snapshot){
              if (!snapshot.hasData || (snapshot.data?.exists == false)) {
                return const Center(child:CircularProgressIndicator());
              } else {
                if (snapshot.data?['isActive'] == false){
                  return AlertDialog(
                    title: const Text('Account is Deactivated'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Your Waiter account has been deactivated by your manager.'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()
                              )
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return home();
                }
              }
            }
        ));
  }

  Widget home() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders')
            .where('waiterID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('status', isNotEqualTo: 'delivered').snapshots(),
        builder: (context, snapshot){
          if (snapshot.data?.docs.length == null){
            return const Center(child: CircularProgressIndicator());
          } else {
            //store active requests and generate text
            var activeReqNum = snapshot.data?.docs.length;
            //String reqText = '\nActive Requests: ${activeReqNum}';

            return FutureBuilder(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.data != 1){
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    //greeting text constructed here
                    greeting = 'Restaurant: $restName\nManager: $managerName';
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
                                        Row(
                                          children: [
                                            Text('Hello, $waiterName!', style: const TextStyle(fontSize: 30,color: Colors.white),),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Text(greeting , style: const TextStyle(fontSize: 20,color: Colors.white),),
                                          ],
                                        )
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
                              Badge(
                                  badgeContent: Text('$activeReqNum',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: CustomSubButton(
                                    text: 'CURRENT REQUESTS' ,
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => WaiterRequest(rName: restName, activity: 'active')));
                                    },
                                  )
                              ),
                              CustomSubButton(
                                text: 'PAST REQUESTS',
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => WaiterRequest(rName: restName, activity: 'inactive')));
                                },
                              ),
                            ], //Children
                          ),
                        ));
                  }
                });
          }}

    );
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
    return 1;
  }

}