

import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantInfo {

  late var restaurantID;
  late var restaurantName;
  late var tableId;
  late var waiterID;

  setter(String table) async {
    tableId = table;
    //restID
    final docRef = FirebaseFirestore.instance.collection('tables').doc(tableId);
    await docRef.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          restaurantID = data['restID'].toString().trim();
        });
    //restName
    final docRef2 = FirebaseFirestore.instance.collection('restaurants').doc(restaurantID);
    await docRef2.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          print(data['restName']);
          restaurantName = data['restName'];
        });
    print(restaurantID);
    final docRef3 = FirebaseFirestore.instance.collection('tables').doc(tableId);
    await docRef3.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;

          waiterID = data['waiterID'].toString().trim();
        });
  }

  RestaurantInfo() {
    restaurantID = '';
    restaurantName = '';
    tableId = '';
    waiterID = '';
  }




  String getRestaurantName() {
    return restaurantName.text.toString();
  }

  String getRestaurantID(){return restaurantID.toString();}

  String getTableID(){return tableId.toString();}

  String getWaiterID(){return waiterID.toString();}


}

