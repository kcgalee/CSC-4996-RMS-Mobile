import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_management_system/customer/Models/restaurantInfo.dart';
import 'package:restaurant_management_system/customer/placeOrder.dart';

class CreateOrderInfo extends RestaurantInfo{

  late List<String> itemID = [];
  late List<int> count = [];
  late List<String> itemName= [];
  late List<String> price = [];


  late var custID;

  CreateOrderInfo(this.custID);

  orderSetter(String itemID, int count, String itemName, String price) {
    this.count.add(count);
    this.itemID.add(itemID);
    this.itemName.add(itemName);
    this.price.add(price);
  }

  void placeOrder() {
    for(int i = 0; i < itemName.length; i++) {
      placeOrderHelper(itemID[i], itemName[i], count[i],);
    }

  }//place order

  void placeOrderHelper(String itemID, String itemName, int count,)
  {

    final DateTime now = DateTime.now();
    FirebaseFirestore.instance.collection('orders').add(

    {

        'itemID' : itemID,
        'itemName' : itemName,
        'quantity' :count,
        'restID' : restaurantID,
        'tableID' : tableID,
        'waiterID': waiterID,
        'status' : 'placed',
      'date': Timestamp.fromDate(now),
    });
        FirebaseFirestore.instance.collection('tables/$tableID/tableOrders').add(

        {
          'itemID' : itemID,
          'itemName' : itemName,
          'quantity' :count,
          'restID' : restaurantID,
          'tableID' : tableID,
          'waiterID': waiterID,
          'status' : 'placed',
          'date': Timestamp.fromDate(now),
        }
    );

  }










}