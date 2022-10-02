import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Waiter/waiterRequest.dart';
import '../login/mainscreen.dart';
import 'qrScanner.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Patron Home"),
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
                  child: Text("Sign out"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => MainScreen()));
                  }),



            ], //Children
          )


      ),
    );
  }
}