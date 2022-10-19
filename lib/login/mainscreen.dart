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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
              padding: const EdgeInsets.only(bottom: 26,left: 26,right: 26),
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
                    onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login())),
                    child: const Text('Login',)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 26,left: 26,right: 26),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(330, 56),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: BorderSide(
                        color: Colors.black38,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Register()),
                      );
                    },
                    child: const Text('Register',)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}