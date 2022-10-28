import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateOrderInfo{

  late List<String> itemID = [];
  late List<int> count = [];
  late List<String> itemName= [];
  late List<String> price = [];
  late int itemCount;
  late var custName;
  late var custID;

  CreateOrderInfo(this.custID){
   itemCount = 0;
  }

  orderSetter(String itemID, int count, String itemName, String price) async {
    this.count.add(count);
    this.itemID.add(itemID);
    this.itemName.add(itemName);
    this.price.add(price);
    this.itemCount++;

    await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
            (element) {
          custName = element['fName'];
        });
  }

  void placeOrder(String tableID, String tableNum, String waiterID, String restID) {
    for(int i = 0; i < itemCount; i++) {
      placeOrderHelper(itemID[i], itemName[i], count[i], price[i], tableID, tableNum, waiterID, restID);
    }
    orderClear();
  }//place order

  void placeOrderHelper(String itemID, String itemName, int count, String price,
  String tableID, String tableNum, String waiterID, String restID)
  {
    print("HELPER");
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

   FirebaseFirestore.instance.collection('tables/$tableID/tableOrders').add(
       {
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



}