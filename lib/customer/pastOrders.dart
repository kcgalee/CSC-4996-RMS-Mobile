import 'package:flutter/material.dart';

import 'Utility/navigation.dart';


class PastOrders extends StatefulWidget {
  const PastOrders({Key? key}) : super(key: key);

  @override
  State<PastOrders> createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(

      title: const Text("Past Orders"),
      actions: <Widget>[],
      )
    );
  }
}
