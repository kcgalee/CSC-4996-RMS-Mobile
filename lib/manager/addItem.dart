
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/customMainButton.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import 'Utility/MangerNavigationDrawer.dart';

class AddItem extends StatefulWidget {
  final String text;
  AddItem({Key? key, required this.text}) : super(key: key);
  @override
  State<AddItem> createState() => _AddItemState(text: text);
}


class _AddItemState extends State<AddItem> {
  final String text;
  _AddItemState({Key? key, required this.text});
  final itemNameController = TextEditingController();
  final priceController = TextEditingController();
  final itemDescController = TextEditingController();
  final numberPattern = RegExp(r'^[1-9]\d*(\.\d+)?$');

  @override
  Widget build(BuildContext context)=> Scaffold (
      appBar: AppBar(
        title: Text("Add Item"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,

      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
              children: [


                CustomTextForm(
                    hintText: "Item Name",
                    controller: itemNameController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 50,
                    validator: (itemName) =>
                    itemName != null && itemName.trim().length > 50
                        ? 'Text must be between 1 to 50 characters' : null,
                    icon: const Icon(Icons.fastfood, color: Colors.black)
                ),

                CustomTextForm(
                    hintText: "Price",
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    maxLength: 10,
                    validator: (price) =>
                    price != null && !numberPattern.hasMatch(price)
                        ? 'number must be between 1 to 9999999999 ' : null,
                    icon: const Icon(Icons.attach_money, color: Colors.black)
                ),
                CustomTextForm(
                    hintText: "Item Description",
                    controller: itemDescController,
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    maxLength: 150,
                    validator: (itemName) =>
                    itemName != null && itemName.trim().length > 150
                        ? 'Text must be between 1 to 150 characters' : null,
                    icon: const Icon(Icons.description, color: Colors.black)
                ),


                CustomMainButton(
                  text: "Add Item",
                  onPressed: () {}
                )

              ]),
        ),
      )


  );



}

