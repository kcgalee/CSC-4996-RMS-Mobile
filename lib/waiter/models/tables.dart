import 'package:cloud_firestore/cloud_firestore.dart';

class TablesFB {
  final String? id;
  final String? restaurantUID;
  final String? description;
  final String? type;
  final String? waiterUID;
  final bool? available;
  final bool? outside;
  final bool? smoking;
  final int? capacity;

  TablesFB({
    this.id,
    this.restaurantUID,
    this.description,
    this.type,
    this.waiterUID,
    this.available,
    this.outside,
    this.smoking,
    this.capacity
  });

  factory TablesFB.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return TablesFB(
      id: data?['id'],
      restaurantUID: data?['restaurantUID'],
      description: data?['description'],
      type: data?['type'],
      waiterUID: data?['waiterUID'],
      available: data?['available'],
      outside: data?['outside'],
      smoking: data?['smoking'],
      capacity: data?['capacity'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (restaurantUID != null) "restaurant": restaurantUID,
      if (description != null) "description": description,
      if (type != null) "type": type,
      if (waiterUID != null) "waiterUID": waiterUID,
      if (available != null) "available": available,
      if (outside != null) "outside": outside,
      if (smoking != null) "smoking": smoking,
      if (capacity != null) "capacity": capacity,
    };
  }
}