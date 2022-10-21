

import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantInfo {

  late var restaurantID;
  late var restaurantName;
  late var tableID;
  late var waiterID;

  setter(String table) async {
    tableID = table;
    //restID
    await FirebaseFirestore.instance.collection('tables').doc(table).get().then(
            (element) {
          restaurantID = element['restID'];
        });
    //restName
    await FirebaseFirestore.instance.collection('restaurants').doc(restaurantID).get().then(
            (element) {
          restaurantID = element['restName'];
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
    tableID = '';
    waiterID = '';
  }




  Future<String> getRestaurantID() async {
    await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(
            (element) {
          restaurantID = element['restID'];
          return restaurantID;
        });
    return "";
    //restName
  }

  Future<String> getRestaurantName() async {
    await FirebaseFirestore.instance.collection('restaurants').doc(restaurantID).get().then(
          (element) {
        restaurantName = element['restName'];
        return restaurantName;
      });
  return "";
  }

  String getTableID(){return tableID.toString();}

  Future<String> getWaiterID() async {
    await FirebaseFirestore.instance.collection('tables').doc(tableID).get().then(
          (element) {
        waiterID = element['waiterID'];
        return waiterID;
      });
  return "";}


}

