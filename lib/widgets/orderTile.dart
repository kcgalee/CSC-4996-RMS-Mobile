import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';


class OrderTile extends StatelessWidget {
  final CreateOrderInfo createOrderInfo;
  final String taskName;
  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = Color(0xffffebee);
  Color iPColor = Color(0xfff9fbe7);
  Color dColor = Color(0xffe8f5e9);



  OrderTile({
    super.key,
    required this.taskName,
    required this.createOrderInfo
  });

  @override
  Widget build(BuildContext context) {
    var isVisible = true;



    return FutureBuilder(
      future: getItemName(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,top: 25),
          child: Container(
            padding: const EdgeInsets.only(right: 15,left: 10,bottom: 10,top: 10),
            decoration: BoxDecoration(color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //task name and time
                Text(taskName,
                    style: const TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                ),

              ],
            ),
          ),
        );
      },
    );
  }

  getItemName() {
    return '';
  }


}
