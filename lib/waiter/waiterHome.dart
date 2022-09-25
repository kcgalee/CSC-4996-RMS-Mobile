import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';

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
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      ElevatedButton(child: Text("Waiter Request Page"),
          onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => WaiterRequest()));
      }),


      ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const WaiterRequest()),
              );
              },
          child: const Text('Assign Tables',
            style: TextStyle(
              color: Colors.white,),
            )
      ),



    ], //Children
      ),
      )
    );
  }
}

