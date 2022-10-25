import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_management_system/customer/Models/restaurantInfo.dart';

class CreateOrderInfo extends RestaurantInfo{

  late List<String> itemID = [];
  late List<int> count = [];
  late List<String> itemName= [];
  late List<String> price = [];
  late var custName;
  late var custID;

  CreateOrderInfo(this.custID);

  orderSetter(String itemID, int count, String itemName, String price) async {
    this.count.add(count);
    this.itemID.add(itemID);
    this.itemName.add(itemName);
    this.price.add(price);

    await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
            (element) {
          custName = element['fName'];
        });
  }

  void placeOrder(String _tableID, String restID) {
    for(int i = 0; i < itemName.length; i++) {
      placeOrderHelper(itemID[i], itemName[i], count[i], price[i], _tableID, restID);
    }

  }//place order

  void placeOrderHelper(String itemID, String itemName, int count, String price, String _tableID, String restID)
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
        'price' : price,
        'custName' : custName,
        'custID' : uID.toString(),
        'itemID' : itemID,
        'itemName' : itemName,
        'quantity' :count,
        'tableNum' : tableNum,
        'restID' : super.restaurantID,
        'tableID' : _tableID,
        'waiterID': waiterID,
        'status' : 'placed',
      'timePlaced': Timestamp.fromDate(now),
    }
    );

       FirebaseFirestore.instance.collection('tables/$_tableID/tableOrders').doc(orderID)

            .set(

        {
          'price' : price,
          'custName' : custName,
          'custID' : uID.toString(),
          'itemID' : itemID,
          'itemName' : itemName,
          'quantity' : count,
          'tableNum' : tableNum,
          'restID' : super.restaurantID,
          'tableID' : _tableID,
          'waiterID': waiterID,
          'status' : 'placed',
          'timePlaced': Timestamp.fromDate(now),
        }
    );

  orderClear();
  }

 Future<void> request(String request, String _tableID) async {

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
         'restID' : restaurantID,
         'tableID' : _tableID,
        'tableNum' : tableNum,
         'waiterID': waiterID,
         'status' : 'placed',
         'timePlaced': Timestamp.fromDate(now),
          'price' : '0.00',
         'quantity' : 1
       }
   );

   FirebaseFirestore.instance.collection('tables/$_tableID/tableOrders').add(
       {
         'custName' : custName,
         'custID' : uID.toString(),
         'itemName' : request,
         'restID' : restaurantID,
         'tableID' : _tableID,
         'tableNum' : tableNum,
         'waiterID': waiterID,
         'status' : 'placed',
         'timePlaced': Timestamp.fromDate(now),
         'price' : '0.00',
         'quantity' : 1
       }
   );


 }
  Future<void> billRequest(String request, String _tableID) async {

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
          'restID' : restaurantID,
          'tableID' : _tableID,
          'tableNum' : tableNum,
          'waiterID': waiterID,
          'status' : 'placed',
          'timePlaced': Timestamp.fromDate(now),
          'price' : '0.00',
          'quantity' : 1
        }
    );

    FirebaseFirestore.instance.collection('tables').doc(_tableID).update({
      'billRequested' : true,
    });



  }
 void orderClear() {
    itemID.clear();
    itemName.clear();
    price.clear();
    count.clear();
 }



}