import 'package:flutter/material.dart';
import 'package:restaurant_management_system/login/registrationProcedure.dart';
import '../patron/patronHome.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();

}
  class RegisterState extends State<Register> {

    final emailController = TextEditingController();
    final pwController = TextEditingController();
    final nameController = TextEditingController();
    final confirmPwController = TextEditingController();

@override
void dispose() {
  emailController.dispose();
  pwController.dispose();
  confirmPwController.dispose();
  nameController.dispose();
  super.dispose();
}


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
                 TextField(
                  controller: nameController,
                  keyboardType:TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "First and Last Name",
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                ),
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
                  decoration: const InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: confirmPwController,
                  keyboardType:TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(child: Text("Register"),
                      onPressed: () async {
                        if (pwController.text.trim() == confirmPwController.text.trim()){
                           if (await registrationChecker(emailController.text.trim(),
                                pwController.text.trim(), nameController.text.trim())) {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PatronHome()),
                            );

                            }//end of embedded if statement

                              }//end of if statement
                        else{
                          print("That's incorrect");
                        }

                      },
                    )
                )
              ],
            )
        )
    );
  }
}
