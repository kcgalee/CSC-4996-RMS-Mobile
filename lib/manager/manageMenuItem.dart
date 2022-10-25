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

  const ManageMenuItem({Key? key, required this.restaurantID, required this.category}) : super(key: key);

  @override
  State<ManageMenuItem> createState() => _ManageMenuItemState();
}

class _ManageMenuItemState extends State<ManageMenuItem> {
  @override
  Widget build(BuildContext context) {
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
                  builder: (context) =>  AddItem(restaurantID: widget.restaurantID, category: widget.category)
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectCategory(restaurantID: widget.restaurantID)));
            }),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('restaurants/${widget.restaurantID}/menu').where('category', isEqualTo: widget.category).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                    return Center( child: Text("You currently have no items added to the ${widget.category}s category"));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return ManagerTile(
                              taskName: snapshot.data?.docs[index]['itemName'] + ' \$' + snapshot.data?.docs[index]['price'],
                              subTitle: snapshot.data?.docs[index]['description'] ?? '',
                              onPressedEdit:  (){

                              },
                              onPressedDelete: () async {

                              }
                          );
                        }
                    );
                  }
                }),
          ),
        ],
      ),

    );
  }
}
