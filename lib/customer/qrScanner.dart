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
        checkTable(scanData.code!);
      }
    });
  }

  //check if table id exists in tables collection
  Future<void> checkTable(String tableID) async {
   if(tableID != '' && tableID.contains('/') == false) {
     await FirebaseFirestore.instance.collection('tables').doc(tableID).get()
        .then((element){
      //call setTable function if tableID is found in table collection
      if(element.exists) {
        setTable(tableID);
      }

        });
   }

    //return message that table doesn't exist
     showDialog<void>(
       context: context,
       barrierDismissible:
       false,
       // user must tap button!
       builder: (BuildContext
       context) {
         return AlertDialog(
           title: const Text(
               'Alert!'),
           content:
           SingleChildScrollView(
             child: ListBody(
               children: const <
                   Widget>[
                 Text(
                     'Incorrect QR code scanned, please scan QR code provided by restaurant.'),
               ],
             ),
           ),
           actions: <Widget>[
             TextButton(
               child:
               const Text(
                   'OK'),
               onPressed: () {

                 Navigator.of(
                     context)
                     .pop();
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> new QRScanner()));

               },
             ),
           ],
         );
       },
     );

  }


  //checkTable() finds a table with tableID
  void setTable (String tableID) async {
    String name = "";
    var currentCapacity = 0;
    var maxCapacity = 0;
    var waiterID = '';
    var uId = FirebaseAuth.instance.currentUser?.uid.toString();

    //get customer user's first name
    await FirebaseFirestore.instance.collection('users').doc(uId).get().then(
            (element) {
          name = element['fName'];
        });

    //get capacity and waiter ID from tables document
    await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(

            (element) {
          currentCapacity = element['currentCapacity'];
          maxCapacity = element['maxCapacity'];
          waiterID = element['waiterID'];
        });


    //
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'tableID' : tableID,
      'waiterID' : waiterID
    });


    if(currentCapacity < maxCapacity) {
      currentCapacity++;
      FirebaseFirestore.instance.collection('tables/$tableID/tableMembers').add(
          {
            'userID': uId,
            'fName': name
          });
      FirebaseFirestore.instance.collection('tables').doc(tableID).update(
          {
            'currentCapacity' : currentCapacity
          });

    }

    Navigator.pop;
    Navigator.push(context, MaterialPageRoute(builder: (context)=> new CustomerHome()));
  }

}

