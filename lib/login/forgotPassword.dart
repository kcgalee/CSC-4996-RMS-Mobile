import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'resetPassword.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter valid email' : null,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                      ),
                    ),
                    CustomMainButton(
                        text: "Send Password Reset Link",
                        onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('A unique password reset link has been sent to your email.'),
                          content: const Text('Please follow the instructions in the email to reset your password.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Confirm'),
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomMainButton(
                        text: "temp: reset pw page",
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ResetPassword()),
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
