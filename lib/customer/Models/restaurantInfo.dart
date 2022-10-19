

import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantInfo {

  late var restaurantID;
  late var restaurantName;
  late var tableId;
  late var waiterID;

  setter(String table) async {
    tableId = table;
    //restID
    await FirebaseFirestore.instance.collection('tables').doc(table).get().then(
            (element) {
          restaurantID = element['restaurantID'];
        });
    //restName
    await FirebaseFirestore.instance.collection('restaurants').doc(restaurantID).get().then(
            (element) {
          restaurantID = element['restaurantName'];
        });

    print(restaurantID);
    await FirebaseFirestore.instance.collection('tables').doc(table).get().then(
            (element) {
         waiterID = element['waiterID'];
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

