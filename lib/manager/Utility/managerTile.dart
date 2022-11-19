
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class ManagerTile extends StatelessWidget {
  Function(BuildContext) onPressedEdit;
  final VoidCallback? onPressedDelete;
  final VoidCallback? onTap;
  final String name;
   String subTitle;

  ManagerTile({
    super.key,
    required this.name,
    required this.subTitle,
    required this.onPressedEdit,
    required this.onPressedDelete,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
      return InkWell(
        onTap: onTap,
        child: FutureBuilder(
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
                      onPressed: (contaxt) => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete Employee'),
                          content: const Text('Do you want to delete this employee?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: onPressedDelete,
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      ),
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
                        children: [
                          Container(
                            constraints: BoxConstraints(minHeight: 50),
                            width: 150,
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(name,
                                  style: const TextStyle(color: Colors.black,fontSize: 20,)),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(subTitle,
                                style: const TextStyle(color: Colors.black,fontSize: 15)),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

}
