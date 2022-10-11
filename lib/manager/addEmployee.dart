import 'package:flutter/material.dart';
import 'Utility/MangerNavigationDrawer.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployee();
}


class _AddEmployee extends State<AddEmployee> {
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
      title: const Text("Add Employee"),
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



            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(330, 56),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Add"),
                onPressed: (){

                }

              ),
            )
          ], //Children
        ),
      ),
    ),
  );




}
