import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/manageEmployee.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import 'Utility/MangerNavigationDrawer.dart';

class AddEmployee extends StatefulWidget {
  final String text;
  final String rName;
  AddEmployee({Key? key, required this.text, required this.rName}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployee(restID: text);
}


class _AddEmployee extends State<AddEmployee> {
  final String restID;
  _AddEmployee({Key? key, required this.restID});

  String managerID = FirebaseAuth.instance.currentUser?.uid as String;
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final preferredNameController = TextEditingController();
  final phonePattern = RegExp(r'^(1-)?\d{3}-\d{3}-\d{4}$');

  @override
  Widget build(BuildContext context)=> Scaffold (
    drawer: const ManagerNavigationDrawer(),
    appBar: AppBar(
      title: const Text("Add Employee"),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    ),
    body: SingleChildScrollView (
      padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child:
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
            ),
          ),
          Text(widget.rName,style: const TextStyle(fontSize: 20),),
          const SizedBox(height: 20,),

          CustomTextForm(
              hintText: "First Name",
              controller: firstNameController,
              validator: (fName) =>
              fName != null && fName.trim().length > 20
                  ? 'Name must be between 1 to 20 characters' : null,
              keyboardType: TextInputType.name,
              maxLines: 1,
              maxLength: 20,
              icon: const Icon(Icons.person)
          ),

          CustomTextForm(
              hintText: "Last Name",
              controller: lastNameController,
              validator: (lName) =>
              lName != null && lName.trim().length > 20
                  ? 'Name must be between 1 to 20 characters' : null,
              keyboardType: TextInputType.name,
              maxLines: 1,
              maxLength: 20,
              icon: const Icon(Icons.person)
          ),

          CustomTextForm(
              hintText: "Preferred Name",
              controller: preferredNameController,
              validator: (pName) =>
              pName != null && pName.trim().length > 20
                  ? 'Name must be between 1 to 20 characters' : null,
              keyboardType: TextInputType.name,
              maxLines: 1,
              maxLength: 20,
              icon: const Icon(Icons.person)
          ),

          CustomTextForm(
              hintText: "Email",
              controller: emailController,
              validator: (email) =>
              email != null && !EmailValidator.validate(email)
                  ? 'Enter valid email' : null,
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              maxLength: 40,
              icon: const Icon(Icons.email)
          ),

          CustomTextForm(
              hintText: "Phone Number",
              controller: phoneController,
              validator: (number) =>
              number != null && !phonePattern.hasMatch(number)
                  ? 'Enter valid phone number (ex: 222-333-6776)' : null,
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 12,
              icon: const Icon(Icons.phone)
          ),

          CustomTextForm(
              hintText: "Password",
              controller: pwController,
              validator: (value) =>
              value != null && value.length < 6
                  ? 'Password must be at least 6 characters' : null,
              keyboardType: TextInputType.text,
              maxLines: 1,
              maxLength: 40,
              icon: const Icon(Icons.password)
          ),

          CustomTextForm(
              hintText:  "Confirm password",
              controller: confirmPwController,
              validator: (value) =>
              value != pwController.text.trim()
                  ? 'Passwords must match' : null,
              keyboardType: TextInputType.text,
              maxLines: 1,
              maxLength: 40,
              icon: const Icon(Icons.password)
          ),

          CustomMainButton(
              text: "Add",
              onPressed: () async {
                await registrationChecker(emailController.text.trim(), pwController.text.trim(),
                    firstNameController.text.trim(), lastNameController.text.trim(),
                    preferredNameController.text.trim(), managerID, phoneController.text.trim());

              }
          )
        ], //Children
      ),
    ),
  );


  registrationChecker(String email, String password, String firstName,
      String lastName, String preferredName, String managerID, String phone) async {
    //run dart pub add email_validator in terminal to add dependencies
    //validate e-mail
      FirebaseApp app = await Firebase.initializeApp(
        name: "Secondary", options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      String? userID = userCredential.user?.uid.toString();
      newUserData(email, userID.toString().trim(), firstName, lastName, preferredName, managerID, phone);

    } //end of try block
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-exists') {
        await app.delete();
        return ('Email is being used on preexisting account');
      }
    } //end of catch block
    await app.delete();
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ManageEmployee()));
  }

  void newUserData(String email, String UID, String firstName,
      String lastName, String preferredName, String managerID, String phone) {
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
          'phone' : phone,
          'isActive': true,
        }


    );


  }

}
