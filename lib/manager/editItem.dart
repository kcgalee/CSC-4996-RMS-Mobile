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

class EditItem extends StatefulWidget {
  String restaurantID;
  String category;
  final String rName;
  final String iName;
  final String iDesc;
  final String iPrice;
  final String itemID;
  final Map<String, dynamic> iOptions;
  EditItem({Key? key, required this.itemID,required this.restaurantID,
    required this.category, required this.rName, required this.iName,
    required this.iDesc, required this.iPrice, required this.iOptions}) : super(key: key);
  @override
  State<EditItem> createState() => _EditItem();
}


class _EditItem extends State<EditItem> {
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
    itemNameController.text = widget.iName;
    itemDescController.text = widget.iDesc;
    priceController.text = widget.iPrice;
    title = widget.iName;
    flag = false;
    isVegan = widget.iOptions['isVegan'];
    isVegetarian = widget.iOptions['isVegetarian'];
    isGlutenFree = widget.iOptions['isGlutenFree'];
    isNuts = widget.iOptions['isNuts'];
    isKosher = widget.iOptions['isKosher'];
    isHalal = widget.iOptions['isHalal'];
    isPescatarian = widget.iOptions['isPescatarian'];
    isLactoseFree = widget.iOptions['isLactose'];
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    if (widget.category != 'utensil') {
      return Scaffold (
          drawer: const ManagerNavigationDrawer(),
          appBar: AppBar(
            title: Text("Edit Item"),
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

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomTextForm(
                        hintText: "Item Name",
                        controller: itemNameController,
                        keyboardType: TextInputType.text,
                        validator: (name) =>
                        name != null && name.trim().length > 50
                            ? 'Name must be between 1 to 50 characters' : null,
                        maxLines: 1,
                        maxLength: 50,
                        icon: const Icon(Icons.fastfood, color: Colors.black)
                    ),),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomTextForm(
                        hintText: "Price (ex: 5 or 10.99)",
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        validator: (price) =>
                        price != null && !pricePattern.hasMatch(price)
                            ? 'Enter valid price (ex: 1,000 or 25.50)' : null,
                        maxLines: 1,
                        maxLength: 10,
                        icon: const Icon(Icons.attach_money, color: Colors.black)
                    ),),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomTextForm(
                        hintText: "Item Description",
                        controller: itemDescController,
                        keyboardType: TextInputType.text,
                        validator: (desc) =>
                        desc != null && desc.trim().length > 150
                            ? 'Description cannot exceed 150 characters' : null,
                        maxLines: 4,
                        maxLength: 150,
                        icon: const Icon(Icons.description, color: Colors.black)
                    ),),

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

                  CustomMainButton(text: 'SELECT IMAGE', onPressed: () {
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
                  }),

                  CustomMainButton(
                      text: 'SAVE CHANGES',
                      onPressed: () async {
                        bool status = await validate(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                        if (status == true && flag == true){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('An item already exists with that name'),
                          ));
                        } else if (status == true && flag == false){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Could not save changes, please review item information'),
                          ));
                        } else if (itemNameController.text.trim() == widget.iName
                            && priceController.text.trim() == widget.iPrice
                            && itemDescController.text.trim() == widget.iDesc && image == null
                            && isVegan == widget.iOptions['isVegan'] && isVegetarian == widget.iOptions['isVegetarian']
                            && isGlutenFree == widget.iOptions['isGlutenFree'] && isNuts == widget.iOptions['isNuts']
                            && isKosher == widget.iOptions['isKosher'] && isHalal == widget.iOptions['isHalal']
                            && isPescatarian == widget.iOptions['isPescatarian'] && isLactoseFree == widget.iOptions['isLactose']) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('There is no information to update'),
                          ));
                        } else {
                          await editItem(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                          Navigator.pop(context);
                        }
                      }
                  )
                ]),
          )
      );
    } else {
      return Scaffold (
          drawer: const ManagerNavigationDrawer(),
          appBar: AppBar(
            title: Text("Edit Item"),
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

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomTextForm(
                        hintText: "Item Name",
                        controller: itemNameController,
                        keyboardType: TextInputType.text,
                        validator: (name) =>
                        name != null && name.trim().length > 50
                            ? 'Name must be between 1 to 50 characters' : null,
                        maxLines: 1,
                        maxLength: 50,
                        icon: const Icon(Icons.fastfood, color: Colors.black)
                    ),),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomTextForm(
                        hintText: "Item Description",
                        controller: itemDescController,
                        keyboardType: TextInputType.text,
                        validator: (desc) =>
                        desc != null && desc.trim().length > 150
                            ? 'Description cannot exceed 150 characters' : null,
                        maxLines: 4,
                        maxLength: 150,
                        icon: const Icon(Icons.description, color: Colors.black)
                    ),),
                  SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: image != null ? Image.file(
                      image!,
                      height: 160,width: 160,
                      fit: BoxFit.cover,
                    ) : Icon(Icons.image,size: 160,),
                  ),

                  CustomMainButton(text: 'SELECT IMAGE', onPressed: () {
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
                              title: const Text('Camara',style: TextStyle(color: Colors.white)),
                              onTap: () => pickImage(ImageSource.camera),
                            ),
                          ],
                        )
                    );
                  }),

                  CustomMainButton(
                      text: 'SAVE CHANGES',
                      onPressed: () async {
                        bool status = await validate(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                        if (status == true && flag == true){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('An item already exists with that name'),
                          ));
                        } else if (status == true && flag == false){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Could not save changes, please review item information'),
                          ));
                        } else if (itemNameController.text.trim() == widget.iName
                            && priceController.text.trim() == widget.iPrice
                            && itemDescController.text.trim() == widget.iDesc && image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('There is no information to update'),
                          ));
                        } else {
                          await editItem(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                          Navigator.pop(context);
                        }
                      }
                  )
                ]),
          )
      );
    }
  }


  editItem(String itemName, String price, String itemDesc) async {
    if (!price.contains('.')){
      price += '.00';
    }

    if (isAllRestaurants) {
      /*await FirebaseFirestore.instance.collection('restaurants').where(
          'managerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get()
          .then(
              (value) => {
            value.docs.forEach((element) async {
              var doc = FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').doc(widget.itemID);
              await doc.update({
                'itemName': itemName,
                'price': price,
                'category': widget.category,
                'description': itemDesc,
                'isVegan': isVegan,
                'isVegetarian': isVegetarian,
                'isGlutenFree': isGlutenFree,
                'isNuts': isNuts,
                'isKosher': isKosher,
                'isHalal': isHalal,
                'isPescatarian': isPescatarian,
                'isLactose': isLactoseFree,
              });
              if (image != null) {
                final storageRef = FirebaseStorage.instance.ref().child(
                    "${widget.restaurantID}/${doc.id}.jpg");
                try {
                  await storageRef.putFile(image!);
                  String downloadURL = await storageRef.getDownloadURL();
                  await FirebaseFirestore.instance.collection(
                      'restaurants/${widget.restaurantID}/menu').doc(doc.id).update({
                    'imgURL': downloadURL,
                  });
                } on FirebaseException catch (e) {
                  // ...
                  print(e);
                }
              }
            })
          });*/
    } else {
      var doc = FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').doc(widget.itemID);
      await doc.update({
        'itemName': itemName,
        'price': price,
        'category': widget.category,
        'description': itemDesc,
        'isVegan': isVegan,
        'isVegetarian': isVegetarian,
        'isGlutenFree': isGlutenFree,
        'isNuts': isNuts,
        'isKosher': isKosher,
        'isHalal': isHalal,
        'isPescatarian': isPescatarian,
        'isLactose': isLactoseFree,
      });
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
            "${widget.restaurantID}/${doc.id}.jpg");
        try {
          await storageRef.putFile(image!);
          String downloadURL = await storageRef.getDownloadURL();
          await FirebaseFirestore.instance.collection(
              'restaurants/${widget.restaurantID}/menu').doc(doc.id).update({
            'imgURL': downloadURL,
          });
        } on FirebaseException catch (e) {
          // ...
          print(e);
        }
      }
    }
  }

  validate(String itemName, String price, String itemDesc) async {
    bool error = false;
    if (itemName != widget.iName){
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
    }


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
