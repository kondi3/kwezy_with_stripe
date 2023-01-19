import 'package:cloud_firestore/cloud_firestore.dart';

class SeatDataModel {
  int totalSeatsAvailable;
  List<Map<String, dynamic>> seatJson;

  SeatDataModel({required this.totalSeatsAvailable, required this.seatJson});

  factory SeatDataModel.fromJson(DocumentSnapshot<Object?> snapshot) {
    return SeatDataModel(
      totalSeatsAvailable: snapshot["totalAvailableSeats"] as int,
      seatJson: snapshot["seats"],
    );
  }
}
