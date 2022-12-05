import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import '../widgets/customBackButton.dart';
import '../widgets/customCheckBox.dart';
import 'Utility/MangerNavigationDrawer.dart';

/*
This page is for adding a new menu items to a restaurant
 */

class AddItem extends StatefulWidget {
  String restaurantID;
  String category;
  final String rName;

  AddItem({Key? key, required this.restaurantID, required this.category, required this.rName}) : super(key: key);
  @override
  State<AddItem> createState() => _AddItemState();
}


class _AddItemState extends State<AddItem> {
  final itemNameController = TextEditingController();
  final priceController = TextEditingController();
  final itemDescController = TextEditingController();
  final pricePattern = RegExp(r'^(\$)?(([1-9]\d{0,2}(\,\d{3})*)|([1-9]\d*)|(0))(\.\d{2})?$');
  bool flag = false;
  bool isVegan = false;
  bool isVegetarian = false;
  bool isGlutenFree = false;
  bool isNuts = false;
  bool isAllRestaurants = false;
  bool isKosher = false;
  bool isHalal = false;
  bool isPescatarian = false;
  bool isLactoseFree = false;
  File? image;
  String title = '';

  @override
  void initState() {
    //set default text
    priceController.text = '0.00';
    title = '${widget.rName}: ${widget.category}s';
    super.initState();
  }
  //Image picker function
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e){
      print('Failed to pick image: $e');
    }
  }


  //function to show respective add item page for the category of menu item chosen
  @override
  Widget build(BuildContext context) {
    if (widget.category == 'utensil' || widget.category == 'other'){
      return specialCase();
    } else {
      return others();
    }
  }

  //add item page for items of category "Utensil" or "Other"
  Widget specialCase()=> Scaffold (
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: Text("Add Item"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
        child: Column(
            children: [
              //Back button
              CustomBackButton(onPressed: () {
                Navigator.pop(context);
              }),
              Padding(
                padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
                child: Text(title,style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
              ),

              CustomTextForm(
                  hintText: "Item Name",
                  controller: itemNameController,
                  keyboardType: TextInputType.text,
                  validator: (name) =>
                  name != null && name.trim().length > 50
                      ? 'Name must be between 1 to 50 characters' : null,
                  maxLines: 1,
                  maxLength: 50,
                  icon: const Icon(Icons.fastfood, color: Colors.black)
              ),

              CustomTextForm(
                  hintText: "Item Description",
                  controller: itemDescController,
                  keyboardType: TextInputType.text,
                  validator: (desc) =>
                  desc != null && desc.trim().length > 150
                      ? 'Description cannot exceed 150 characters' : null,
                  maxLines: 4,
                  maxLength: 150,
                  icon: const Icon(Icons.description, color: Colors.black)
              ),

              //image display place
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: image != null ? Image.file(
                  image!,
                  height: 160,width: 160,
                  fit: BoxFit.cover,
                )
                    : Icon(Icons.image,size: 160,), //image placeholder
              ),

              // button to pick image for menu item
              CustomMainButton(
                  text: 'SELECT IMAGE',
                  onPressed: (){
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight:Radius.circular(24))
                        ),
                        backgroundColor: Colors.black,
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //pick image from gallery button
                            ListTile(
                              leading: const Icon(Icons.image,color: Colors.white,),
                              title: const Text('Gallery',style: TextStyle(color: Colors.white),),
                              onTap: () => pickImage(ImageSource.gallery),
                            ),
                            Divider(color: Colors.white,thickness: 1,indent: 10,endIndent: 10,),
                            //pick image from Gallery camera
                            ListTile(
                              leading: const Icon(Icons.camera_alt,color: Colors.white,),
                              title: const Text('Camera',style: TextStyle(color: Colors.white)),
                              onTap: () => pickImage(ImageSource.camera),
                            ),
                          ],
                        )
                    );
                  }
              ),
              //checkbox for Adding item to All Restaurants
              Padding(
                padding: const EdgeInsets.only(top: 30,left: 25),
                child: Row(
                  children: [
                    CustomCheckBox(
                      title: 'Add to All Restaurants',
                      value: isAllRestaurants,
                      onChanged: (value){
                        setState(() {
                          isAllRestaurants = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              CustomMainButton(
                  text: 'ADD ITEM',
                  onPressed: () async {
                    //validation check
                    bool status = await validate(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                    if (status == true && flag == true){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('An item already exists with that name'),
                      ));
                    } else if (status == true && flag == false){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Could not add item, please review item information'),
                      ));
                    } else {
                      await addItem(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                      Navigator.pop(context);
                    }
                  }
              )
            ]),
      )
  );


  //add item page for items not of category "Utensil" or "Other"
  Widget others()=> Scaffold (
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: Text("Add Item"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
        child: Column(
            children: [
              CustomBackButton(onPressed: () {
                Navigator.pop(context);
              }),

            Padding(
              padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
              child: Text(title,style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
            ),

            CustomTextForm(
              hintText: "Item Name",
              controller: itemNameController,
              keyboardType: TextInputType.text,
              validator: (name) =>
              name != null && name.trim().length > 50
                  ? 'Name must be between 1 to 50 characters' : null,
              maxLines: 1,
              maxLength: 50,
              icon: const Icon(Icons.fastfood, color: Colors.black)
            ),

            CustomTextForm(
              hintText: "Price (ex: 5 or 10.99)",
              controller: priceController,
              keyboardType: TextInputType.number,
              validator: (price) =>
              price != null && !pricePattern.hasMatch(price)
                  ? 'Enter valid price (ex: 1,000 or 25.50)' : null,
              maxLines: 1,
              maxLength: 10,
              icon: const Icon(Icons.attach_money, color: Colors.black)
              ),

            CustomTextForm(
              hintText: "Item Description",
              controller: itemDescController,
              keyboardType: TextInputType.text,
              validator: (desc) =>
              desc != null && desc.trim().length > 150
                  ? 'Description cannot exceed 150 characters' : null,
              maxLines: 4,
              maxLength: 150,
              icon: const Icon(Icons.description, color: Colors.black)
              ),

              Row(
                children: [
                  CustomCheckBox(
                      title: 'Vegan',
                      value: isVegan,
                      onChanged: (value){
                        setState(() {
                          isVegan = value!;
                        });
                      },
                  ),
                  CustomCheckBox(
                    title: 'Vegetarian',
                    value: isVegetarian,
                    onChanged: (value){
                      setState(() {
                        isVegetarian = value!;
                      });
                    },
                  ),
                ],
              ),

              Row(
                children: [
                  CustomCheckBox(
                    title: 'Gluten Free',
                    value: isGlutenFree,
                    onChanged: (value){
                      setState(() {
                        isGlutenFree = value!;
                      });
                    },
                  ),
                  CustomCheckBox(
                    title: 'Nuts',
                    value: isNuts,
                    onChanged: (value){
                      setState(() {
                        isNuts = value!;
                      });
                    },
                  ),
                ],
              ),

              Row(
                children: [
                  CustomCheckBox(
                      title: 'Halal',
                      value: isHalal,
                      onChanged: (value){
                        setState(() {
                          isHalal = value!;
                        });
                      },
                  ),
                  CustomCheckBox(
                      title: 'Kosher',
                      value: isKosher,
                      onChanged: (value){
                        setState(() {
                          isKosher = value!;
                        });
                      },
                  )
                ],
              ),
              Row(
                children: [
                  CustomCheckBox(
                    title: 'Lactose Free',
                    value: isLactoseFree,
                    onChanged: (value){
                      setState(() {
                        isLactoseFree = value!;
                      });
                    },
                  ),
                  CustomCheckBox(
                    title: 'Pescatarian',
                    value: isPescatarian,
                    onChanged: (value){
                      setState(() {
                        isPescatarian   = value!;
                      });
                    },
                  )
                ],
              ),
              SizedBox(height: 20,),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: image != null ? Image.file(
                  image!,
                  height: 160,width: 160,
                  fit: BoxFit.cover,
                ) : Icon(Icons.image,size: 160,),
              ),
              SizedBox(height: 20,),
              // button to pick image for menu item
              CustomMainButton(
                  text: 'SELECT IMAGE',
                  onPressed: (){
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight:Radius.circular(24))
                      ),
                        backgroundColor: Colors.black,
                        context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.image,color: Colors.white,),
                            title: const Text('Gallery',style: TextStyle(color: Colors.white),),
                            onTap: () => pickImage(ImageSource.gallery),
                          ),
                          Divider(color: Colors.white,thickness: 1,indent: 10,endIndent: 10,),
                          ListTile(
                            leading: const Icon(Icons.camera_alt,color: Colors.white,),
                            title: const Text('Camera',style: TextStyle(color: Colors.white)),
                            onTap: () => pickImage(ImageSource.camera),
                          ),
                        ],
                      )
                    );
                  }
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30,left: 25),
                child: Row(
                  children: [
                    CustomCheckBox(
                      title: 'Add to All Restaurants',
                      value: isAllRestaurants,
                      onChanged: (value){
                        setState(() {
                          isAllRestaurants = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              CustomMainButton(
                  text: 'ADD ITEM',
                  onPressed: () async {
                    //validation check
                    bool status = await validate(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                    if (status == true && flag == true){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('An item already exists with that name'),
                      ));
                    } else if (status == true && flag == false){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Could not add item, please review item information'),
                      ));
                    } else {
                      await addItem(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                      Navigator.pop(context);
                    }
                  }
              )
            ]),
      )
  );

  //function to add item to database
  addItem(String itemName, String price, String itemDesc) async {
    if (!price.contains('.')){
      price += '.00';
    }

    if (isAllRestaurants) {
      await FirebaseFirestore.instance.collection('restaurants')
          .where('managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('isActive', isEqualTo: true).get().then(
              (restaurants) => {
            restaurants.docs.forEach((restaurant) async {
             var doc = FirebaseFirestore.instance.collection('restaurants/${restaurant.id}/menu').doc();
             await doc.set({
                'itemName': itemName,
                'price': price,
                'category': widget.category,
                'description': itemDesc,
                'creationDate': Timestamp.now(),
                'isVegan': isVegan,
                'isVegetarian': isVegetarian,
                'isGlutenFree': isGlutenFree,
                'isNuts': isNuts,
                'isKosher': isKosher,
                'isHalal': isHalal,
                'isPescatarian': isPescatarian,
                'isLactose': isLactoseFree,
                'imgURL': '',
              });
              if (image != null){
                var storageRef = FirebaseStorage.instance.ref().child("${restaurant.id}/${doc.id}.jpg");
                try {
                  await storageRef.putFile(image!);
                  String downloadURL = await storageRef.getDownloadURL();
                  await FirebaseFirestore.instance.collection('restaurants/${restaurant.id}/menu').doc(doc.id).update({
                    'imgURL': downloadURL,
                  });
                } on FirebaseException catch (e) {
                  // ...
                  print(e);
                }
              }
            })
          });
    } else {
      var doc = FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').doc();
      await doc.set({
        'itemName': itemName,
        'price': price,
        'category': widget.category,
        'description': itemDesc,
        'creationDate': Timestamp.now(),
        'isVegan': isVegan,
        'isVegetarian': isVegetarian,
        'isGlutenFree': isGlutenFree,
        'isNuts': isNuts,
        'isKosher': isKosher,
        'isHalal': isHalal,
        'isPescatarian': isPescatarian,
        'isLactose': isLactoseFree,
        'imgURL': '',
      });
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
            "${widget.restaurantID}/${doc.id}.jpg");

        try {
          await storageRef.putFile(image!);
          String downloadURL = await storageRef.getDownloadURL();
          await FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').doc(doc.id).update({
            'imgURL': downloadURL,
          });
        } on FirebaseException catch (e) {
          // ...
          print(e);
        }
      }
    }
  }

  //function to validate field input
  validate(String itemName, String price, String itemDesc) async {
    bool error = false;
    await FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').get().then(
            (value) => {
          if (value.docs.isNotEmpty) {
            value.docs.forEach((element) {
              if (element['itemName'].toUpperCase() == itemName.toUpperCase()){
                error = true;
                flag = true;
              }
            })
          }
        });

    if (isAllRestaurants){
      await FirebaseFirestore.instance.collection('restaurants').where('managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('isActive', isEqualTo: true).get().then(
              (value) => {
            if (value.docs.isNotEmpty) {
              value.docs.forEach((element) async{
                await FirebaseFirestore.instance.collection('restaurants/${element.id}/menu').get().then(
                        (element) => {
                          element.docs.forEach((item) {
                            if (item['itemName'].toUpperCase() == itemName.toUpperCase()){
                              error = true;
                              flag = true;
                            }
                        })
                });
              })}
            });
    }

    if (itemName == "" || itemName.length > 50 || price == ""){
      error = true;
    } else if ((price != "" && !pricePattern.hasMatch(price))) {
      error = true;
    } else if (itemDesc.length > 150){
      error = true;
    }

    return error;
  }
}

