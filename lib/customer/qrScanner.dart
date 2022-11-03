import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'customerHome.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
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

    String name = "";
    var currentCapacity = 0;
    var maxCapacity = 0;
    var restID;


    //get customers first name to add to tableMembers
    var uId = FirebaseAuth.instance.currentUser?.uid.toString();
    await FirebaseFirestore.instance.collection('users').doc(uId).get().then(
            (element) {
          name = element['fName'];
        });

    //Get some table information and restaurant information to add to customer doc
    await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(

            (element) {
          currentCapacity = element['currentCapacity'];
          maxCapacity = element['maxCapacity'];
          restID = element['restID'];
        });

    //Check to see if table capacity is met, if it is then don't add customer, if not
    //then add customer to table and add info to customer doc
    if(currentCapacity < maxCapacity) {
      currentCapacity++;

      print(restID);
      //Add table id and restID to user information
      FirebaseFirestore.instance.collection('users').doc(uId).update({
        'tableID' : tableID,
        'restID' : restID
      });

      //add customer ID and name to tableMembers doc
      FirebaseFirestore.instance.collection('tables/$tableID/tableMembers').add(
          {
            'userID': uId,
            'fName': name
          });

      //update current capacity on table doc
      FirebaseFirestore.instance.collection('tables').doc(tableID).update(
          {
            'currentCapacity' : currentCapacity
          });

    }


    Navigator.push(context, MaterialPageRoute(builder: (context)=> const CustomerHome()));
  }

}

