import 'package:flutter/material.dart';
import '../../widgets/customBackButton.dart';
import '../../widgets/customSubButton.dart';
import '../manageMenuItem.dart';
import 'MangerNavigationDrawer.dart';
import 'selectRestaurant.dart';


class SelectCategory extends StatefulWidget {
  final String restaurantID;
  final String rName;
  const SelectCategory({Key? key, required this.restaurantID, required this.rName}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    String title = widget.rName + ' Menu';
    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        appBar: AppBar(
        title: const Text("Menu"),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 1,
        ),
    body: SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: CustomBackButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SelectRestaurant(text: 'menu')
                    )
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
              child: Text(title,style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
            ),
          CustomSubButton(text: "APPETIZERS",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'appetizer', rName: widget.rName)));
              }
            ),
          CustomSubButton(text: "ENTREES",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'entree', rName: widget.rName)));
              }
          ),
          CustomSubButton(text: "DESSERTS",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'dessert', rName: widget.rName)));
              }
          ),
          CustomSubButton(text: "DRINKS",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'drink', rName: widget.rName)));
              }
          ),
          CustomSubButton(text: "CONDIMENTS",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'condiment', rName: widget.rName)));
              }
          ),
          CustomSubButton(text: "UTENSILS",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'utensil', rName: widget.rName)));
              }
          ),
        ], //Children
      )),
    ));
  }
}
