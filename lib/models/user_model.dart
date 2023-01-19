import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String phone;
  String uid;
  late Timestamp date;

  UserModel(
      {required this.name,
      required this.phone,
      required this.uid,
      required this.date});

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(
        name: snapshot['name'],
        phone: snapshot['phone'],
        uid: snapshot['uid'],
        date: snapshot['date']);
  }
}
