import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:restaurant_management_system/customer/Models/createOrderInfo.dart';

class OrderTile extends StatelessWidget {
  final CreateOrderInfo createOrderInfo;
  final String taskName;
  Function(BuildContext) onPressedEdit;
  Function(BuildContext) onPressedDelete;

  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = const Color(0xffffebee);
  Color iPColor = const Color(0xfff9fbe7);
  Color dColor = const Color(0xffe8f5e9);

  var imgURL;
  var price;
  late var newPrice;

  OrderTile({
    super.key,
    required this.imgURL,
    required this.taskName,
    required this.price,
    required this.createOrderInfo,
    required this.onPressedEdit,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
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
          padding:
          const EdgeInsets.only(right: 15, left: 10, bottom: 10, top: 10),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black54)),
          child: FutureBuilder (
            future: getPrice(price),
            builder: (build, context2) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //task name and time
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child:
                        FittedBox(
                          fit: BoxFit.fill,
                          child:
                          Image.network(imgURL),
                        ),
                      ),
                      const SizedBox (width: 15),
                      Flexible(
                        child: Text('${taskName}\n$newPrice',
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          )

        ),
      )
    );
  }

  Future<void> getPrice(String price) async {
    if(price == '0.00') {
      newPrice = 'Free';
    } else {
      newPrice = '\$$price';
    }
  }

}
