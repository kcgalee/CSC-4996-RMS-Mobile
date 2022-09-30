import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/qrScannerWaiter.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';
import 'package:restaurant_management_system/Waiter/waiterRequest.dart';

import '../login/mainscreen.dart';

class WaiterHome extends StatefulWidget {
  const WaiterHome({Key? key}) : super(key: key);

  @override
  State<WaiterHome> createState() => _WaiterHomeState();
}

class _WaiterHomeState extends State<WaiterHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Waiter Home"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Center(
          child: Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Text("Waiter Name",
                  style: TextStyle(fontSize: 30,),),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: ElevatedButton(
                    child: const Text('CLOCK OUT',),
                    style: ElevatedButton.styleFrom(

                      fixedSize: Size(330, 56),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: BorderSide(
                        color: Colors.black38,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: ElevatedButton(
                    child: const Text('CLOCK IN',),
                    style: ElevatedButton.styleFrom(

                      fixedSize: Size(330, 56),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: BorderSide(
                        color: Colors.black38,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: ElevatedButton(
                      child: const Text('ASSIGNED TABLES',),
                      style: ElevatedButton.styleFrom(

                        fixedSize: Size(330, 56),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        side: BorderSide(
                          color: Colors.black38,
                        ),
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

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: ElevatedButton(
                    child: Text("REQUESTS"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      fixedSize: Size(330, 56),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: BorderSide(
                        color: Colors.black38,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WaiterRequest()));
                    },
                  ),
                ),

                ElevatedButton(
                  child: Text("SCAN QR CODE"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    fixedSize: Size(330, 56),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black54,
                    side: BorderSide(
                      color: Colors.black38,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => QRScannerWaiter()));
                  },
                ),
                ElevatedButton(
                    child: Text("sign out"),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainScreen()));
                    }),
              ], //Children
            ),
          ),
        ));
  }
}
