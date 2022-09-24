import 'package:flutter/material.dart';
import '../patron/patronHome.dart';
import 'package:restaurant_management_system/Waiter/waiterrequest.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
                const TextField(
                  keyboardType:TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "First and Last Name",
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
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(child: Text("Login"),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PatronHome()),
                        );
                      },
                    )
                ),

                SizedBox(// waiter page
                    width: double.infinity,
                    child:ElevatedButton(child: Text("Waiter Request Page"),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> WaiterRequest()),
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