import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'login.dart';

class PWReset extends StatefulWidget {
  const PWReset({Key? key}) : super(key: key);

  @override
  State<PWReset> createState() => _PWReset();
}

class _PWReset extends State<PWReset> {
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
                        text: "Reset Password",
                        onPressed: () {
                          resetPW(emailController.text.trim());
                        }
                    )
                  ],
                )
            )
        )
    );
  }

  resetPW(String email) async{
    if (!EmailValidator.validate(emailController.text.trim())){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You must enter a valid email'),
      ));
    } else {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }


  }

}
