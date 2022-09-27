import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Waiter/waiterHome.dart';
import '../patron/patronHome.dart';
import 'registration.dart';
import 'login.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();

}

  class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {

        }),
        title: const Text("MainScreen"),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.menu), onPressed: () {

          }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 80,width: 300,),

              child: ElevatedButton(
                  onPressed: () =>
                      redirect(),
                  child: const Text('Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0,right: 0,top: 20,bottom: 20),
              child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(height: 80,width: 300),
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Register()),
                      );
                    },
                    child: const Text('Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                ),
              ),
            ),

            ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 80,width: 300),
              child: ElevatedButton(
                  onPressed: (){
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Sign out previous user',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ),
            ),


          ],
        )


      ),
    );
  }

  redirect() async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    print(userID);

    if (userID == null){
      print('not logged in');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
    }

    String acctType = "";

    final docRef = FirebaseFirestore.instance.collection('users').doc(userID);
    await docRef.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          setState(() => acctType = data['type']);
          //print(data['type']);
        }
    );

    if (!mounted) return;
    if (acctType == 'customer'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> PatronHome()));
    } else if (acctType == 'waiter') {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> WaiterHome()));
    } else if (acctType == 'manager'){
      print('manager');
    } else if (acctType == 'admin'){
      print('admin');
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
    }

  }
}