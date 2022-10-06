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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black45,
                  minimumSize: const Size(300,80),
                ),
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
              const SizedBox(height: 30,),
              const Text(
                "Welcome to",
                textAlign: TextAlign.left,
              ),
              const Text(
                "Insert Restaurant Menu",
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black45,
                  minimumSize: const Size(300,80),
                ),
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