
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/manageMenuItem.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import '../widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';

class AddItem extends StatefulWidget {
  String restaurantID;
  String category;

  AddItem({Key? key, required this.restaurantID, required this.category}) : super(key: key);
  @override
  State<AddItem> createState() => _AddItemState();
}


class _AddItemState extends State<AddItem> {
  final itemNameController = TextEditingController();
  final priceController = TextEditingController();
  final itemDescController = TextEditingController();
  final pricePattern = RegExp(r'^(\$)?(([1-9]\d{0,2}(\,\d{3})*)|([1-9]\d*)|(0))(\.\d{2})?$');
  bool flag = false;

  @override
  void initState() {
    //set default text
    priceController.text = '0.00';

    super.initState();
  }

  @override
  Widget build(BuildContext context)=> Scaffold (
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


              CustomMainButton(
                  text: "Add Item",
                  onPressed: () async {
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('success'),
                      ));
                      addItem(itemNameController.text.trim(), priceController.text.trim(), itemDescController.text.trim());
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ManageMenuItem(restaurantID: widget.restaurantID, category: widget.category)
                          )
                      );
                    }
                  }
              )
            ]),
      )


  );

  addItem(String itemName, String price, String itemDesc) async {
    if (!price.contains('.')){
      price += '.00';
    }
    await FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').doc().set({
      'itemName': itemName,
      'price': price,
      'category': widget.category,
      'description': itemDesc,
      'creationDate': Timestamp.now(),
    });
  }

  validate(String itemName, String price, String itemDesc) async {
    bool error = false;
    await FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').get().then(
            (value) => {
          if (value.docs.isNotEmpty) {
            value.docs.forEach((element) {
              if (element['name'].toUpperCase() == itemName.toUpperCase()){
                error = true;
                flag = true;
              }
            })
          }
        });

    if (itemName == "" || itemName.length > 50 || price == ""){
      error = true;
    } else if ((price != "" && !pricePattern.hasMatch(price))) {
      print('yo');
      error = true;
    } else if (itemDesc.length > 150){
      error = true;
    }

    return error;
  }



}

