import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  addNewUser(String? phone, String name) async {
    final id = _auth.currentUser!.uid;

    var user =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (!user.exists) {
      await FirebaseFirestore.instance.collection("users").doc(id).set({
        "name": name,
        "phone": phone,
      });
    }
  }

  updateUserProfile(String name) async {
    final id = _auth.currentUser!.uid;

    var user =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (user.exists) {
      await FirebaseFirestore.instance.collection("users").doc(id).set({
        "name": name,
      });
    }
  }
}
