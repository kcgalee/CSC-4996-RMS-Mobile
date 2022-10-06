

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Utility/MangerNavigationDrawer.dart';

class GenerateQRCode extends StatefulWidget {
  @override
  State<GenerateQRCode> createState() => _GenerateQRCode();
}


class _GenerateQRCode extends State<GenerateQRCode> {

  @override
  Widget build(BuildContext context)=> Scaffold (
    drawer: const ManagerNavigationDrawer(),
    appBar: AppBar(
      title: Text("Add Table"),
    ),
    body: Center (
      child: SingleChildScrollView (
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: ('table number'),
              size: 200,
              backgroundColor: Colors.white,
            ),
          ], //Children
        ),
      ),
    ),
  );

}
