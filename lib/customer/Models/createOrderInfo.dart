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

    FirebaseFirestore.instance.collection('orders').add(
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

        FirebaseFirestore.instance.collection('tables/$_tableID/tableOrders').add(

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

 void request(String request) {

   var uID = FirebaseAuth.instance.currentUser?.uid.toString();
   final DateTime now = DateTime.now();

   FirebaseFirestore.instance.collection('orders').add(
   {
         'custID' : uID.toString(),
         'itemName' : request,
         'restID' : restaurantID,
         'tableID' : tableID,
        'tableNum' : tableNum,
         'waiterID': waiterID,
         'status' : 'placed',
         'timePlaced': Timestamp.fromDate(now),
       }
   );


 }

 void orderClear() {
    itemID.clear();
    itemName.clear();
    price.clear();
    count.clear();
 }



}