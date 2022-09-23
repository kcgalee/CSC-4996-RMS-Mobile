import 'package:flutter/material.dart';
import 'package:restaurant_management_system/waiter/assignTables.dart';

class WaiterHome extends StatelessWidget {
  const WaiterHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Waiter Home"),
        ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AssignTables()),
              );
            },
            child: const Text('Assign Tables',
              style: TextStyle(
                color: Colors.white,
              ),
            )
        ),
      ),
    );
  }
}