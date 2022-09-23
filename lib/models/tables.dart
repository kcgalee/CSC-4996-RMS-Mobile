import 'package:cloud_firestore/cloud_firestore.dart';

class Table {
  String id;
  String description;
  String type;
  String waiterUID;
  String customerUID;
  bool available;
  bool outside;
  bool smoking;
  int capacity;

  Table({
    this.id = '',
    required this.description,
    required this.type,
    required this.waiterUID,
    required this.customerUID,
    required this.available,
    required this.outside,
    required this.smoking,
    required this.capacity
  });


  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'type': type,
    'waiterUID': waiterUID,
    'customerUID': customerUID,
    'available': available,
    'outside': outside,
    'smoking': smoking,
    'capacity': capacity,
  };

  static Table fromJson(Map<String, dynamic> json) => Table (
    id: json['id'],
    description: json['description'],
    type: json['type'],
    waiterUID: json['waiterUID'],
    customerUID: json['customerUID'],
    available: json['available'],
    outside: json['outside'],
    smoking: json['smoking'],
    capacity: json['capacity'],
  );

}
