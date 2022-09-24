import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/dialog_box.dart';
import 'package:restaurant_management_system/Waiter/models/tables.dart';

import 'Utility/request_tile.dart';

class WaiterRequest extends StatefulWidget {
  const WaiterRequest({Key? key}) : super(key: key);

  @override
  State<WaiterRequest> createState() => _WaiterRequestState();
}

class _WaiterRequestState extends State<WaiterRequest> {

  List<String> tableDocList = [];
  List<Map> set2 = [];

  //List of task
  List toDoList = [
    ["make tutotial", false],
    ["dance", false],
  ];
  // checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }
// create new task
  void createNewTask(){
    showDialog(context: context, builder: (context){
      return DialogBox();
    },);
  }

  Widget _buildListItem(BuildContext context, document){
    return ListTile(
      title: Row(
        children: [
          Expanded(
              child: Text(
                document['type'],
              ),
          ),
          Container(
            /*decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),*/
              //padding: const EdgeInsets.all(10.0),
              child: Text(
                document['description'],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text('Waiter Home'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      /*body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context,index){
          return RequestTile(
              taskName: toDoList[index][0],
              taskCompleted: toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
          );
        },
      ),*/
      body: FutureBuilder(
        future: getTables(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return ListView.builder(
              itemCount: tableDocList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tableDocList[index]),
                );
              },
          );
        },
      ),
    );
  }

  /* //tester function
  Future getTables() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) =>
          snapshot.docs.forEach(
                  (element) {
                print(element.reference);
                //set2.add(element);
                set2.add(element as Map<String, dynamic>);
                print(set2);
                print('hello');
              }),
    );
  }*/

  //original
  Future getTables() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
              (element) {
            print(element.reference);
            //set2.add(element);
            tableDocList.add(element['name']);
          }),
    );
    //tableDocList.add(element.reference.id); to get doc id
  }
}
