import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/managerHome.dart';
import 'package:restaurant_management_system/waiter/waiterHome.dart';
import '../patron/patronDashboard.dart';
import '../patron/patronHome.dart';

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
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType:TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: pwController,
                  keyboardType:TextInputType.name,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(child: Text("Login"),
                      onPressed: () =>
                          redirect()
                  ),
                )
              ],
            )
        )
    );
  }

  logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: pwController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //error codes returned by function, found from firebase documentation
      if (e.code == 'user-not-found') {
        //display user not found widget here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Account does not exist with that Email!'),
        ));
        return ('user not found');
      } else if (e.code == 'wrong-password') {
        //display invalid/incorrect password widget here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Incorrect password, please try again.'),
        ));
        return ('wrong pw');
      }
    }
  }

  redirect() async {
    final message = await logIn();
    if (message == null) {
      final userID = fAuth.currentUser?.uid;
      print(userID);

      String acctType = "";
      String tableID = "";

      final docRef = FirebaseFirestore.instance.collection('users').doc(userID);
      await docRef.get().then(
              (DocumentSnapshot doc){
            final data = doc.data() as Map<String, dynamic>;
            setState(() => acctType = data['type']);
            setState(() {
              tableID = data['tableID'];
            });
          }
      );

      if (!mounted) return;
      if (acctType == 'customer'){
        if (tableID == ""){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PatronHome()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PatronDashboard()));
        }
      } else if (acctType == 'waiter') {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> WaiterHome()));
      } else if (acctType == 'manager'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ManagerHome()));
      } else {
        print('admin');
        FirebaseAuth.instance.signOut();
      }
    } else {
      print(message);
    }
  }
}