
import 'dart:ui';
import 'package:flutter/material.dart';



class ManagerTile extends StatelessWidget {
  VoidCallback onPressedEdit;
  VoidCallback onPressedDelete;
  final String taskName;
   String subTitle;
   final itemIMG;

  ManagerTile({
    super.key,
    required this.taskName,
    required this.subTitle,
    required this.onPressedEdit,
    required this.onPressedDelete,  this.itemIMG,
  });

  @override
  Widget build(BuildContext context) {

    if (itemIMG != ''){
      return FutureBuilder(
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15,bottom: 25),
            child: Container(
              padding: const EdgeInsets.only(right: 5,left: 15,bottom: 10,top: 10),
              decoration: BoxDecoration(color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black54,width: 2)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(taskName,
                      style: const TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.bold)),

                  Text(subTitle,
                      style: const TextStyle(color: Colors.black54,fontSize: 15)),

                  Image.network(itemIMG),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(right: 40,left: 40),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black38,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          onPressed: onPressedEdit,
                          child: const Text('EDIT')),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(right: 30,left: 30),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: Colors.red[900],
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black38,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          onPressed: onPressedDelete,
                          child: const Text('DELETE')),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return FutureBuilder(
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15,bottom: 25),
            child: Container(
              padding: const EdgeInsets.only(right: 5,left: 15,bottom: 10,top: 10),
              decoration: BoxDecoration(color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black54,width: 2)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(taskName,
                      style: const TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.bold)),

                  Text(subTitle,
                      style: const TextStyle(color: Colors.black54,fontSize: 15)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(right: 40,left: 40),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black38,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          onPressed: onPressedEdit,
                          child: const Text('EDIT')),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(right: 30,left: 30),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: Colors.red[900],
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black38,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          onPressed: onPressedDelete,
                          child: const Text('DELETE')),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }


  }

}
