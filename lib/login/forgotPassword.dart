import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
}
