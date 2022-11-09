import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateOrderInfo{

  late List<String> itemID = [];
  late List<int> count = [];
  late List<String> itemName= [];
  late List<String> price = [];
  late List<String> orderComments = [];
  late List<String> imgURL = [];
  late int itemCount;
  late var custName;
  late var custID;
  late List<int> priority = [];

  CreateOrderInfo(this.custID){
   itemCount = 0;
  }

  orderSetter(String itemID, int count, String itemName, String price,
      String comments, int priority, String imgURL) async {
    this.count.add(count);
    this.itemID.add(itemID);
    this.imgURL.add(imgURL);
    this.itemName.add(itemName);
    this.price.add(price);
    orderComments.add(comments);
    this.priority.add(priority);
    itemCount++;

    await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
            (element) {
          custName = element['fName'];
        });
  }

  void placeOrder(String tableID, String tableNum, String waiterID, String restID) {
    for(int i = 0; i < itemCount; i++) {
      placeOrderHelper(itemID[i], itemName[i], count[i], price[i], orderComments[i], priority[i],
          tableID, tableNum, waiterID, restID);
    }
    orderClear();
  }//place order

  void placeOrderHelper(String itemID, String itemName, int count, String price,
      String comments, int priority, String tableID, String tableNum,
      String waiterID, String restID)
  {

    var uID = FirebaseAuth.instance.currentUser?.uid.toString();
    final DateTime now = DateTime.now();
    CollectionReference users = FirebaseFirestore.instance.collection('orders');

    String orderID = users
        .doc()
        .id
        .toString()
        .trim();

    users.doc(orderID).set(
    {
      'priority' : priority,
        'orderComment' : comments,
        'price' : price,
        'custName' : custName,
        'custID' : uID.toString(),
        'itemID' : itemID,
        'itemName' : itemName,
        'quantity' :count,
        'tableNum' : tableNum,
        'restID' : restID,
        'tableID' : tableID,
        'waiterID': waiterID,
        'status' : 'placed',
      'timePlaced': Timestamp.fromDate(now),
    }
    );

       FirebaseFirestore.instance.collection('tables/$tableID/tableOrders').doc(orderID)

            .set(

        {
          'orderComment' : comments,
          'price' : price,
          'custName' : custName,
          'custID' : uID.toString(),
          'itemID' : itemID,
          'itemName' : itemName,
          'quantity' : count,
          'tableNum' : tableNum,
          'restID' : restID,
          'tableID' : tableID,
          'waiterID': waiterID,
          'status' : 'placed',
          'timePlaced': Timestamp.fromDate(now),

        }
    );


  }

 Future<void> request(String request, String tableID, String tableNum, String waiterID, String restID) async {

   var uID = FirebaseAuth.instance.currentUser?.uid.toString();
   final DateTime now = DateTime.now();

   await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
           (element) {
         custName = element['fName'];
       });

   FirebaseFirestore.instance.collection('orders').add(
   {
        'orderComment' : '',
        'custName' : custName,
         'custID' : uID.toString(),
         'itemName' : request,
         'restID' : restID,
         'tableID' : tableID,
        'tableNum' : tableNum,
         'waiterID': waiterID,
         'status' : 'placed',
         'timePlaced': Timestamp.fromDate(now),
          'price' : '0.00',
         'quantity' : 1,
        'priority' : 1
       }
   );

 }
  Future<void> billRequest(String request, String tableID, String tableNum, String waiterID, String restID) async {

    var uID = FirebaseAuth.instance.currentUser?.uid.toString();
    final DateTime now = DateTime.now();

    await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
            (element) {
          custName = element['fName'];
        });

    FirebaseFirestore.instance.collection('orders').add(
        {
          'orderComment': '',
          'priority' : 1,
          'custName' : custName,
          'custID' : uID.toString(),
          'itemName' : request,
          'restID' : restID,
          'tableID' : tableID,
          'tableNum' : tableNum,
          'waiterID': waiterID,
          'status' : 'placed',
          'timePlaced': Timestamp.fromDate(now),
          'price' : '0.00',
          'quantity' : 1
        }
    );

    FirebaseFirestore.instance.collection('tables').doc(tableID).update({
      'billRequested' : true,
    });



  }
 void orderClear() {
    itemID.clear();
    itemName.clear();
    price.clear();
    count.clear();
    itemCount = 0;
 }

 //deletes item from current order
void deleteItem(int index) {
    itemCount = itemCount - 1;
    itemID.removeAt(index);
    itemName.removeAt(index);
    count.removeAt(index);
    imgURL.removeAt(index);
    price.removeAt(index);
    orderComments.removeAt(index);
    priority.removeAt(index);
}



}