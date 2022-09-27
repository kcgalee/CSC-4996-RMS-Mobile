import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/dialog_box.dart';

import 'Utility/request_tile.dart';

class WaiterTables extends StatefulWidget {
  const WaiterTables({Key? key}) : super(key: key);

  @override
  State<WaiterTables> createState() => _WaiterTablesState();
}

class _WaiterTablesState extends State<WaiterTables> {
  // text controller
  final _controller = TextEditingController();

  var waiterRID;
  //final Stream queryTables = FirebaseFirestore.instance.collection('tables').where('restaurantID', isEqualTo: waiterRID).snapshots();

  List<String> tableDocList = [];


  //List of task
  List toDoList = [];
  // checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  //save new task
  void saveNewTask(){
    setState(() {
      toDoList.add([ _controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

// create new task
  void createNewTask(){
    showDialog(context: context, builder: (context){
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancle: () => Navigator.of(context).pop( ),
      );
    },);
  }

//delete tasks
  void deleteTask(int index){
    setState(() {
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text('Requests'),
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
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),*//*
      body: FutureBuilder(
        future: getTables(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: tableDocList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tableDocList[index].toString()),
                );
              },
          );
        },
      ),*/
        body: FutureBuilder(
            future: getRID(),
            builder: (context, snapshot) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tables').where('restaurantID', isEqualTo: waiterRID).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                          child: CircularProgressIndicator()
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            var text = 'Max Capacity: ' + (snapshot.data?.docs[index]['maxCapacity'].toString() ?? '') +
                                '\nCurrent Capacity: ' + (snapshot.data?.docs[index]['currentCapacity'].toString() ?? '');
                            return ListTile(
                              title: Text(
                                  snapshot.data?.docs[index]['description']),
                              subtitle: Text(text),
                            );
                          }
                      );
                    }
                  });
            })
    );
  }

  Future getRID() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then(
            (element) {
          print(element.reference);
          //item.fromFirestore();
          //set2.add(element);
          waiterRID = element['restaurantID'].toString();
          print(waiterRID);
        }
    );
  }

  //original
  Future getTables() async {
    await FirebaseFirestore.instance.collection('tables').get().then(
          (snapshot) => snapshot.docs.forEach(
              (element) {
            print(element.reference);
            //item.fromFirestore();
            //set2.add(element);
            tableDocList.add(element.reference.id.toString());
          }),
    );
    //tableDocList.add(element.reference.id); to get doc id
  }
}