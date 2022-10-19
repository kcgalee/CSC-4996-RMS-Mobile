import 'package:cloud_firestore/cloud_firestore.dart';

class CreateOrderInfo {

  late List<String> itemID = [];
  late List<int> count = [];
  late List<String> itemName= [];
  late List<String> price = [];
  late var custID;

  CreateOrderInfo(this.custID);

  setter(String itemID, int count, String name, String price) {
    this.count.add(count);
    this.itemID.add(itemID);
    this.itemName.add(name);
    this.price.add(price);
  }








}