import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/login/forgotPassword.dart';
import 'package:restaurant_management_system/manager/managerHome.dart';
import 'package:restaurant_management_system/waiter/waiterHome.dart';
import '../customer/customerHome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final fAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('users').get();


  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
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
                    )
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const ForgotPassword()),
                      );
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(330, 56),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.black38,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Login"),

                      onPressed: () async {
                       int status = validate(emailController.text.trim(), pwController.text.trim());
                       if (status == 3){
                          await redirect(emailController.text.trim(), pwController.text.trim());
                       }
                      }
                  ),
                )
              ],
            )
          )
        )
    );
  }

  int validate(String email, String pw){
    if (email == "" &&  pw == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You must enter a valid email & password'),
      ));
      return 0;
    } else if (email == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You must enter a valid email'),
      ));
      return 1;
    } else if (pw == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You must enter a valid password'),
      ));
      return 2;
    } else {
      return 3;
    }
  }

  logIn(String email, String pw) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pw,
      );
    } on FirebaseAuthException catch (e) {
      //error codes returned by function, found from firebase documentation
      if (e.code == 'user-not-found') {
        //display user not found widget here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Account does not exist!'),
        ));
        return ('user not found');
      } else if (e.code == 'wrong-password') {
        //display invalid/incorrect password widget here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Either the password or email is incorrect, please try again.'),
        ));
        return ('wrong pw');
      }
    }
  }

  redirect(String email, String pw) async {
    final message = await logIn(email, pw);
    if (message == null) {
      final userID = fAuth.currentUser?.uid;
      String acctType = "";

      final docRef = FirebaseFirestore.instance.collection('users').doc(userID);
      await docRef.get().then(
              (DocumentSnapshot doc){
            final data = doc.data() as Map<String, dynamic>;
            setState(() => acctType = data['type']);
          }
      );

      if (!mounted) return;
      if (acctType == 'customer'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerHome()));
      } else if (acctType == 'waiter') {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> WaiterHome()));
      } else if (acctType == 'manager'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ManagerHome()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Admin accounts are not supported in RMS-mobile.'),
        ));
        FirebaseAuth.instance.signOut();
      }
    } else {
      print(message);
    }
  }
}

