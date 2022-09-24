import 'package:flutter/material.dart';
import '../Waiter/waiterrequest.dart';
import 'qrScanner.dart';

class PatronHome extends StatelessWidget {
  const PatronHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Patron Home"),
        actions: <Widget>[],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const QRScanner()),
                    );
                  },
                  child: const Text('QR Scanner',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ),



            ], //Children
          )


      ),
    );
  }
}