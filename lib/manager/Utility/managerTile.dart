
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class ManagerTile extends StatelessWidget {
  Function(BuildContext) onPressedEdit;
  Function(BuildContext) onPressedDelete;
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
      return FutureBuilder(
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15,bottom: 15),
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
                    Text(taskName,
                        style: const TextStyle(color: Colors.black,fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(subTitle,
                        style: const TextStyle(color: Colors.black54,fontSize: 15)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

}
