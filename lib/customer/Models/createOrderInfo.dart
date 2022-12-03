import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
This page handles all the items added to an order by the current user.
 */

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
  late List<String> category = [];
  late List<int> priority = [];

  //initializer
  CreateOrderInfo(this.custID){
   itemCount = 0;
  }

  //orderSetter added an item to the object from the showMenuItems page
  orderSetter(String itemID, int count, String itemName, String price,
      String comments, int priority, String imgURL, String category) async {
    this.count.add(count);
    this.itemID.add(itemID);
    this.imgURL.add(imgURL);
    this.itemName.add(itemName);
    this.price.add(price);
    orderComments.add(comments);
    this.category.add(category);
    this.priority.add(priority);

    itemCount++;

    //get user's first name
    await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
            (element) {
          custName = element['fName'];
        });
  }

  //when the order is placed from viewOrder, this method iterates through all the
  //orders in the object and adds them to the tableOrders and orders document
  void placeOrder(String tableID, String tableNum, String waiterID, String restID) {
    for(int i = 0; i < itemCount; i++) {

      //passes the index of order to add to the order and tableMembers collection
      placeOrderHelper(itemID[i], itemName[i], count[i], price[i],
          orderComments[i], priority[i], tableID,
          tableNum, waiterID, restID, imgURL[i], category[i]);
    }
    orderClear();
  }//place order

  //gets the order index from placeOrder
  void placeOrderHelper(String itemID, String itemName, int count, String price,
      String comments, int priority, String tableID, String tableNum,
      String waiterID, String restID, String imgURL, String category)
  {

    //gets user UID
    var uID = FirebaseAuth.instance.currentUser?.uid.toString();
    //gets date time
    final DateTime now = DateTime.now();

    //create a collection ref for the order collection
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');

    //get the documentID of the order to be used when adding the order
    //to the tableMembers class, orderID must be the same.
    String orderID = orders
        .doc()
        .id
        .toString()
        .trim();

    //adds order to the orders document
    orders.doc(orderID).set(
    {
      'tableClosed' : false,
      'itemCategory' : category,
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
      'timeDelivered' : Timestamp.fromDate(now),
      'waiterID': waiterID,
        'status' : 'placed',
      'timePlaced': Timestamp.fromDate(now),
    }
    );

    //adds order to the tableOrders collection
       FirebaseFirestore.instance.collection('tables/$tableID/tableOrders').doc(orderID)

            .set(

        {
          'imgURL' : imgURL,
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

  //sends a waiter request to the orders and table orders doc
 Future<void> request(String request, String tableID, String tableNum, String waiterID, String restID) async {
    //get user uid
   var uID = FirebaseAuth.instance.currentUser?.uid.toString();
   //get date time
   final DateTime now = DateTime.now();

   //get user first name
   await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
           (element) {
         custName = element['fName'];
       });

   //create a collection ref for the orders collection
   CollectionReference orders = FirebaseFirestore.instance.collection('orders');

   //get the documentID of the order to be used when adding the order
   //to the tableMembers class, orderID must be the same.
   String orderID = orders
       .doc()
       .id
       .toString()
       .trim();

   //send order to the orders collection
   orders.doc(orderID).set(
   {
     'tableClosed' : false,
        'orderComment' : '',
        'custName' : custName,
         'custID' : uID.toString(),
         'itemName' : request,
         'restID' : restID,
         'tableID' : tableID,
        'tableNum' : tableNum,
     'timeDelivered' : Timestamp.fromDate(now),
     'waiterID': waiterID,
         'status' : 'placed',
         'timePlaced': Timestamp.fromDate(now),
          'price' : '0.00',
         'quantity' : 1,
        'priority' : 1
       }
   );

   //send order to the tableOrders collection
   FirebaseFirestore.instance.collection('tables/$tableID/tableOrders').doc(orderID).set(
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

   //make field waiterRequested in table doc true so waiter can not be requested
   //multiple times before delivering the request
   FirebaseFirestore.instance.collection('tables').doc(tableID).update(
     {
     'waiterRequested' : true
     }
   );

 }
  Future<void> billRequest(String request, String tableID, String tableNum, String waiterID, String restID) async {

    //get user uid
    var uID = FirebaseAuth.instance.currentUser?.uid.toString();
    //get date
    final DateTime now = DateTime.now();

    //get cust name
    await FirebaseFirestore.instance.collection('users').doc(custID).get().then(
            (element) {
          custName = element['fName'];
        });

    //create collection ref for orders collection
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');

    //get the documentID of the order to be used when adding the order
    //to the tableMembers class, orderID must be the same.
    String orderID = orders
        .doc()
        .id
        .toString()
        .trim();

    //add order the orders collection
    orders.doc(orderID).set(
        {
          'tableClosed' : false,
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
          'timeDelivered' : Timestamp.fromDate(now),
          'price' : '0.00',
          'quantity' : 1
        }
    );

    //add order to the tableOrders collection
    FirebaseFirestore.instance.collection('tables/$tableID/tableOrders').doc(orderID).set(
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

    //make field billRequested true in tables doc so bill can only be requested once
    FirebaseFirestore.instance.collection('tables').doc(tableID).update({
      'billRequested' : true,
    });



  }

  //clears the object of all orders
 void orderClear() {
    itemID.clear();
    itemName.clear();
    price.clear();
    count.clear();
    orderComments.clear();
    imgURL.clear();
    priority.clear();
    itemCount = 0;
    category.clear();
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
    category.removeAt(index);
}

//updates order from viewOrder page
  updateOrder(int index, int count, String price, String comment) {
    this.price[index] = price;
    this.count[index] = count;
    orderComments[index] = comment;
  }


}