import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login/mainscreen.dart';
import 'qrScanner.dart';
import 'package:restaurant_management_system/customer/customerDashboard.dart';
import 'package:restaurant_management_system/customer/navigation.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(

        title: const Text("Customer Home"),
        actions: <Widget>[],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const QRScanner()),
                    );
                  },
                  child: const Text('QR Scanner',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ),
              ElevatedButton(
                child: Text("Dashboard"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => CustomerDashboard()));
                }),



            ], //Children
          )


      ),
    );
  }
}