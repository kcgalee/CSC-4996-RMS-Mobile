import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'requests.dart';


class PatronDashboard extends StatefulWidget {
  const PatronDashboard({Key? key}) : super(key: key);

  @override
  State<PatronDashboard> createState() => _PatronDashboardState();
}

class _PatronDashboardState extends State<PatronDashboard> {

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
                  child: Text("Put In Request"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => Requests()));
                  }),
            ], //Children
          )


      ),
    );
  }
}
