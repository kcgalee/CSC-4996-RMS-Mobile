import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'patronDashboard.dart';
import '../login/mainscreen.dart';
import 'qrScanner.dart';
import '../navigation.dart';

class PatronHome extends StatelessWidget {
  const PatronHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(

        title: const Text("Patron Home")
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
                  child: const Text("Sign out"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  }),
              ElevatedButton(
                  child: const Text("Customer Dashboard"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const PatronDashboard()));
                  }),



            ], //Children
          )


      ),
    );
  }
}