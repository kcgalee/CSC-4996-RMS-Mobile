import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customSubButton.dart';
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
      backgroundColor: const Color(0xffe8f3fc),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/RMS_logo.png'),
              const SizedBox(height: 30,),
              CustomMainButton(text: "Login",
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login())),
              ),
              CustomSubButton(text: "Register",
                onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Register()),
                );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}