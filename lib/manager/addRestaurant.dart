import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/manageRestaurant.dart';
import '../widgets/customBackButton.dart';
import '../widgets/customTextForm.dart';
import 'Utility/MangerNavigationDrawer.dart';

/*
Creates form for manager to add a restaurant
 */

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({super.key});

  @override
  State<AddRestaurant> createState() => _AddRestaurant();
}


class _AddRestaurant extends State<AddRestaurant> {
  final holidayHours = TextEditingController();
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
  bool flag = false;
  var uID = FirebaseAuth.instance.currentUser?.uid;

  TimeOfDay openTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay closeTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay openTime2 = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay closeTime2 = TimeOfDay(hour: 10, minute: 30);

  String oTime = "10:30 AM";
  String cTime = "10:30 PM";
  String oTime2 = "10:30 AM";
  String cTime2 = "10:30 PM";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffEBEBEB),
        drawer: const ManagerNavigationDrawer(),
        appBar: AppBar(
          title: const Text("Add Restaurant"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        //creates form fields for adding a restaurant
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomBackButton(onPressed: () {
                  Navigator.pop(context);
                }),
                CustomTextForm(
                    hintText: "Restaurant Name",
                    controller: restaurantNameController,
                    validator: (rName) =>
                    rName != null && rName.trim().length > 40
                        ? 'Name must be between 1 to 40 characters' : null,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    maxLength: 40,
                    icon: const Icon(Icons.food_bank)
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
                    controller: phoneNumberController,
                    validator: (number) =>
                    number != null && !phonePattern.hasMatch(number)
                        ? 'Enter valid phone number (ex: 222-333-6776)' : null,
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    maxLength: 12,
                    icon: const Icon(Icons.phone)
                ),

                Text('Weekday Hours',style: TextStyle(fontSize: 20)),
                Divider(thickness: 1,color: Colors.black),
                //time picker
                //Opening Time Weekday
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 56),
                          backgroundColor: Color(0xffEBEBEB),
                          foregroundColor: Colors.black54,
                          elevation: 5,
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
                            oTime = openTime.format(context).toString(),
                          });
                        },
                        child: const Text('Opening', textAlign: TextAlign.center,),
                      ),

                      SizedBox(
                        child: Text(
                          openTime.format(context).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),

               // Closing Time Weekday
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 56),
                          backgroundColor: const Color(0xffEBEBEB),
                          foregroundColor: Colors.black54,
                          elevation: 5,
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
                            cTime = closeTime.format(context).toString(),
                          });
                        },
                        child: const Text('Closing', textAlign: TextAlign.center,),
                      ),
                      SizedBox(
                        child: Text(
                          closeTime.format(context).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Text('Weekend Hours',style: TextStyle(fontSize: 20)),
                Divider(thickness: 1,color: Colors.black),
                //Weekend Opening time
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 56),
                          backgroundColor: const Color(0xffEBEBEB),
                          foregroundColor: Colors.black54,
                          elevation: 5,
                        ),
                        onPressed: () async {
                          TimeOfDay? newTime2 = await showTimePicker(
                              context: context,
                              initialTime: openTime2);
                          // if 'Cancel' => null
                          if (newTime2 == null) return;
                          //if 'OK' => TimeOfDay
                          setState(() =>
                          {
                            openTime2 = newTime2,
                            oTime2 = openTime2.format(context).toString(),
                          });
                        },
                        child: const Text('Opening', textAlign: TextAlign.center,),
                      ),

                      SizedBox(
                        child: Text(
                          openTime2.format(context).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                //Weekend Closing time
                Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 56),
                          backgroundColor: const Color(0xffEBEBEB),
                          foregroundColor: Colors.black54,
                          elevation: 5,
                        ),
                        onPressed: () async {
                          TimeOfDay? newTime2 = await showTimePicker(
                              context: context,
                              initialTime: closeTime2);
                          // if 'Cancel' => null
                          if (newTime2 == null) return;
                          //if 'OK' => TimeOfDay
                          setState(() =>
                          {
                            closeTime2 = newTime2,
                            cTime2 = closeTime2.format(context).toString(),
                          });
                        },
                        child: const Text('Closing', textAlign: TextAlign.center,),
                      ),
                      SizedBox(
                        child: Text(
                          closeTime2.format(context).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                //Holiday Hours input
                CustomTextForm(
                    hintText: 'Holiday Hours',
                    controller: holidayHours,
                    validator: (rAddress) =>
                    rAddress != null && rAddress.trim().length > 150
                        ? 'Name must be between 1 to 150 characters' : null,
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                    maxLength: 150,
                    icon: Icon(Icons.access_time_filled_outlined),
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
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Add"),
                        onPressed: () async {
                          //validates form input and returns response
                          bool validation = await validate(
                              restaurantNameController.text.trim(),
                              addressController.text.trim(),
                              cityController.text.trim(),
                              stateController.text.trim(),
                              zipController.text.trim(),
                              emailController.text.trim(),
                              phoneNumberController.text.trim());
                          if (validation) {
                            if (flag == true){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                    'Restaurant already exists at that address'),
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Failed to add restaurant, please review input'),
                              ));
                            }
                          } else {
                            //creates restaurant if validation passes
                            createRestaurant(restaurantNameController.text.trim(),
                                addressController.text.trim(),
                                cityController.text.trim(),
                                stateController.text.trim(),
                                zipController.text.trim(),
                                emailController.text.trim(),
                                phoneNumberController.text.trim(),
                                holidayHours.text.trim());
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

  //function to create a restaurant, submits information to firebase as a doc in the restaurants collection
  createRestaurant(String rName, String rAddress, String rCity, String rState,
      String rZip, String rEmail, String rPhone, String hHours) async{
    await FirebaseFirestore.instance.collection('restaurants').doc().set({
      'address': rAddress,
      'restName': rName,
      'city': rCity,
      'state': rState,
      'zipcode': rZip,
      'email': rEmail,
      'phone': rPhone,
      'openTimeWKday': oTime,
      'openTimeWKend': oTime2,
      'closeTimeWKday': cTime,
      'closeTimeWKend': cTime2,
      'managerID': uID,
      'isActive': true,
      'creationDate': Timestamp.now(),
      'holidayHours': hHours,
    });
  }

  //validates the form input and returns response indicating the presence of error
  validate(String rName, String rAddress, String rCity, String rState,
      String rZip, String rEmail, String rPhone) async {
    bool error = false;
    if (rName == "" || rName.length > 40) {
      error = true;
    }
    if (rAddress == "" || rAddress.length > 100) {
      error = true;
    }
    if (rAddress != "") {
      await FirebaseFirestore.instance.collection('restaurants').get().then(
              (data) => {
            data.docs.forEach((element) {
              if (element['address'].toString().toUpperCase().compareTo(rAddress.toUpperCase()) == 0){
                error = true;
                flag = true;
              }
            })
          });
    }
    if (rCity == "" || rCity.length > 40) {
      error = true;
    }
    if (rState == "" || (rState != "" && !statePattern.hasMatch(rState))) {
      error = true;
    }
    if (rZip == "" || (rZip != "" && !zipPattern.hasMatch(rZip))) {
      error = true;
    }
    if (rEmail == "" || (rEmail != "" && !EmailValidator.validate(rEmail))) {
      error = true;
    }

    if (rPhone == '' || (rPhone != "" && !phonePattern.hasMatch(rPhone))) {
      error = true;
    }

    if (rName == "" && rAddress == "" && rCity == ""
        && rState == "" && rZip == "" && rEmail == ""
        && rPhone == "") {
      error = true;
    }
    return error;
  }
}
