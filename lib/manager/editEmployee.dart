import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'Utility/MangerNavigationDrawer.dart';

class EditEmployee extends StatefulWidget {
  final String eID;
  final String fName;
  final String lName;
  final String prefName;
  final String email;

  const EditEmployee({super.key, required this.eID, required this.fName, required this.lName, required this.prefName, required this.email});

  @override
  State<EditEmployee> createState() => _EditEmployee();
}



class _EditEmployee extends State<EditEmployee> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final prefNameController = TextEditingController();
  final phoneController = TextEditingController();
  final openingController = TextEditingController();
  final closingController = TextEditingController();
  final pattern = RegExp(r'^(1-)?\d{3}-\d{3}-\d{4}$');
  final nPattern = RegExp(r'^(0?[1-9]|1[0-2]):[0-5][0-9]$');

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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (fName) =>
                fName != null && fName.trim().length > 20
                    ? 'First name must be between 1 to 20 characters' : null,
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (lName) =>
                lName != null && lName.trim().length > 20
                    ? 'Last name must be between 1 to 20 characters' : null,
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
                controller: prefNameController,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (prefName) =>
                prefName != null && prefName.trim().length > 20
                    ? 'Preferred name must be between 1 to 20 characters' : null,
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
                controller: phoneController,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (number) =>
                number != null && !pattern.hasMatch(number)
                    ? 'Enter valid phone number (ex: 222-333-6776)' : null,
                decoration: const InputDecoration(
                    hintText: "Phone (ex: 222-333-6776)",
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
                      if (validate(firstNameController.text.trim(), lastNameController.text.trim(), prefNameController.text.trim(), phoneController.text.trim()) == true){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Could not update information, please review input'),
                        ));
                      } else {
                        if (firstNameController.text.trim() != ""){
                          updateFName(firstNameController.text.trim());
                        }
                        if (lastNameController.text.trim() != ""){
                          updateLName(lastNameController.text.trim());
                        }
                        if (prefNameController.text.trim() != ""){
                          updatePrefName(prefNameController.text.trim());
                        }
                        if (phoneController.text.trim() != ""){
                          updatePhone(phoneController.text.trim());
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Success, information has been updated.'),
                        ));
                      }
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

  updateFName(String fName) async {
    var user = await FirebaseFirestore.instance.collection('users').doc(widget.eID).get();
    await user.reference.update({
      'fName': fName
    });
    firstNameController.text = "";
  }

  updateLName(String lName) async {
    var user = await FirebaseFirestore.instance.collection('users').doc(widget.eID).get();
    await user.reference.update({
      'lName': lName
    });
    lastNameController.text = "";
  }

  updatePrefName(String prefName) async {
    var user = await FirebaseFirestore.instance.collection('users').doc(widget.eID).get();
    await user.reference.update({
      'prefName': prefName
    });
    prefNameController.text = "";
  }

  updatePhone(String phone) async {
    var user = await FirebaseFirestore.instance.collection('users').doc(widget.eID).get();
    await user.reference.update({
      'phone': phone
    });
    phoneController.text = "";
  }

  bool validate(String fName, var lName, var prefName, var newPhone) {
    bool error = false;
    if (fName.length > 20){
      error = true;
    } else if (lName.length > 20){
      error = true;
    } else if (prefName.length > 20){
      error = true;
    } else if (newPhone != "" && !pattern.hasMatch(newPhone)){
      error = true;
    } else if (fName == "" && lName == "" && prefName == "" && newPhone == ""){
      error = true;
    }
    return error;
  }

}
