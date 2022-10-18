
import 'package:flutter/material.dart';


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

  TimeOfDay openTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay closeTime = TimeOfDay(hour: 10, minute: 30);
  @override
  void dispose() {
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }


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
                decoration: const InputDecoration(
                    hintText: "City",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    border: OutlineInputBorder()
                ),
              ),
            ),

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
                      fixedSize: Size(120,56),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: openTime);
                    // if 'Cancle' => null
                    if (newTime == null) return;
                    //if 'OK' => TimeOfDay
                    setState(() => openTime = newTime);
                  },
                    child: Text('Opening time',textAlign: TextAlign.center,),
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
                      fixedSize: Size(120,56),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: closeTime);
                      // if 'Cancle' => null
                      if (newTime == null) return;
                      //if 'OK' => TimeOfDay
                      setState(() => closeTime = newTime);
                    },
                    child: Text('Closing Time',textAlign: TextAlign.center,),
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
                  onPressed: () {

                  }

              ),
            )
          ], //Children
        ),
      ),
    );
  }
}
