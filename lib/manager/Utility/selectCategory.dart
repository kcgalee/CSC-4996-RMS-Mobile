import 'package:flutter/material.dart';
import '../../widgets/customBackButton.dart';
import '../../widgets/customSubButton.dart';
import '../manageMenuItem.dart';
import 'MangerNavigationDrawer.dart';
import 'selectRestaurant.dart';


class SelectCategory extends StatefulWidget {
  final String restaurantID;
  const SelectCategory({Key? key, required  this.restaurantID}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        appBar: AppBar(
        title: const Text("Menu"),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 1,
        ),
    body: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: CustomBackButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => SelectRestaurant(text: 'menu')
                  )
              );
            }),
          ),
          const Padding(
            padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
            child: Text("select a category",style: TextStyle(fontSize: 30),),
          ),
        CustomSubButton(text: "APPETIZERS",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'appetizer')));
            }
          ),
        CustomSubButton(text: "ENTREES",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'entree')));
            }
        ),
        CustomSubButton(text: "DESSERTS",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'dessert')));
            }
        ),
        CustomSubButton(text: "DRINKS",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'drink')));
            }
        ),
        CustomSubButton(text: "CONDIMENTS",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'condiment')));
            }
        ),
        CustomSubButton(text: "UTENSILS",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ManageMenuItem(restaurantID: widget.restaurantID, category: 'utensil')));
            }
        ),
      ], //Children
    )));
  }
}
