
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_management_system/manager/manageRestaurant.dart';



class AddRestaurant extends StatefulWidget {
  const AddRestaurant({super.key});

  @override
  State<AddRestaurant> createState() => _AddRestaurant();
}


class _AddRestaurant extends State<AddRestaurant> {
  final restaurantNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phonePattern = RegExp(r'^(1-)?\d{3}-\d{3}-\d{4}$');
  final zipPattern = RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');
  final statePattern = RegExp(
      r'^(A[KLRZ]|C[AOT]|D[CE]|FL|GA|HI|I[ADLN]|K[SY]|LA|M[ADEINOST]|N[CDEHJMVY]|O[HKR]|PA|RI|S[CD]|T[NX]|UT|V[AT]|W[AIVY])$');
  bool openTimeChanged = false;
  bool closeTimeChanged = false;
  bool flag = false;
  var uID = FirebaseAuth.instance.currentUser?.uid;

  TimeOfDay openTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay closeTime = TimeOfDay(hour: 10, minute: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Restaurant"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: restaurantNameController,
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (rName) =>
                    rName != null && rName.trim().length > 40
                        ? 'Name must be between 1 to 40 characters' : null,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.food_bank, color: Colors.black,),
                        hintText: "Restaurant Name",
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
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (rAddress) =>
                    rAddress != null && rAddress.trim().length > 100
                        ? 'Name must be between 1 to 100 characters' : null,
                    decoration: const InputDecoration(
                        hintText: "Address",
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
                    controller: cityController,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (city) =>
                    city != null && city.trim().length > 40
                        ? 'City must be between 1 to 40 characters' : null,
                    decoration: const InputDecoration(
                        hintText: "City",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),

                //uppercase when typing value
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: 150, height: 50,
                        child: TextFormField(
                          //example of setting max length. you can also hide the counter but i havent searched how
                          maxLength: 2,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: stateController,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (state) =>
                          state != null && !statePattern.hasMatch(state)
                              ? 'State invalid (format: MI)' : null,
                          decoration: const InputDecoration(
                              hintText: "State",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                              border: OutlineInputBorder()
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: 150, height: 50,
                        child: TextFormField(
                          controller: zipController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (zip) =>
                          zip != null && !zipPattern.hasMatch(zip)
                              ? 'Zip code invalid (format: 12345 or 12345-2222)'
                              : null,
                          decoration: const InputDecoration(
                              hintText: "Zip Code",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                              border: OutlineInputBorder()
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter valid email' : null,
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
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (number) =>
                    number != null && !phonePattern.hasMatch(number)
                        ? 'Enter valid phone number (ex: 222-333-6776)' : null,
                    decoration: const InputDecoration(
                        hintText: "Phone Number",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),

                //time picker
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 56),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                        onPressed: () async {
                          TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: openTime);
                          // if 'Cancel' => null
                          if (newTime == null) return;
                          //if 'OK' => TimeOfDay
                          setState(() =>
                          {
                            openTime = newTime,
                            openTimeChanged = true
                          });
                        },
                        child: Text('Opening Time', textAlign: TextAlign.center,),
                      ),

                      SizedBox(
                        child: Text(
                          openTime.format(context).toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 56),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                        onPressed: () async {
                          TimeOfDay? newTime2 = await showTimePicker(
                              context: context,
                              initialTime: closeTime);
                          // if 'Cancel' => null
                          if (newTime2 == null) return;
                          //if 'OK' => TimeOfDay
                          setState(() =>
                          {
                            closeTime = newTime2,
                            closeTimeChanged = true
                          });
                        },
                        child: Text('Closing Time', textAlign: TextAlign.center,),
                      ),

                      SizedBox(
                        child: Text(
                          closeTime.format(context).toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Add"),
                        onPressed: () async {
                          if (await validate(
                              restaurantNameController.text.trim(),
                              addressController.text.trim(),
                              cityController.text.trim(),
                              stateController.text.trim(),
                              zipController.text.trim(),
                              emailController.text.trim(),
                              phoneNumberController.text.trim(),
                              openTimeChanged,
                              closeTimeChanged) == true) {
                            if (flag == true){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Restaurant already exists at that address'),
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Failed to add restaurant, please review input'),
                              ));
                            }
                          } else {
                            createRestaurant(restaurantNameController.text.trim(),
                                addressController.text.trim(),
                                cityController.text.trim(),
                                stateController.text.trim(),
                                zipController.text.trim(),
                                emailController.text.trim(),
                                phoneNumberController.text.trim());
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ManageRestaurant()
                                )
                            );
                          }
                        }
                    ),
                  ], //Children
                ),
              ]),
        ));
  }

  createRestaurant(String rName, String rAddress, String rCity, String rState,
      String rZip, String rEmail, String rPhone) async{
    String oTime, cTime;
    if (openTime.minute >= 0 && openTime.minute < 10){
      oTime = '${openTime.hourOfPeriod}:0${openTime.minute} ${openTime.period.toString().substring(10,openTime.period.toString().length).toUpperCase()}';
    } else {
      oTime = '${openTime.hourOfPeriod}:${openTime.minute} ${openTime.period.toString().substring(10,openTime.period.toString().length).toUpperCase()}';
    }
    if (closeTime.minute >= 0 && closeTime.minute < 10){
      cTime = '${closeTime.hourOfPeriod}:0${closeTime.minute} ${closeTime.period.toString().substring(10,closeTime.period.toString().length).toUpperCase()}';
    } else {
      cTime = '${closeTime.hourOfPeriod}:${closeTime.minute} ${closeTime.period.toString().substring(10,closeTime.period.toString().length).toUpperCase()}';
    }

    await FirebaseFirestore.instance.collection('restaurants').doc().set({
      'address': rAddress,
      'restName': rName,
      'city': rCity,
      'state': rState,
      'zipcode': rZip,
      'email': rEmail,
      'phone': rPhone,
      'openTime': oTime,
      'closeTime': cTime,
      'managerID': uID,
      'creationDate': Timestamp.now(),
    });
  }

/*
  addItemtest() async {
    await FirebaseFirestore.instance.collection('restaurants').doc('WNl5JNPu8wob7Ws6C5mU').collection('menu').doc().set({
      'item': 'cheese',
    });
  }*/

  validate(String rName, String rAddress, String rCity, String rState,
      String rZip, String rEmail, String rPhone, bool oChanged,
      bool cChanged) async {
    bool error = false;
    if (rName == "" || rName.length > 40) {
      error = true;
    } else if (rAddress == "" || rAddress.length > 100) {
      error = true;
    } else if (rAddress != "") {
      await FirebaseFirestore.instance.collection('restaurants').get().then(
              (data) => {
            data.docs.forEach((element) {
              if (element['address'].toString().toUpperCase().compareTo(rAddress.toUpperCase()) == 0){
                error = true;
                flag = true;
              }
            })
          });
    } else if (rCity == "" || rCity.length > 40) {
      error = true;
    } else if (rState == "" || (rState != "" && !statePattern.hasMatch(rState))) {
      error = true;
    } else if (rZip == "" || (rZip != "" && !zipPattern.hasMatch(rZip))) {
      error = true;
    } else if (rEmail == "" || (rEmail != "" && !EmailValidator.validate(rEmail))) {
      error = true;
    } else if (rPhone == "" || (rPhone != "" && !phonePattern.hasMatch(rPhone))) {
      error = true;
    } else if (rName == "" && rAddress == "" && rCity == ""
        && rState == "" && rZip == "" && rEmail == ""
        && rPhone == "" && oChanged == false && cChanged == false) {
      error = true;
    }
    return error;
  }
}
