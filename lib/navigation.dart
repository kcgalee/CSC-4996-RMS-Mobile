import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/customerHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_management_system/login/mainscreen.dart';

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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CustomerHome())),
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
