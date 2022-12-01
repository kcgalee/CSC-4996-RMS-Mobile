import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/login/login.dart';
import 'package:restaurant_management_system/widgets/passwordTextField.dart';
import '../customer/customerHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/customTextForm.dart';


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
      body: const RegistrationBody(),
    );
  }
}

class RegistrationBody extends StatefulWidget {
  const RegistrationBody({super.key});

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
  final phonePattern = RegExp(r'^(1-)?\d{3}-\d{3}-\d{4}$');
  final zipPattern = RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');
  final statePattern = RegExp(
      r'^(A[KLRZ]|C[AOT]|D[CE]|FL|GA|HI|I[ADLN]|K[SY]|LA|M[ADEINOST]|N[CDEHJMVY]|O[HKR]|PA|RI|S[CD]|T[NX]|UT|V[AT]|W[AIVY])$');
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

  }

  Widget getUserContainer() {
    return Form(
        key: formKey,
        child: SizedBox(
            width: 300.0,
            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Wrap(
                    runSpacing: 0.0,
                    children: [
                      CustomTextForm(
                        hintText: "First Name",
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
                        icon: const Icon(Icons.person, color: Colors.black),
                        validator: null,
                        maxLines: 1,
                        maxLength: 30,
                      ),
                      CustomTextForm(
                        hintText: "Last Name",
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        icon: const Icon(Icons.person, color: Colors.black),
                        validator: null,
                        maxLines: 1,
                        maxLength: 30,
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

                      PasswordTextField(
                        controller: pwController,
                        keyboardType: TextInputType.name,
                        icon: const Icon(Icons.lock, color: Colors.black),
                        hintText: 'Password',
                        validator: (value) =>
                        value != null && value.length < 6
                            ? 'Password must be at least 6 characters' : null,
                        maxLength: 100,
                        maxLines: 1,
                      ),
                      PasswordTextField(
                        controller: confirmPwController,
                        keyboardType: TextInputType.name,
                        icon: const Icon(Icons.lock, color: Colors.black),
                        hintText: 'Confirm Password',
                        validator: null,
                        maxLength: 100,
                        maxLines: 1,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(330, 56),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.black38,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Register"),
                            onPressed: () async {
                              if (firstNameController.text.trim() == '' || lastNameController.text.trim() == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'All fields must be completed.'),
                                    ));
                              }
                              else {
                                if (pwController.text.trim() ==
                                    confirmPwController.text.trim()) {
                                  await registrationChecker(emailController.text
                                      .trim(),
                                      pwController.text.trim(),
                                      firstNameController.text.trim(),
                                      lastNameController.text.trim());
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Account could not be created. Passwords must match.'),
                                      ));
                                }
                              }
                            },
                          )
                      )
                    ],
                  )
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
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextForm(
                    hintText: "First Name",
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.person, color: Colors.black),
                    validator: null,
                    maxLines: 1,
                    maxLength: 30,
                  ),
                  CustomTextForm(
                    hintText: "Last Name",
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.person, color: Colors.black),
                    validator: null,
                    maxLines: 1,
                    maxLength: 30,
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
                      controller: managerPhoneController,
                      validator: (number) =>
                      number != null && !phonePattern.hasMatch(number)
                          ? 'Enter valid phone number (ex: 222-333-6776)' : null,
                      keyboardType: TextInputType.phone,
                      maxLines: 1,
                      maxLength: 12,
                      icon: const Icon(Icons.phone)
                  ),
                  PasswordTextField(
                    controller: pwController,
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.lock, color: Colors.black),
                    hintText: 'Password',
                    validator: (value) =>
                    value != null && value.length < 6
                        ? 'Password must be at least 6 characters' : null,
                    maxLength: 100,
                    maxLines: 1,
                  ),
                  PasswordTextField(
                    controller: confirmPwController,
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.lock, color: Colors.black),
                    hintText: 'Confirm Password',
                    validator: null,
                    maxLength: 100,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 30,),
                  const Text("Restaurant Information",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,),
                  ),
                  CustomTextForm(
                    hintText: "Restaurant Name",
                    controller: resNameController,
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.food_bank),
                    validator: null,
                    maxLines: 1,
                    maxLength: 40,
                  ),
                  CustomTextForm(
                      hintText: "Phone Number",
                      controller: restPhoneController,
                      validator: (number) =>
                      number != null && !phonePattern.hasMatch(number)
                          ? 'Enter valid phone number (ex: 222-333-6776)' : null,
                      keyboardType: TextInputType.phone,
                      maxLines: 1,
                      maxLength: 12,
                      icon: const Icon(Icons.phone)
                  ),
                  CustomTextForm(
                      hintText: "Address",
                      controller: addressController,
                      validator: (rAddress) =>
                      rAddress != null && rAddress.trim().length > 100
                          ? 'Name must be between 1 to 100 characters' : null,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 100,
                      icon: const Icon(Icons.home)
                  ),
                  CustomTextForm(
                      hintText: "City",
                      controller: cityController,
                      validator: (city) =>
                      city != null && city.trim().length > 40
                          ? 'City must be between 1 to 40 characters' : null,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 40,
                      icon: const Icon(Icons.location_city)
                  ),
                  CustomTextForm(
                      hintText: "State",
                      controller: stateController,
                      validator: (state) =>
                      state != null && !statePattern.hasMatch(state)
                          ? 'State invalid (format: MI)' : null,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 2,
                      icon: const Icon(Icons.location_city)
                  ),
                  CustomTextForm(
                      hintText: "Zip Code",
                      controller: zipController,
                      validator: (zip) =>
                      zip != null && !zipPattern.hasMatch(zip)
                          ? 'Zip code invalid (format: 12345 or 12345-2222)'
                          : null,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 10,
                      icon: const Icon(Icons.numbers)
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
                          onPressed: () {
                            //Checks to see if all fields are completed
                            if (firstNameController.text.trim() == '' || lastNameController.text.trim() == ''
                                || restPhoneController.text.trim() == '' || managerPhoneController.text.trim() == ''
                                || addressController.text.trim() == '' || zipController.text.trim() == ''
                                || resNameController.text.trim() == '' || stateController.text.trim() == '' ||
                                cityController.text.trim() == '') {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('All fields must be completed'),
                              ));
                            }
                            //checks to see password matches
                            else if (pwController.text.trim() !=
                                confirmPwController.text.trim()){
                              Navigator.pop(context, 'Confirm');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Account could not be created. Passwords must match.'),
                              ));
                            }
                            else {
                              showDialog<String>(
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
                                          if (await managerRegistrationChecker(
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
                                              restPhoneController.text.trim()) == true){
                                            Navigator.pop(context, 'Confirm');
                                            await FirebaseAuth.instance.signOut();
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (context) => Login()));
                                          }
                                        }
                                        else {
                                          Navigator.pop(context, 'Confirm');
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Account could not be created.'),
                                          ));
                                        }
                                      },
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                ),
                              );
                            }

                          }
                      )
                  ),
                  const SizedBox(height: 20)
                ],
              )
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
          'tableID' : '',
          'waiterID' : '',
          'restID' : ''
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
      'email' : email,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zip,
      'isActive': true,
      'creationDate': Timestamp.fromDate(now),
      'openTimeWKend': '10:30 AM',
      'closeTimeWKend': '10:30 pm',
      'openTimeWKday': '8:30 AM',
      'closeTimeWKday': '8:00 PM',
      'holidayHours': '',
    }
    );



  }
}