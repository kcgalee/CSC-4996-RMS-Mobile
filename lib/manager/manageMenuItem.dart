import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/selectCategory.dart';
import 'package:restaurant_management_system/manager/addItem.dart';
import '../widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/managerTile.dart';


class ManageMenuItem extends StatefulWidget {
  final String restaurantID;
  final String category;
  final String rName;
  const ManageMenuItem({Key? key, required this.restaurantID, required this.category, required this.rName}) : super(key: key);

  @override
  State<ManageMenuItem> createState() => _ManageMenuItemState();
}

class _ManageMenuItemState extends State<ManageMenuItem> {
  @override
  Widget build(BuildContext context) {
    String title = '${widget.rName}: ${widget.category}s';
    return Scaffold(
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Manage Menu"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>  AddItem(restaurantID: widget.restaurantID, category: widget.category, rName: widget.rName)
              )
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.fastfood_sharp),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: CustomBackButton(onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectCategory(restaurantID: widget.restaurantID, rName: widget.rName)));
            }),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
            child: Text(title,style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
          ),

          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').where('category', isEqualTo: widget.category).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                    return Center( child: Text("You currently have no items added to the ${widget.category}s category",
                      style: TextStyle(fontSize: 20),textAlign: TextAlign.center,));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          if (widget.category != "utensil"){
                            var dietaryText = "";

                            if (snapshot.data?.docs[index]['isVegan'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nVegan";
                              } else {
                                dietaryText += " Vegan";
                              }
                            }
                            if (snapshot.data?.docs[index]['isVegetarian'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nVegetarian";
                              } else {
                                dietaryText += " Vegetarian";
                              }
                            }
                            if (snapshot.data?.docs[index]['isNuts'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nNuts";
                              } else {
                                dietaryText += " Nuts";
                              }
                            }
                            if (snapshot.data?.docs[index]['isKosher'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nKosher";
                              } else {
                                dietaryText += " Kosher";
                              }
                            }
                            if (snapshot.data?.docs[index]['isHalal'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nHalal";
                              } else {
                                dietaryText += " Halal";
                              }
                            }
                            if (snapshot.data?.docs[index]['isPescatarian'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nPescatarian";
                              } else {
                                dietaryText += " Pescatarian";
                              }
                            }
                            if (snapshot.data?.docs[index]['isLactose'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nLactose Free";
                              } else {
                                dietaryText += " Lactose Free";
                              }
                            }
                            if (snapshot.data?.docs[index]['isGlutenFree'] == true){
                              if (dietaryText == ""){
                                dietaryText += "\nGluten Free";
                              } else {
                                dietaryText += " Gluten Free";
                              }
                            }

                            return ManagerTile(
                                taskName: snapshot.data?.docs[index]['itemName'] + ' \$' + snapshot.data?.docs[index]['price'] + dietaryText,
                                subTitle: snapshot.data?.docs[index]['description'] ?? '',
                                itemIMG:  snapshot.data?.docs[index]['imgURL'],
                                onPressedEdit:  (){

                                },
                                onPressedDelete: () async {
                                  deleteItem(snapshot.data?.docs[index].id);
                                }
                            );
                          } else {
                            return ManagerTile(
                                taskName: snapshot.data?.docs[index]['itemName'] + ' \$' + snapshot.data?.docs[index]['price'],
                                subTitle: snapshot.data?.docs[index]['description'] ?? '',
                                onPressedEdit:  (){

                                },
                                onPressedDelete: ()  {
                                  deleteItem(snapshot.data?.docs[index].id);
                                }
                            );
                          }
                        }
                    );
                  }
                }),
          ),
        ],
      ),

    );
  }

  deleteItem(var itemID) async {
    await FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').doc(itemID).delete();
  }
}
