import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'qrScanner.dart';
import 'package:restaurant_management_system/customer/navigation.dart';
import 'package:restaurant_management_system/customer/requests.dart';

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
                  child: const Text('QR Scan',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ),
              Text("Welcome to"),
              Text("Insert Restaurant Name"),
              ElevatedButton(
                child: Text("MENU"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => Requests()));
                }),



            ], //Children
          )


      ),
    );
  }
}