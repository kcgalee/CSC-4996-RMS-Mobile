import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/patron/patronHome.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
} //class Verify Screen

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState(){
    user = auth.currentUser!;
    user.sendEmailVerification();
    
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text
          ("Verification email sent to ${user.email}, please verify." +
            "\nYou will be redirected to the home screen after verification."
          + "\nBe sure to check spam/junk folder."
            ),),
    );
  }


  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified){
      timer.cancel();
      Navigator.of(context).
      pushReplacement(MaterialPageRoute(builder: (context) =>PatronHome()));

    }
  }

}