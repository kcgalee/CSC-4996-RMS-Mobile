import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/patron/patronDashboard.dart';
import '../patron/patronHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //save for later use
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'registration.dart';

final formKey = GlobalKey<FormState>();

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();

}
  class RegisterState extends State<Register> {

    final emailController = TextEditingController();
    final pwController = TextEditingController();
    final firstNameController = TextEditingController();
    final confirmPwController = TextEditingController();
    final lastNameController = TextEditingController();

@override
void dispose() {
  emailController.dispose();
  pwController.dispose();
  confirmPwController.dispose();
  firstNameController.dispose();
  lastNameController.dispose();

  super.dispose();
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registration"),
        ),
        body: Center(
          child: Form(
          key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 TextField(
                  controller: firstNameController,
                  keyboardType:TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "First Name",
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: lastNameController,
                  keyboardType:TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Last Name",
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                 TextFormField(
                   controller: emailController,
                  keyboardType:TextInputType.name,
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                   validator: (email) =>
                   email != null && !EmailValidator.validate(email)
                       ? 'Enter valid email' : null,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail, color: Colors.black),
                    ),

                ),
                 TextFormField(
                   controller: pwController,
                  keyboardType:TextInputType.name,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                   validator: (value) => value != null && value.length < 6
                   ? 'Password must be at least 6 characters' : null,
                ),
                TextField(
                  controller: confirmPwController,
                  keyboardType:TextInputType.name,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(child: const Text("Register"),
                      onPressed: () async {
                        if (pwController.text.trim() == confirmPwController.text.trim()){
                           await registrationChecker(emailController.text.trim(),
                                pwController.text.trim(),
                               firstNameController.text.trim(), lastNameController.text.trim());
                        }
                        else{
                          print("That's incorrect");
                        }
                        },
                    )
                )
              ],
            )
        )
        )
    );
  }


//=====================================
//Adding email and password to database
//=====================================


    registrationChecker(String email, String password, String firstName, String lastName) async {
      //run dart pub add email_validator in terminal to add dependencies
      //validate e-mail

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email, password: password);

        String userID = FirebaseAuth.instance.currentUser?.uid as String;
        
        newUserData(email, userID, firstName, lastName);
        return true;
      } //end of try block
      on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-exists') {
          return ('Email is being used on preexisting account');
        }
      } //end of catch block

    } // end of registrationChecker

//========================
//Creates new user document
//======================
    void newUserData (String email, String UID, String firstName, String lastName) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      final DateTime now = DateTime.now();

      users
          .doc(UID)
          .set(
          {
            'email' : email,
            'lName' : lastName,
            'fName' : firstName,
            'type' : 'customer',
            'date' : Timestamp.fromDate(now),
          }


      );

      Navigator.push(context, MaterialPageRoute(builder: (context)=> PatronHome()));

    } //end of newUserData


}






