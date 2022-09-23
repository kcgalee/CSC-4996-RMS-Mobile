import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/waiterrequest.dart';
import 'package:restaurant_management_system/waiter/assignTables.dart';

class WaiterHome extends StatefulWidget {
  const WaiterHome({Key? key}) : super(key: key);

  @override
  State<WaiterHome> createState() => _WaiterHomeState();
}

class _WaiterHomeState extends State<WaiterHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Waiter Home"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const WaiterRequest()),
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
