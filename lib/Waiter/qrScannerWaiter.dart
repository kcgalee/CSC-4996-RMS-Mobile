import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:restaurant_management_system/Waiter/viewTable.dart';
import 'package:restaurant_management_system/Waiter/waiterHome.dart';
import 'package:restaurant_management_system/Waiter/waiterRequest.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';

import '../customer/Models/restaurantInfo.dart';


class QRScannerWaiter extends StatefulWidget {
  const QRScannerWaiter({super.key});

  @override
  State<QRScannerWaiter> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScannerWaiter> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;

  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
            Positioned(bottom:19, child: buildResult()),
          ],
        ),
      )
  );

  Widget buildResult() => Container(
    padding: const EdgeInsets.all(12),
    decoration: const BoxDecoration(
      color: Colors.white24,
    ),
    child: Text(
      barcode != null ? 'Result: ${barcode!.code}' :'Scan a code!',
      maxLines: 3,
    ),

  );

  Widget buildQrView(BuildContext context) => QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(),
  );

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((Barcode scanData) async {
      if (scanData.format == BarcodeFormat.qrcode && scanData.code != null) {
        controller.pauseCamera();
        setTable(scanData.code!);

      }
    });
  }

  void setTable (String tableID) async {
    RestaurantInfo restaurantMenu = RestaurantInfo();
    restaurantMenu.setter(tableID);
    String name = "";
    var uId = FirebaseAuth.instance.currentUser?.uid.toString();
    final docRef = FirebaseFirestore.instance.collection('users').doc(uId);
    await docRef.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          name = data['prefName'];
        });


    FirebaseFirestore.instance.collection('tables').doc(tableID).update({
      'waiterID': uId,
      'waiterName' : name
    } );
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> new WaiterTables()));
  }

}

