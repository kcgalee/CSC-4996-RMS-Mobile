import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'customerDashboard.dart';

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
    setState(()=> this.controller = controller);
    bool scanned = false;

    controller.scannedDataStream.listen(
        (barcode)=> setState(() =>
          this.barcode = barcode

        )

    );
    // possible solution for navigating to dashboard after scanning qr code
    // bool scanned = false;
    // controller.scannedDataStream.listen((scanData) {
    //   if (!scanned) {
    //     scanned = true;
    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const PatronDashboard()),
    //     );
    //   }
    // });
  }

}

