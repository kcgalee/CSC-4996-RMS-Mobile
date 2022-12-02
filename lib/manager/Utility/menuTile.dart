
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class MenuTile extends StatelessWidget {
  Function(BuildContext) onPressedEdit;
  final VoidCallback? onPressedDelete;
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
                    onPressed: (context) => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete Menu Item'),
                        content: const Text('Do you want to delete this menu item?'),
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
                padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10,top: 10),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                          height:
                          MediaQuery.of(context).size.height *0.15 ,
                          width:
                          MediaQuery.of(context).size.width,
                          child:
                          Image.network(itemIMG, fit: BoxFit.cover,)
                      ),
                    ),
                    SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(taskName,
                              style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(" \$$price",
                              style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
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
                    onPressed: (contaxt) => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete Menu Item'),
                        content: const Text('Do you want to delete this menu item?'),
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
                padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10,top: 15),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(taskName,
                            style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(" \$$price",
                            style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

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
