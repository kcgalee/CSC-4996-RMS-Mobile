
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class MenuTile extends StatelessWidget {
  Function(BuildContext) onPressedEdit;
  Function(BuildContext) onPressedDelete;
  final String taskName;
  String subTitle;
  final itemIMG;
  final String price;

  MenuTile({
    super.key,
    required this.taskName,
    required this.subTitle,
    required this.onPressedEdit,
    required this.onPressedDelete,  this.itemIMG,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {

    if (itemIMG != null && itemIMG != ''){
      return FutureBuilder(
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15,bottom: 25),
            child: Slidable(
              endActionPane: ActionPane(
                motion:const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed:  onPressedEdit,
                    icon: Icons.edit_note,
                    label: 'EDIT',
                    backgroundColor: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SlidableAction(
                    onPressed: onPressedDelete,
                    icon: Icons.delete,
                    label: 'DELETE',
                    backgroundColor: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  )

                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(right: 5,left: 15,bottom: 10,top: 10),
                decoration: BoxDecoration(color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black54,width: 2)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(itemIMG,height: 150,width: 150,fit: BoxFit.contain,)),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(taskName,
                            style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(price,
                            style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(color: Colors.black, thickness: 1),
                    Text(subTitle,
                        style: const TextStyle(color: Colors.black,fontSize: 15)),
                  ],
                ),
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
            child: Slidable(
              endActionPane: ActionPane(
                motion:const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: onPressedEdit,
                    icon: Icons.edit_note,
                    label: 'EDIT',
                    backgroundColor: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SlidableAction(
                    onPressed: onPressedDelete,
                    icon: Icons.delete,
                    label: 'DELETE',
                    backgroundColor: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  )

                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(right: 5,left: 15,bottom: 10,top: 10),
                decoration: BoxDecoration(color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black54,width: 2)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(taskName,
                          style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(price,
                          style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Divider(color: Colors.black, thickness: 1),

                    Text(subTitle,
                        style: const TextStyle(color: Colors.black,fontSize: 15)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

}