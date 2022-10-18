import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Forgot Password"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Center(
            child: SizedBox(
                width: 300.0,
                child: Wrap(
                  runSpacing: 18.0,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "New Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                      ),

                    ),
                    CustomMainButton(
                        text: "Reset Password",
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const Login()),
                          );
                        }
                    )
                  ],
                )
            )
        )
    );
  }

  resetPW(String email) async{
    if (!EmailValidator.validate(email)){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You must enter a valid email'),
      ));
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Account does not exist for this email'),
          ));
        }
      }
    }
  }

}
