import 'package:flutter/material.dart';


class ViewTableTile extends StatelessWidget {
  final String taskName;
  String subTitle;
  ViewTableTile({
    super.key,
    required this.taskName,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,top: 15),
          child: Container(
            padding: const EdgeInsets.only(right: 5,left: 15,bottom: 10,top: 10),
            decoration: BoxDecoration(color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black54,width: 2)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(taskName,
                    style: const TextStyle(color: Colors.black54,fontSize: 20, fontWeight: FontWeight.bold)),

                Text(subTitle,
                    style: const TextStyle(color: Colors.black54,fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

}
