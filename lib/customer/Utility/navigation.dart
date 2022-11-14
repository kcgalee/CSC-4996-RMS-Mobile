import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/customerHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_management_system/customer/submitReview.dart';
import 'package:restaurant_management_system/login/mainscreen.dart';

import '../pastVisits.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          buildHeader(context),
          buildMenuItems(context),
        ]
      ),
    )
  );

  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
  );

  Widget buildMenuItems(BuildContext context) => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text('Home'),
        onTap: () =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CustomerHome())),
      ),
      ListTile(
        leading: const Icon(Icons.food_bank),
        title: const Text('Past Visits'),
        onTap: () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  PastVisits())),
      ),
      ListTile(
        leading: const Icon(Icons.star_outline),
        title: const Text('Submit Review'),
        onTap: () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  SubmitReview())),
      ),
      ListTile(
        leading: const Icon(Icons.exit_to_app_outlined),
        title: const Text('Sign Out'),
        onTap: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => MainScreen()));
        },
      ),
    ]
  );
}
