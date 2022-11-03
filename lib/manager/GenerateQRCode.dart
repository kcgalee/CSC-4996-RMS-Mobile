import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Utility/MangerNavigationDrawer.dart';

class GenerateQRCode extends StatefulWidget {
  String _tableID;
  String tableNum;
  GenerateQRCode(this._tableID, this.tableNum);

  @override
  State<GenerateQRCode> createState() {
    return _GenerateQRCode(this._tableID, this.tableNum);
  }
}


class _GenerateQRCode extends State<GenerateQRCode> {
  String tableID, tableNum;
  _GenerateQRCode( this.tableID, this.tableNum);

  @override
  Widget build(BuildContext context)=> Scaffold (
    drawer: const ManagerNavigationDrawer(),
    appBar: AppBar(
      title: Text('Table ' + tableNum + ' QR Code'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    ),
    body: Center (
      child: SingleChildScrollView (
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: (tableID),
              size: 200,
              backgroundColor: Colors.white,
            ),
          ], //Children
        ),
      ),
    ),
  );

}
