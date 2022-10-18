import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/manageEmployee.dart';
import 'Utility/MangerNavigationDrawer.dart';

class AddEmployee extends StatefulWidget {
  final String text;
  AddEmployee({Key? key, required this.text}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployee(restID: text);
}


class _AddEmployee extends State<AddEmployee> {
  final String restID;
  _AddEmployee({Key? key, required this.restID});

  String managerID = FirebaseAuth.instance.currentUser?.uid as String;
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
                keyboardType: TextInputType.name,
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
                keyboardType: TextInputType.name,
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
                keyboardType: TextInputType.name,
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
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter valid email' : null,
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: pwController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                value != null && value.length < 6
                    ? 'Password must be at least 6 characters' : null,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: TextFormField(
                controller: confirmPwController,
                keyboardType: TextInputType.name,
                decoration:  const InputDecoration(
                  hintText: "Confirm password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()

                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                value != pwController.text.trim()
                    ? 'Passwords must match' : null,
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
                onPressed: () async {
                   await registrationChecker(emailController.text.trim(), pwController.text.trim(),
                        firstNameController.text.trim(), lastNameController.text.trim(),
                        preferredNameController.text.trim(), managerID);

                }

              ),
            )
          ], //Children
        ),
      ),
    ),
  );


  registrationChecker(String email, String password, String firstName,
      String lastName, String preferredName, String managerID) async {
    //run dart pub add email_validator in terminal to add dependencies
    //validate e-mail

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);

      String userID = FirebaseAuth.instance.currentUser?.uid as String;


      newUserData(email, userID, firstName, lastName, preferredName, managerID);
      return true;
    } //end of try block
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-exists') {
        return ('Email is being used on preexisting account');
      }
    } //end of catch block

  }

  void newUserData(String email, String UID, String firstName,
      String lastName, String preferredName, String managerID) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final DateTime now = DateTime.now();

    users
        .doc(UID)
        .set(
        {
          'email': email,
          'lName': lastName,
          'fName': firstName,
          'prefName' : preferredName,
          'type': 'waiter',
          'restID' : restID,
          'date': Timestamp.fromDate(now),
          'managerID' : managerID,
        }


    );

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ManageEmployee()));
  }

}
