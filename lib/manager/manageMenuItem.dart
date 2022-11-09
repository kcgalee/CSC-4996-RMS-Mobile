import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/selectCategory.dart';
import 'package:restaurant_management_system/manager/addItem.dart';
import '../widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/menuTile.dart';
import 'editItem.dart';


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
                          var dOptions = ({
                            'isVegan': snapshot.data?.docs[index]['isVegan'],
                            'isVegetarian': snapshot.data?.docs[index]['isVegetarian'],
                            'isGlutenFree': snapshot.data?.docs[index]['isGlutenFree'],
                            'isNuts': snapshot.data?.docs[index]['isNuts'],
                            'isKosher': snapshot.data?.docs[index]['isKosher'],
                            'isHalal': snapshot.data?.docs[index]['isHalal'],
                            'isPescatarian': snapshot.data?.docs[index]['isPescatarian'],
                            'isLactose': snapshot.data?.docs[index]['isLactose'],
                          });
                          if (widget.category != "utensil"){
                            var dietaryText = "";

                            if (snapshot.data?.docs[index]['isVegan'] == true){
                                dietaryText += "Vegan";
                            }
                            if (snapshot.data?.docs[index]['isVegetarian'] == true){
                                dietaryText += "Vegetarian";
                            }
                            if (snapshot.data?.docs[index]['isNuts'] == true){
                                dietaryText += "Nuts";

                            }
                            if (snapshot.data?.docs[index]['isKosher'] == true){
                                dietaryText += "Kosher";

                            }
                            if (snapshot.data?.docs[index]['isHalal'] == true){
                                dietaryText += " Halal";

                            }
                            if (snapshot.data?.docs[index]['isPescatarian'] == true){
                                dietaryText += "Pescatarian";
                            }
                            if (snapshot.data?.docs[index]['isLactose'] == true){
                                dietaryText += "Lactose Free";

                            }
                            if (snapshot.data?.docs[index]['isGlutenFree'] == true){
                                dietaryText += " Gluten Free";

                            }

                            return MenuTile(
                                taskName: snapshot.data?.docs[index]['itemName'] ,
                                subTitle: dietaryText + "\n\n" + snapshot.data?.docs[index]['description'] ?? '',
                                price: ' \$' + snapshot.data?.docs[index]['price'],
                                itemIMG:  snapshot.data?.docs[index]['imgURL'],
                                onPressedEdit:  (p0) => {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) =>  EditItem(itemID: snapshot.data?.docs[index].id ?? '', restaurantID: widget.restaurantID, category: widget.category,
                                              rName: widget.rName, iName: snapshot.data?.docs[index]['itemName'], iDesc: snapshot.data?.docs[index]['description'],
                                              iPrice: snapshot.data?.docs[index]['price'], iOptions: dOptions)
                                      )
                                  )
                                },
                                onPressedDelete: (p0) =>  {
                                  if (snapshot.data?.docs[index]['imgURL'] != ''){
                                     deleteItem(snapshot.data?.docs[index].id, true)
                                  } else {
                                     deleteItem(snapshot.data?.docs[index].id, false)
                                  }
                                }
                            );
                          } else {
                            return MenuTile(
                                taskName: snapshot.data?.docs[index]['itemName'] ,
                                subTitle: snapshot.data?.docs[index]['description'] ?? '',
                                price: ' \$' + snapshot.data?.docs[index]['price'],
                                onPressedEdit:  (p0) =>{},
                                onPressedDelete: (p0) => {
                                  if (snapshot.data?.docs[index]['imgURL'] != ''){
                                     deleteItem(snapshot.data?.docs[index].id, true)
                                  } else {
                                     deleteItem(snapshot.data?.docs[index].id, false)
                                  }
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

  deleteItem(var itemID, bool flag) async {
    await FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').doc(itemID).delete();
    if (flag){
      await FirebaseStorage.instance.ref().child('${widget.restaurantID}/$itemID.jpg').delete();
    }
  }
}
