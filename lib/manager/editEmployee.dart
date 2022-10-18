import 'package:flutter/material.dart';
import 'Utility/MangerNavigationDrawer.dart';

class EditEmployee extends StatefulWidget {
  const EditEmployee({super.key});

  @override
  State<EditEmployee> createState() => _EditEmployee();
}



class _EditEmployee extends State<EditEmployee> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final preferredNameController = TextEditingController();
  @override
  Widget build(BuildContext context)=> Scaffold (
    drawer: const ManagerNavigationDrawer(),
    appBar: AppBar(
      title: const Text("Edit Employee"),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    ),
    body: Center (
      child: SingleChildScrollView (
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: firstNameController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "First Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: lastNameController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Last Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: preferredNameController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Preferred Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Email",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: pwController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: TextFormField(
                controller: confirmPwController,
                keyboardType: TextInputType.number,
                decoration:  const InputDecoration(
                    hintText: "Confirm password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
              ),
            ),



            Row (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150,50),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("update"),
                    onPressed: (){

                    }
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150,50),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("cancel"),
                    onPressed: (){
                      Navigator.pop(context);
                    }
                ),
              ],
            )
          ], //Children
        ),
      ),
    ),
  );




}
