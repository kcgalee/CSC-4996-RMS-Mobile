import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/showMenuItems.dart';
import '../widgets/customMainButton.dart';
import '../widgets/customSubButton.dart';


class ManageMenu extends StatefulWidget {

  const ManageMenu({Key? key,}) :super(key: key);

  @override
  State<ManageMenu> createState() => _ManageMenu();
}

class _ManageMenu extends State<ManageMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Menu"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(26),
                  child: Text('Select a Category',
                    style: const TextStyle(fontSize: 25,),),
                ),
                CustomSubButton(text: "APPETIZERS",
                    onPressed: () {

                    }
                ),
                CustomSubButton(text: "ENTREES",
                    onPressed: () {

                    }
                ),
                CustomSubButton(text: "DESSERTS",
                    onPressed: () {

                    }
                ),
                CustomSubButton(text: "DRINKS",
                    onPressed: () {

                    }
                ),
                CustomSubButton(text: "CONDIMENTS",
                    onPressed: () {

                    }
                  ),
                CustomSubButton(text: "UTENSILS",
                  onPressed: () {

                  }
                ),
              ], //Children
            )
        )
    );
  }
}
