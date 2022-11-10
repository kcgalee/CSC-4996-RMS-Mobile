import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'manageRestaurant.dart';

class ViewRestaurant extends StatefulWidget {
  final String restID;
  final String rName;

  const ViewRestaurant({Key? key, required this.restID, required this.rName}) : super(key: key);

  @override
  State<ViewRestaurant> createState() => _ViewRestaurant();
}

class _ViewRestaurant extends State<ViewRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ManagerNavigationDrawer(),
      appBar: AppBar(
        title: const Text("Restaurant Information"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24,right: 24,bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomBackButton(onPressed: () {
              Navigator.pop(context);
            }),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('restaurants').doc(widget.restID).snapshots(),
                builder: (context, snapshot){
                  if (!snapshot.hasData || snapshot.data?.exists == false) {
                    return Center( child: CircularProgressIndicator());
                  } else {
                    return Text(snapshot.data!['restName'] ?? '');
                  }
                }
            )])),
    );
  }
}