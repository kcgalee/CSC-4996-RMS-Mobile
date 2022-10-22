import 'package:flutter/material.dart';

import '../../widgets/customSubButton.dart';
import '../addItem.dart';
import '../manageMenuItem.dart';
import 'MangerNavigationDrawer.dart';
import 'selectRestaurant.dart';


class SelectCatagory extends StatefulWidget {
  final String text;
  const SelectCatagory({Key? key, required  this.text}) : super(key: key);

  @override
  State<SelectCatagory> createState() => _SelectCatagoryState();
}

class _SelectCatagoryState extends State<SelectCatagory> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        appBar: AppBar(
        title: const Text("Menu"),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,size: 30,),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectRestaurant(text: 'menu')));
              },
            ),
          ],
        ),
    body: Center(
    child: Column(
    children: [
      const Padding(
        padding: EdgeInsets.all(24),
        child: Text("Select a Category",style: TextStyle(fontSize: 30),),
      ),
    CustomSubButton(text: "APPETIZERS",
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem()));
    }
    ),
    CustomSubButton(text: "ENTREES",
    onPressed: () {},
    ),
    CustomSubButton(text: "DESSERTS",
    onPressed: () {}
    ),
    CustomSubButton(text: "DRINKS",
    onPressed: () {}
    ),
    CustomSubButton(text: "CONDIMENTS",
    onPressed: () {},
    ),
    CustomSubButton(text: "UTENSILS",
    onPressed: () {},
    ),
    ], //Children
    )
    ));
  }
}
