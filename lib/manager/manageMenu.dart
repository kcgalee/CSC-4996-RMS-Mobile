
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/addItem.dart';

import 'Utility/MangerNavigationDrawer.dart';


class ManageMenu extends StatefulWidget {
  const ManageMenu({Key? key}) : super(key: key);

  @override
  State<ManageMenu> createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
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
                  builder: (context) =>  AddItem(text: "menu")
              )
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.fastfood_sharp),
        backgroundColor: Colors.black,
      ),


      body: Column(

      ),

    );
  }
}
