import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/waiterHome.dart';
import 'package:restaurant_management_system/login/login.dart';
import 'package:restaurant_management_system/manager/managerHome.dart';
import 'package:restaurant_management_system/customer/customerHome.dart';
import '../login/mainscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }*/
    String acctType = "";
    bool isLogged = false;

    Future getAT() async {
      final userID = FirebaseAuth.instance.currentUser?.uid;
      print(userID);
      if (userID != null){
        isLogged = true;
      }

      final docRef = FirebaseFirestore.instance.collection('users').doc(userID);
      await docRef.get().then(
              (DocumentSnapshot doc){
            final data = doc.data() as Map<String, dynamic>;
            acctType = data['type'];
          }
      );
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Management System',
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.0,
          fontSizeDelta: 1.5,
          bodyColor: Colors.black,
        ),
      ),
      home: FutureBuilder(
        future: getAT(),
        builder: (context, snapshot) {
          print(isLogged);
          if (isLogged == false){
            return MainScreen();
          } else {
            if (acctType == 'customer'){
              return CustomerHome();
            } else if (acctType == 'waiter'){
              return WaiterHome();
            } else if (acctType == 'manager'){
              //should be manager home
              return ManagerHome();
            } else {
              return Login();
            }
          }
        },
      ),
    );
  }
}
