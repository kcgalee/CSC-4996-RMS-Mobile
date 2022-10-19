import 'package:cloud_firestore/cloud_firestore.dart';

class CreateOrderInfo {

  late List<String> itemID = [];
  late List<int> count = [];
  late var custID;

  CreateOrderInfo(this.custID);

  setter(String itemID, int count) {
    this.count.add(count);
    this.itemID.add(itemID);
  }








}