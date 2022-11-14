import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restaurant_management_system/manager/addTable.dart';
import 'package:restaurant_management_system/widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/manageTableTile.dart';
import 'Utility/selectRestaurant.dart';
import 'editTable.dart';
import 'managerHome.dart';

class ManageTables extends StatefulWidget {
  final String restaurantID;
  final String restName;
  ManageTables({Key? key, required this.restaurantID, required this.restName}) : super(key: key);

  @override
  State<ManageTables> createState() => _ManageTables();
}

class _ManageTables extends State<ManageTables> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        appBar: AppBar(
          title: Text('Manage Tables'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  AddTable(text: widget.restaurantID, restName: widget.restName)
                )
            );
          },
          label: const Text('Add'),
          icon: const Icon(Icons.add_business_outlined),
          backgroundColor: Colors.black,
        ),


        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: CustomBackButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SelectRestaurant(text: 'table')
                    )
                );
              }),
            ),
            Text(widget.restName,style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables').where('restID', isEqualTo: widget.restaurantID).orderBy('tableNum').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text("You currently have no tables at ${widget.restName}."),);
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ManageTableTile(
                                capacity: (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '') + '/'
                                    + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? ''),
                                tableNumber: snapshot.data?.docs[index]['tableNum'].toString() ?? '',
                                subTitle: 'Type: ' + (snapshot.data?.docs[index]['type'].toString() ?? '')
                                    + '\nLocation: ' + (snapshot.data?.docs[index]['location'].toString() ?? ''),
                                onPressedEdit:  (p0) => {
                                  if (snapshot.data?.docs[index]['currentCapacity'] != 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Cannot edit a table while it is in use'),
                                        ))
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>  EditTable(tableID: snapshot.data?.docs[index].id ?? '',
                                            restName: widget.restName, restID: widget.restaurantID, tableNumber: snapshot.data?.docs[index]['tableNum'] ?? '',
                                            tableType: snapshot.data?.docs[index]['type'].toString() ?? '',
                                            tableLoc: snapshot.data?.docs[index]['location'].toString() ?? '',
                                            tableMaxCap: snapshot.data?.docs[index]['maxCapacity'])
                                        )
                                    )
                                  }
                                },
                                onPressedDelete: (p0) =>   {
                                  if (snapshot.data?.docs[index]['currentCapacity'] != 0){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Cannot delete a table while it is in use'),
                                    ))
                                  } else {
                                    deleteTable(snapshot.data?.docs[index].id)
                                  }
                                },
                              onTap: (){
                                  //******** QR code Generater here *********
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight:Radius.circular(24))
                                    ),
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                           Text('QR code for table ${snapshot.data?.docs[index]['tableNum']}',style: TextStyle(fontSize: 20,),),
                                      QrImage(
                                        data: (snapshot.data?.docs[index].id as String),
                                        size: 200,
                                        backgroundColor: Colors.white,),

                                        ],
                                      ),
                                    )
                                );


                              },
                            );
                          }
                      );
                    }
                  }),
            ),
          ],
        )
    );
  }

  deleteTable(var id) async {
    var restaurant = await FirebaseFirestore.instance.collection('tables').doc(id).get();
    await restaurant.reference.delete();
  }
}
