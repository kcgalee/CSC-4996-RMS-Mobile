import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/dialog_box.dart';
import 'package:restaurant_management_system/Waiter/viewTable.dart';

class EditRestaurant extends StatefulWidget {
  final String restID;

  const EditRestaurant({Key? key, required this.restID}) : super(key: key);



  @override
  State<EditRestaurant> createState() => _EditRestaurant();
}

class _EditRestaurant extends State<EditRestaurant> {
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

  TimeOfDay openTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay closeTime = TimeOfDay(hour: 10, minute: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Restaurant"),
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
                rName != null && rName
                    .trim()
                    .length > 40
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
                rAddress != null && rAddress
                    .trim()
                    .length > 100
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
                city != null && city
                    .trim()
                    .length > 40
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
                      TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: closeTime);
                      // if 'Cancel' => null
                      if (newTime == null) return;
                      //if 'OK' => TimeOfDay
                      setState(() =>
                      {
                        closeTime = newTime,
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
                    child: const Text("update"),
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
                                'Update failed, a restaurant already exists at that address'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Update failed, please review input'),
                          ));
                        }

                      } else {
                        if (restaurantNameController.text.trim() != "") {
                          updateName(restaurantNameController.text.trim());
                        }
                        if (addressController.text.trim() != "") {
                          updateAddress(addressController.text.trim());
                        }
                        if (cityController.text.trim() != "") {
                          updateCity(cityController.text.trim());
                        }
                        if (stateController.text.trim() != "") {
                          updateState(stateController.text.trim());
                        }
                        if (zipController.text.trim() != "") {
                          updateZip(zipController.text.trim());
                        }
                        if (emailController.text.trim() != "") {
                          updateEmail(emailController.text.trim());
                        }
                        if (phoneNumberController.text.trim() != "") {
                          updatePhone(phoneNumberController.text.trim());
                        }

                        if (openTimeChanged != false) {
                          updateOpenTime(openTime);
                        }

                        if (closeTimeChanged != false) {
                          updateCloseTime(closeTime);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Success, information has been updated.'),
                        ));
                      }
                    }
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
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
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ],
            )
          ], //Children
        ),
      ),
    );
  }

  updateName(String rName) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'restName': rName
    });
  }

  updateAddress(String rAddress) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'address': rAddress
    });
  }

  updateCity(String rCity) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'city': rCity
    });
  }

  updateState(String rState) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'state': rState
    });
  }

  updateZip(String rZip) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'zipcode': rZip
    });
  }

  updateEmail(String rEmail) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'email': rEmail
    });
  }

  updatePhone(String rPhone) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'phone': rPhone
    });
  }

  updateOpenTime(var oTime) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'openTime': oTime.toString()
    });
  }

  updateCloseTime(var cTime) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'closeTime': cTime.toString()
    });
  }

  validate(String rName, String rAddress, String rCity, String rState,
      String rZip, String rEmail, String rPhone, bool oChanged,
      bool cChanged) async {
    bool error = false;
    if (rName.length > 40) {
      error = true;
    } else if (rAddress.length > 100) {
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
    } else if (rCity.length > 40) {
      error = true;
    } else if (rState != "" && !statePattern.hasMatch(rState)) {
      error = true;
    } else if (rZip != "" && !zipPattern.hasMatch(rZip)) {
      error = true;
    } else if (rEmail != "" && !EmailValidator.validate(rEmail)) {
      error = true;
    } else if (rPhone != "" && !phonePattern.hasMatch(rPhone)) {
      error = true;
    } else if (rName == "" && rAddress == "" && rCity == ""
        && rState == "" && rZip == "" && rEmail == ""
        && rPhone == "" && oChanged == false && cChanged == false) {
      error = true;
    }
    return error;
  }
}