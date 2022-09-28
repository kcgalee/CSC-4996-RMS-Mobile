import 'package:flutter/material.dart';
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
            ElevatedButton(
                onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login())),
                child: const Text('Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
            ),
            ElevatedButton(
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
          ],
        )
      ),
    );
  }
}