import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //save for later use
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:email_validator/email_validator.dart";

void registration(String email, String password) async {
  //run dart pub add email_validator in terminal to add dependencies
  //validate e-mail
  if (!EmailValidator.validate(email)) {
    print("Email not valid");
    //send message that email is not valid
  }
  else {
    if(password == null || password.length < 6) {
      print("Password must be at least 6 characters");
    }

    else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email, password: password);

        String userID = FirebaseAuth.instance.currentUser?.uid as String;
        newUserData(email, userID);
      } //end of try block
      on FirebaseAuthException catch (e) {
        print("WOAHHHH");

        Utils.showSnackBar(e.message);
      } //end of catch block
    }
  }//end of else statement


} // end of function block

void newUserData (String email, String UID) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  users
      .doc(UID)
      .set(
      {'email' : email,
        'name' : email,
        'type' : 3}
  );


}


class Utils {

  static showSnackBar(String? text){
    final messengerKey = GlobalKey<ScaffoldMessengerState>();
    //add scaffoldMessengerKey: Utils.messengerKey, to sign up widget

    if (text == null) return;
    final snackbar = SnackBar(content: Text(text), backgroundColor: Colors.red,);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

}