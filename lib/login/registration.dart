import 'package:flutter/material.dart';
import '../patron/patronHome.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registration"),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextField(
                  keyboardType:TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "First and Last Name",
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                const TextField(
                  keyboardType:TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail, color: Colors.black),
                  ),
                ),
                const TextField(
                  keyboardType:TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                const TextField(
                  keyboardType:TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(child: Text("Register"),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PatronHome()),
                        );
                      },
                    )
                )
              ],
            )
        )
    );
  }
}
