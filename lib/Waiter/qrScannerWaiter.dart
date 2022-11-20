import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:restaurant_management_system/Waiter/waiterTables.dart';



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
    String name = "";
    var uId = FirebaseAuth.instance.currentUser?.uid.toString();

    await FirebaseFirestore.instance.collection('users').doc(uId).get().then(
            (data) {
          if (data['prefName'] == ''){
            name = data['fName'];
          } else {
            name = data['prefName'];
          }
        }
    );

    FirebaseFirestore.instance.collection('tables').doc(tableID).update({
      'waiterID': uId,
      'waiterName' : name
    } );

    await FirebaseFirestore.instance.collection('orders').where('tableID', isEqualTo: tableID).where('waiterID', isEqualTo: 'unhandled').get().then(
            (orders) {
          if (orders.size != 0){
            orders.docs.forEach((element) {
              element.reference.update({
                'waiterID': uId,
              });
            });
          }
        });

    //ADD waiterID to customer's user document
    await FirebaseFirestore.instance.collection('tables/$tableID/tableMembers').get().then((value){
      for(int i = 0; i < value.docs.length; i++) {
        addWaiterID(value.docs[i].data()['userID']);
      }
    });

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> new WaiterTables()));
  }

  addWaiterID(String userID) {
    FirebaseFirestore.instance.collection('users').doc(userID).update({
      'waiterID': FirebaseAuth.instance.currentUser?.uid.toString(),
    } );
  }

}

