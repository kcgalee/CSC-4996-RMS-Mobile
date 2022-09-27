import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';
import 'package:restaurant_management_system/Waiter/waiterrequest.dart';

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

      Padding(
        padding: const EdgeInsets.only(left: 0,right: 0,top: 20,bottom: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 80,width: 300),
          child: ElevatedButton(child: Text("Waiter Request Page"),
              onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => WaiterRequest()));
          }),
        ),
      ),


      Padding(
        padding: const EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 10),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 80,width: 300),
          child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const WaiterTables()),
                  );
                  },
              child: const Text('Assign Tables',
                style: TextStyle(
                  color: Colors.white,),
                )
          ),
        ),
      ),



    ], //Children
      ),
      )
    );
  }
}

