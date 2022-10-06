import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/navigation.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(

        title: const Text("Order"),
        actions: <Widget>[],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [


            ], //Children
          )


      ),
    );
  }
}
