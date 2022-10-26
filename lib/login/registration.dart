import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/waiterHome.dart';
import 'package:restaurant_management_system/login/verify.dart';
import 'package:restaurant_management_system/manager/managerHome.dart';
import '../customer/customerHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //save for later use
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toggle_switch/toggle_switch.dart';


enum WidgetMarker {
  user, manager
}

final formKey = GlobalKey<FormState>();

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();

}
  class RegisterState extends State<Register> {
    @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("Registration"),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: RegistrationBody(),
        );
    }
}

class RegistrationBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegistrationBodyState();
}

class RegistrationBodyState extends State<RegistrationBody> {

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final firstNameController = TextEditingController();
  final confirmPwController = TextEditingController();
  final lastNameController = TextEditingController();
  final restPhoneController = TextEditingController();
  final managerPhoneController = TextEditingController();
  final resNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    restPhoneController.dispose();
    resNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    managerPhoneController.dispose();
    super.dispose();
  }

  WidgetMarker selectedWidgetMarker = WidgetMarker.user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Container(
                color: Colors.black38,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.user;
                          });
                        },
                        child: Text("Customer", style: TextStyle(color: (selectedWidgetMarker == WidgetMarker.user) ? Colors.black : Colors.black26),),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.manager;
                          });
                        },
                        child: Text("Manager", style: TextStyle(color: (selectedWidgetMarker == WidgetMarker.manager) ? Colors.black : Colors.black26),),
                      ),
                    ]
                ),
              ),
              Container(
                  child: getCustomContainer()
              )
            ]
        )
    );
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.user:
        return getUserContainer();
      case WidgetMarker.manager:
        return getManagerContainer();
    }
    return getUserContainer();
  }

  Widget getUserContainer() {
    return Form(
        key: formKey,
        child: SizedBox(
            width: 300.0,
        child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 18.0,
              children: [
                TextField(
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "First Name",
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Last Name",
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter valid email' : null,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail, color: Colors.black),
                  ),

                ),
                TextFormField(
                  controller: pwController,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                  value != null && value.length < 6
                      ? 'Password must be at least 6 characters' : null,
                ),
                TextField(
                  controller: confirmPwController,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
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
                      child: const Text("Register"),
                      onPressed: () async {
                        if (pwController.text.trim() ==
                            confirmPwController.text.trim()) {
                          await registrationChecker(emailController.text.trim(),
                              pwController.text.trim(),
                              firstNameController.text.trim(),
                              lastNameController.text.trim());
                        }
                        else {
                          print("That's incorrect");
                        }
                      },
                    )
                )
              ],
            )
        )
    )
    );
  }

  Widget getManagerContainer() {
    return Form(
      key: formKey,
      child: SizedBox(
        width: 300.0,
      child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: firstNameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "First Name",
                  prefixIcon: Icon(Icons.person, color: Colors.black),
                ),
              ),
              TextField(
                controller: lastNameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Last Name",
                  prefixIcon: Icon(Icons.person, color: Colors.black),
                ),
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter valid email' : null,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.mail, color: Colors.black),
                ),
              ),
              TextField(
                controller: managerPhoneController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(Icons.phone, color: Colors.black),
                ),
              ),
              TextFormField(
                controller: pwController,
                keyboardType: TextInputType.name,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                value != null && value.length < 6
                    ? 'Password must be at least 6 characters' : null,
              ),
              TextField(
                controller: confirmPwController,
                keyboardType: TextInputType.name,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                ),
              ),
              const SizedBox(height: 30,),
              Text("Restaurant Information"),
              TextField(
                controller: resNameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Restaurant Name",
                  prefixIcon: Icon(Icons.food_bank, color: Colors.black),
                ),
              ),
              TextField(
                controller: restPhoneController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(Icons.phone, color: Colors.black),
                ),
              ),
              TextField(
                controller: addressController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Street Address",
                  prefixIcon: Icon(Icons.home, color: Colors.black),
                ),
              ),
              TextField(
                controller: cityController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "City",
                  prefixIcon: Icon(Icons.home, color: Colors.black),
                ),
              ),
              TextField(
                controller: stateController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "State",
                  prefixIcon: Icon(Icons.home, color: Colors.black),
                ),
              ),
              TextField(
                controller: zipController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Zip Code",
                  prefixIcon: Icon(Icons.home, color: Colors.black),
                ),
              ),
              SizedBox(
                  width: double.infinity,
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
                    child: const Text("Register"),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('You are registering a manager account. Do you confirm?'),
                        content: const Text('Approval process will take 24 hours. Please check back after registering.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (pwController.text.trim() ==
                                  confirmPwController.text.trim()) {
                                await managerRegistrationChecker(
                                    emailController.text.trim(),
                                    pwController.text.trim(),
                                    firstNameController.text.trim(),
                                    lastNameController.text.trim(),
                                    managerPhoneController.text.trim(),
                                    resNameController.text.trim(),
                                    addressController.text.trim(),
                                    cityController.text.trim(),
                                    stateController.text.trim(),
                                    zipController.text.trim(),
                                    restPhoneController.text.trim()
                                );
                                 }
                              else {
                                print("That's incorrect");
                              }
                              Navigator.pop(context, 'Confirm');
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => ManagerHome()));

                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ],
          )
      ),
    ),
    );
  }
  //=====================================
//Adding email and password to database
//=====================================


  registrationChecker(String email, String password, String firstName,
      String lastName) async {
    //run dart pub add email_validator in terminal to add dependencies
    //validate e-mail

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);

      String userID = FirebaseAuth.instance.currentUser?.uid as String;


      newUserData(email, userID, firstName, lastName);
      return true;
    } //end of try block
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-exists') {
        return ('Email is being used on preexisting account');
      }
    } //end of catch block

  } // end of registrationChecker

//========================
//Creates new user document
//======================
  void newUserData(String email, String UID, String firstName,
      String lastName) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final DateTime now = DateTime.now();

    users
        .doc(UID)
        .set(
        {
          'email': email,
          'lName': lastName,
          'fName': firstName,
          'type': 'customer',
          'date': Timestamp.fromDate(now),
        }

    );

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CustomerHome()));
  } //end of newUserData

  managerRegistrationChecker(String email, String password,
      String firstName, String lastName, String phone, String restName,
      String address, String city, String state, String zip, String restPhone) async {
    //run dart pub add email_validator in terminal to add dependencies
    //validate e-mail
        print("this is good here");
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);

      String userID = FirebaseAuth.instance.currentUser?.uid as String;


      newManagerData(
          email,
          userID,
          firstName,
          lastName,
          phone,
          restName,
          address,
          city,
          state,
          zip,
      restPhone);
      return true;
    } //end of try block
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-exists') {
        return ('Email is being used on preexisting account');
      }
    } //end of catch block

  } //end of manager registration


  void newManagerData(String email, String UID, String firstName,
      String lastName, String phone, String restName,
      String address, String city, String state, String zip, String restPhone) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference rest = FirebaseFirestore.instance.collection('restaurants');
    final DateTime now = DateTime.now();
    print("this is good");
    users
        .doc(UID)
        .set(
        {
          'userID' : UID,
          'email': email,
          'lName': lastName,
          'fName': firstName,
          'type': 'manager',
          'phone' : phone,
          'date': Timestamp.fromDate(now),
          'isActive': false,
          'prefName' : '',
        }

    );

    rest
      .doc()
      .set({
      'phone' : restPhone,
      'restName': restName,
      'managerID' : UID,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zip,
      'isActive': true,
      'creationDate': Timestamp.fromDate(now),
      'openTimeWKend': '10:30 AM',
      'closeTimeWKend': '10:30 pm',
      'openTimeWKday': '8:30 AM',
      'closeTimeWKday': '8:00 PM'
    }
    );



  }
}






