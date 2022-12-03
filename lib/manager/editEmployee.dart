import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/manageEmployee.dart';
import '../widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
/*
This page is for editing employee information
 */
class EditEmployee extends StatefulWidget {
  final String eID;
  final String fName;
  final String lName;
  final String prefName;
  final String phone;

  const EditEmployee({super.key, required this.eID, required this.fName, required this.lName, required this.prefName, required this.phone});

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
  bool flag = false;

  @override
  void initState() {
    //set default text
    firstNameController.text = widget.fName;
    lastNameController.text = widget.lName;
    prefNameController.text = widget.prefName;
    phoneController.text = widget.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context)=> Scaffold (
    drawer: const ManagerNavigationDrawer(),
    appBar: AppBar(
      title: const Text("Edit Employee"),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    ),

    body: SingleChildScrollView (
      padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomBackButton(onPressed: () {
            Navigator.pop(context);
          }),

          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              controller: firstNameController,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (fName) =>
              fName != null && fName.trim().length > 20
                  ? 'First name must be between 1 to 20 characters' : null,
              decoration:  InputDecoration(
                  labelText: "First Name",
                  hintText: "First Name",
                  filled: true,
                  fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
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
              decoration: InputDecoration(
                  labelText: "Last Name",
                  hintText: "Last Name",
                  filled: true,
                  fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
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
              decoration:  InputDecoration(
                  labelText: "Preferred Name",
                  hintText: "Preferred Name",
                  filled: true,
                  fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
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
              decoration:  InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone (ex: 222-333-6776)",
                  filled: true,
                  fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
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
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("SAVE"),
                  onPressed: () async {
                    var status = validate(firstNameController.text.trim(), lastNameController.text.trim(), prefNameController.text.trim(), phoneController.text.trim());
                    if (status == true && flag == true){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('There is no information to update'),
                      ));
                    } else if (status == true && flag == false) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Could not save changes, please review input'),
                      ));
                    } else {
                      updateInfo(firstNameController.text.trim(), lastNameController.text.trim(), prefNameController.text.trim(), phoneController.text.trim());
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => ManageEmployee()
                          )
                      );
                    }
                  }
              ),
              //Cancel button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150,50),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black54,width: 2),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("CANCEL"),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              ),
            ],
          )
        ], //Children
      ),
    ),
  );

  //function to update corresponding document in db
  updateInfo(String fName, String lName, String prefName, String phone) async {
    var user = await FirebaseFirestore.instance.collection('users').doc(widget.eID).get();
    await user.reference.update({
      'fName': fName,
      'lName': lName,
      'prefName': prefName,
      'phone': phone,
    });
  }

  //validates form input and returns response
  bool validate(String fName, var lName, var prefName, var newPhone) {
    bool error = false;
    if (fName.length > 20 || fName == ""){
      error = true;
    } else if (lName.length > 20 || lName == ""){
      error = true;
    } else if (prefName.length > 20){
      error = true;
    } else if (newPhone != "" && !pattern.hasMatch(newPhone)){
      error = true;
    } else if (newPhone == ""){
      error = true;
    } else if (fName == widget.fName && lName == widget.lName &&
        prefName == widget.prefName && newPhone == widget.phone){
      error = true;
      flag = true;
    }
    return error;
  }

}
