import 'package:flutter/material.dart';
import 'login.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

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
        child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()),
              );
            },
            child: const Text('Login',
              style: TextStyle(
                color: Colors.white,
              ),
            )
        ),
      ),
    );
  }

}