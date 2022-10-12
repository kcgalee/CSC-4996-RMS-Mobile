import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantInfo {

  late var restaurantID;
  late var restaurantName;
  late var tableId;

  setter(String table) {
    tableId = table;
    restaurantID = getRestaurantId();
    restaurantName = getRestaurantName();
  }

  Future<String> getRestaurantName() async {
    final docRef2 = FirebaseFirestore.instance.collection('restaurants').doc(restaurantID);
    await docRef2.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          return ['restName'].toString().trim();
        });
    return '';
  }

  Future<String> getRestaurantId() async {
    final docRef2 = FirebaseFirestore.instance.collection('table').doc(tableId);
    await docRef2.get().then(
            (DocumentSnapshot doc){
          final data = doc.data() as Map<String, dynamic>;
          return ['restID'].toString().trim();
        });
    return '';
  }




}

