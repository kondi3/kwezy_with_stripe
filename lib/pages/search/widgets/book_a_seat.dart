import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kwezy_with_stripe/models/seat_data_model.dart';

class BookSeat extends StatefulWidget {
  const BookSeat({Key? key}) : super(key: key);

  @override
  State<BookSeat> createState() => _BookSeatState();
}

class _BookSeatState extends State<BookSeat> {
  bool isBooked = false;
  // booking a bus
  Future bookBus({
    required String station,
    required String? dateSearched,
    required String destination,
    required String timeOfDepature,
    required String customerId,
    required String customerName,
    required String? transId,
    required double cost,
    required int seatNo,
  }) async {
    // 1. get a document of a specified date + hour of depature
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(station)
        .doc(dateSearched)
        .get();

    // 2. if it exist just add the booking details and update seat details
    if (snapshot.exists) {
      //  adding booking details
      await FirebaseFirestore.instance
          .collection(station)
          .doc(dateSearched)
          .collection(timeOfDepature)
          .doc(destination)
          .collection("bookings")
          .doc(customerId)
          .collection("booking_details")
          .add(
        {
          "transId": transId,
          "from": station,
          "to": destination,
          "date": DateTime.now(),
          "hour": timeOfDepature,
          "customerName": customerName,
          "cost": cost,
          "seatNo": seatNo,
        },
      ).then((value) {
        SeatDataModel seatData = SeatDataModel.fromJson(snapshot);

        // get the totalSeats value
        int totalSeats = seatData.totalSeatsAvailable;
        // get the json for seats
        List<Map<String, dynamic>> seatsjson = seatData.seatJson;

        // update a new seatjson
        seatsjson.elementAt(seatNo - 1).update("available", (value) => false);

        // record the new data
        FirebaseFirestore.instance.collection(station).doc(dateSearched).set({
          "totalAvailableSeats": totalSeats - 1,
          "seats": seatsjson,
        }).whenComplete(() {
          setState(() {
            isBooked = true;
          });
        });
      });
    } else {
      // 3. the document doesn't exist then set it up
      // 3.1 create a seatjson object
      const int totalSeats = 90;
      final seatIndex = seatNo - 1;
      List<Map<String, dynamic>> seats = [];

      for (var index = 0; index < totalSeats - 1; index++) {
        if (seatIndex == index) {
          seats.add({
            "available": false,
          });
        }

        seats.add({
          "available": true,
        });
      }

      if (seats.length == totalSeats - 1) {
        FirebaseFirestore.instance.collection(station).doc(dateSearched).set({
          "totalAvailableSeats": 89,
          "seats": seats,
        }).then((value) {
          // add the booking details
          FirebaseFirestore.instance
              .collection(station)
              .doc(dateSearched)
              .collection(timeOfDepature)
              .doc(destination)
              .collection("bookings")
              .doc(customerId)
              .collection("booking_details")
              .add({
            "transId": transId,
            "from": station,
            "to": destination,
            "date": DateTime.now(),
            "timeOfDepature": timeOfDepature,
            "customerName": customerName,
            "cost": cost,
            "seatNo": seatNo,
          }).whenComplete(() {
            setState(() {
              isBooked = true;
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
