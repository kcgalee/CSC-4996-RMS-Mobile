import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/login/mainscreen.dart';

class ManagerHome extends StatefulWidget {


  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Waiter Home"),
    ),
    body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        ElevatedButton(
            child: Text("Sign out"),
            onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen()));
                }),
    ]
    )
    )
    );
  }
}
