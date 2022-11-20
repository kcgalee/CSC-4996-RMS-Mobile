import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import '../widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'manageRestaurant.dart';

class EditRestaurant extends StatefulWidget {
  final String restID;
  final String rName;
  final String rAddress;
  final String rCity;
  final String rState;
  final String rZip;
  final String rEmail;
  final String rPhone;
  final String rOpenWKday;
  final String rCloseWKday;
  final String rOpenWKend;
  final String rCloseWKend;

  const EditRestaurant({Key? key, required this.restID, required this.rName, required this.rAddress, required this.rCity,
    required this.rState, required this.rZip, required this.rEmail, required this.rPhone,
    required this.rOpenWKday, required this.rCloseWKday, required this.rOpenWKend, required this.rCloseWKend}) : super(key: key);



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
  bool openTimeChanged2 = false;
  bool closeTimeChanged2 = false;
  bool flag = false;

  TimeOfDay openTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay closeTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay openTime2 = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay closeTime2 = TimeOfDay(hour: 10, minute: 30);

  String oTOD = "10:30 AM";
  String cTOD = "10:30 PM";
  String oTOD2 = "10:30 AM";
  String cTOD2 = "10:30 PM";

  @override
  void initState() {
    //set default text
    restaurantNameController.text = widget.rName;
    addressController.text = widget.rAddress;
    cityController.text = widget.rCity;
    stateController.text = widget.rState;
    zipController.text = widget.rZip;
    emailController.text = widget.rEmail;
    phoneNumberController.text = widget.rPhone;
    if (widget.rOpenWKday != "") {
      //openTime = TimeOfDay(hour: int.parse(widget.rOpen.substring(0, widget.rOpen.indexOf(':'))), minute: int.parse(widget.rOpen.substring(widget.rOpen.indexOf(':')+1, widget.rOpen.indexOf(':')+3)));
      oTOD = widget.rOpenWKday;
    }
    if (widget.rCloseWKday != "") {
      //closeTime = TimeOfDay(hour: int.parse(widget.rClose.substring(0, widget.rClose.indexOf(':'))), minute: int.parse(widget.rClose.substring(widget.rClose.indexOf(':')+1, widget.rClose.indexOf(':')+3)));
      cTOD = widget.rCloseWKday;
    }
    if (widget.rOpenWKend != "") {
      //openTime = TimeOfDay(hour: int.parse(widget.rOpen.substring(0, widget.rOpen.indexOf(':'))), minute: int.parse(widget.rOpen.substring(widget.rOpen.indexOf(':')+1, widget.rOpen.indexOf(':')+3)));
      oTOD2 = widget.rOpenWKend;
    }
    if (widget.rCloseWKend != "") {
      //closeTime = TimeOfDay(hour: int.parse(widget.rClose.substring(0, widget.rClose.indexOf(':'))), minute: int.parse(widget.rClose.substring(widget.rClose.indexOf(':')+1, widget.rClose.indexOf(':')+3)));
      cTOD2 = widget.rCloseWKend;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Edit Restaurant"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
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
                rName != null && rName
                    .trim()
                    .length > 40
                    ? 'Name must be between 1 to 40 characters' : null,
                keyboardType: TextInputType.name,
                maxLines: 1,
                maxLength: 40,
                icon: const Icon(Icons.food_bank, color: Colors.black,),
            ),
            CustomTextForm(
                hintText: "Address",
                controller: addressController,
                validator: (rAddress) =>
                rAddress != null && rAddress
                    .trim()
                    .length > 100
                    ? 'Text must be between 1 to 100 characters' : null,
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 100,
                icon: const Icon(Icons.house)
            ),
            CustomTextForm(
                hintText: "City",
                controller: cityController,
                validator: (city) =>
                city != null && city
                    .trim()
                    .length > 40
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
            // Opening Time Weekday
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
                        oTOD = openTime.format(context).toString(),
                        openTimeChanged = true
                      });
                    },
                    child: Text('Opening', textAlign: TextAlign.center,),
                  ),

                  SizedBox(
                    child: Text(
                      oTOD,
                      style: TextStyle(fontSize: 20),
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
                      fixedSize: Size(120, 56),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: closeTime,
                      );

                      // if 'Cancel' => null
                      if (newTime == null) return;
                      //if 'OK' => TimeOfDay
                      setState(() =>
                      {
                        closeTime = newTime,
                        cTOD = closeTime.format(context).toString(),
                        closeTimeChanged = true
                      });
                    },
                    child: Text('Closing', textAlign: TextAlign.center,),
                  ),

                  SizedBox(
                    child: Text(
                      cTOD,
                      style: TextStyle(fontSize: 20),
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
                      fixedSize: Size(120, 56),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: openTime2,
                      );

                      // if 'Cancel' => null
                      if (newTime == null) return;
                      //if 'OK' => TimeOfDay
                      setState(() =>
                      {
                        openTime2 = newTime,
                        oTOD2 = openTime2.format(context).toString(),
                        openTimeChanged2 = true
                      });
                    },
                    child: Text('Opening', textAlign: TextAlign.center,),
                  ),

                  SizedBox(
                    child: Text(
                      oTOD2,
                      style: TextStyle(fontSize: 20),
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
                      fixedSize: Size(120, 56),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: closeTime2,
                      );

                      // if 'Cancel' => null
                      if (newTime == null) return;
                      //if 'OK' => TimeOfDay
                      setState(() =>
                      {
                        closeTime2 = newTime,
                        cTOD2 = closeTime2.format(context).toString(),
                        closeTimeChanged2 = true
                      });
                    },
                    child: Text('Closing', textAlign: TextAlign.center,),
                  ),

                  SizedBox(
                    child: Text(
                      cTOD2,
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
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("SAVE"),
                    onPressed: () async {
                      var res = await validate(
                          restaurantNameController.text.trim(),
                          addressController.text.trim(),
                          cityController.text.trim(),
                          stateController.text.trim(),
                          zipController.text.trim(),
                          emailController.text.trim(),
                          phoneNumberController.text.trim(),
                          openTimeChanged, closeTimeChanged,
                        openTimeChanged2, closeTimeChanged2);
                      if (flag == true){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Could not save changes, a restaurant already exists at that address'),
                        ));
                      } else if (res[0] == true && res[1] == false){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Could not save changes'),
                          ));
                      } else if (res[0] == false && res[1] == true){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('There is no information to update'),
                          ));
                      }
                      else {
                        if (restaurantNameController.text.trim() != "") {
                          await updateName(restaurantNameController.text.trim());
                        }
                        if (addressController.text.trim() != "") {
                          await updateAddress(addressController.text.trim());
                        }
                        if (cityController.text.trim() != "") {
                          await updateCity(cityController.text.trim());
                        }
                        if (stateController.text.trim() != "") {
                          await updateState(stateController.text.trim());
                        }
                        if (zipController.text.trim() != "") {
                          await updateZip(zipController.text.trim());
                        }
                        if (emailController.text.trim() != "") {
                          await updateEmail(emailController.text.trim());
                        }
                        if (phoneNumberController.text.trim() != "") {
                          await updatePhone(phoneNumberController.text.trim());
                        }

                        if (openTimeChanged != false) {
                          await updateOpenTimeWKday(openTime);
                        }

                        if (closeTimeChanged != false) {
                          await updateCloseTimeWKday(closeTime);
                        }

                        if (openTimeChanged2 != false) {
                          await updateOpenTimeWKend(openTime2);
                        }

                        if (closeTimeChanged2 != false) {
                          await updateCloseTimeWKend(closeTime2);
                        }
                        Navigator.pop(context,
                            MaterialPageRoute(builder: (context) => ManageRestaurant()
                            )
                        );
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
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2,color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("CANCEL"),
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

  updateOpenTimeWKday(var oTime) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'openTimeWKday': oTOD
    });
  }

  updateCloseTimeWKday(var cTime) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'closeTimeWKday': cTOD
    });
  }

  updateOpenTimeWKend(var oTime) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'openTimeWKend': oTOD2
    });
  }

  updateCloseTimeWKend(var cTime) async {
    var user = await FirebaseFirestore.instance.collection('restaurants').doc(
        widget.restID).get();
    await user.reference.update({
      'closeTimeWKend': cTOD2
    });
  }



  validate(String rName, String rAddress, String rCity, String rState,
      String rZip, String rEmail, String rPhone, bool oChanged,
      bool cChanged, bool oChanged2, bool cChanged2) async {
    bool error = false;
    bool unchanged = false;
    if (rName.length > 40 || rName == "") {
      error = true;
    }
    if (rAddress.length > 100 || rAddress == "") {
      error = true;
    }
    if (rAddress != "" && (rAddress != widget.rAddress)) {
      await FirebaseFirestore.instance.collection('restaurants').get().then(
              (data) => {
            data.docs.forEach((element) {
              if (element['address'].toString().toUpperCase() == rAddress.toUpperCase()){
                error = true;
                flag = true;
              }
            })
          });
    }
    if (rCity.length > 40 || rCity == "") {
      error = true;
    }
    if ((rState != "" && !statePattern.hasMatch(rState)) || rState == "") {
      error = true;
    }
    if (rZip != "" && !zipPattern.hasMatch(rZip)) {
      error = true;
    }
    if (rEmail == '' || (rEmail != "" && !EmailValidator.validate(rEmail))) {
      error = true;
    }
    if (rPhone == '' || (rPhone != "" && !phonePattern.hasMatch(rPhone))) {
      error = true;
    }
    if (rName == widget.rName && rAddress == widget.rAddress
        && rCity == widget.rCity && rState == widget.rState
        && rZip == widget.rZip && rEmail == widget.rEmail
        && rPhone == widget.rPhone && oChanged == false && cChanged == false
        && oChanged2 == false && cChanged2 == false) {
      unchanged = true;
    }
    return [error, unchanged];
  }
}