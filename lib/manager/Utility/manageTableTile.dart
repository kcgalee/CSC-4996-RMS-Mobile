
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class ManageTableTile extends StatelessWidget {
  Function(BuildContext) onPressedEdit;
  Function(BuildContext) onPressedDelete;
  final String tableNumber;
  final String capacity;
  final String subTitle;

  ManageTableTile({
    super.key,
    required this.tableNumber,
    required this.capacity,
    required this.subTitle,
    required this.onPressedEdit,
    required this.onPressedDelete,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,width: 40,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: Text(tableNumber,
                          style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(capacity,
                      style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 40,),
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
