import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:kwezy_with_stripe/constants.dart';
import 'package:kwezy_with_stripe/pages/search/search_page.dart';
import 'package:kwezy_with_stripe/pages/trips/ticket_page.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';

class MyselfOrAnother extends StatefulWidget {
  MyselfOrAnother({
    required this.myself,
    required this.customerId,
    required this.customerName,
    required this.station,
    required this.dateSearched,
    required this.dateOfDepature,
    required this.destination,
    required this.timeOfDepature,
    required this.cost,
    required this.seatNo,
    required this.dateOfTicket,
  });
  bool myself;
  String customerId;
  String customerName;
  String? station;
  String? dateSearched;
  String? destination;
  String? timeOfDepature;
  String? dateOfDepature;
  String? dateOfTicket;
  double? cost;
  int seatNo;

  @override
  State<MyselfOrAnother> createState() => _MyselfOrAnotherState();
}

class _MyselfOrAnotherState extends State<MyselfOrAnother> {
  TextEditingController kinNameCtlr = TextEditingController();
  TextEditingController kinPhoneCtlr = TextEditingController();
  TextEditingController anotherCustomerNameCtlr = TextEditingController();
  TextEditingController anotherCustomerPhoneCtlr = TextEditingController();

  Map<String, dynamic>? paymentIntent;

  bool isBooked = false;
  String idTicket = "";
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
    required Map<String, String> nextOfKin,
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
          "dateCreated": DateTime.now(),
          "timeOfDepature": timeOfDepature,
          "dateOfDepature": widget.dateOfDepature,
          "customerName": customerName,
          "cost": cost,
          "seatNo": seatNo,
          "nextOfKin": nextOfKin,
        },
      ).then((value) {
        // get the totalSeats value
        int totalSeats = snapshot['totalAvailableSeats'] as int;
        // get the json for seats
        List<Map<String, dynamic>> seatsjson = (snapshot['seats'] as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();

        // update a new seatjson
        seatsjson.elementAt(seatNo - 1).update("available", (value) => false);

        // record the new data
        FirebaseFirestore.instance.collection(station).doc(dateSearched).set({
          "totalAvailableSeats": totalSeats - 1,
          "seats": seatsjson,
        }).whenComplete(() {
          Random random = new Random();
          String ticketID = "";
          for (var i = 0; i < 14; i++) {
            int randomNumber = random.nextInt(10);
            ticketID += randomNumber.toString();
          }
          setState(() {
            idTicket = ticketID;
          });
          // Create a Ticket
          FirebaseFirestore.instance
              .collection("users")
              .doc(customerId)
              .collection("tickets")
              .add(
            {
              "id": ticketID,
              "from": station,
              "to": destination,
              "dateCreated": DateTime.now(),
              "timeOfDepature": timeOfDepature,
              "dateOfDepature": widget.dateOfTicket, // proper date
              "customerName": customerName,
              "cost": cost,
              "seatNo": seatNo,
            },
          ).then((value) {
            setState(() {
              isBooked = true;
            });
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
            "dateCreated": DateTime.now(),
            "timeOfDepature": timeOfDepature,
            "dateOfDepature": widget.dateOfDepature,
            "customerName": customerName,
            "cost": cost,
            "seatNo": seatNo,
            "nextOfKin": nextOfKin,
          }).whenComplete(() {
            Random random = new Random();
            String ticketID = "";
            for (var i = 0; i < 14; i++) {
              int randomNumber = random.nextInt(10);
              ticketID += randomNumber.toString();
            }
            // Create a Ticket
            FirebaseFirestore.instance
                .collection("users")
                .doc(customerId)
                .collection("tickets")
                .add(
              {
                "id": ticketID,
                "from": station,
                "to": destination,
                "dateCreated": DateTime.now(),
                "timeOfDepature": timeOfDepature,
                "dateOfDepature": widget.dateOfTicket, // proper date
                "customerName": customerName,
                "cost": cost,
                "seatNo": seatNo,
              },
            ).then((value) {
              setState(() {
                isBooked = true;
              });
            });
          });
        });
      }
    }
  }

  Future<Map<String, dynamic>?> makePayment(
      {required String amount,
      required String curr,
      required String desc}) async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD', 'seat no 2');
      print("paymentIntent data : " + paymentIntent.toString());
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                style: ThemeMode.dark,
                merchantDisplayName: 'Kwezy Buses'),
          )
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();

      return paymentIntent;
    } catch (e, s) {
      print('exception:$e$s');
    }

    return {};
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency, String desc) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': desc,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: veppoBlue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            padding: EdgeInsets.fromLTRB(32, 0, 32, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          width: MediaQuery.of(context).size.width,
          child: widget.myself
              ? Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Next of \nkin',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'who should we contact in an emergency?',
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // kin name
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: ListTile(
                        autofocus: true,
                        contentPadding: const EdgeInsets.all(8),
                        leading: const Icon(Icons.person_add),
                        title: TextFormField(
                          autofocus: true,
                          cursorColor: veppoBlue,
                          controller: kinNameCtlr,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // kin phone
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: ListTile(
                        autofocus: true,
                        contentPadding: const EdgeInsets.all(8),
                        leading: const Icon(Icons.contact_phone),
                        title: TextFormField(
                          controller: kinPhoneCtlr,
                          cursorColor: veppoBlue,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),

                    DelayedDisplay(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (kinNameCtlr.text.isNotEmpty &&
                                kinPhoneCtlr.text.isNotEmpty) {
                              Map<String, String> nextOfKin = {
                                "name": kinNameCtlr.text,
                                "phone": kinPhoneCtlr.text,
                              };
                              String desc =
                                  "Seat no ${widget.seatNo.toString()}";
                              // Process payment & get paymentId
                              final paymentDetails = await makePayment(
                                      amount: widget.cost.toString(),
                                      curr: 'USD',
                                      desc: desc)
                                  .then((value) {});

                              String paymentId = paymentDetails!['id'];

                              // save to transaction table
                              await FirebaseFirestore.instance
                                  .collection("payments")
                                  .add({
                                "id": paymentDetails!['id'],
                                "amount": paymentDetails['amount'],
                                "description": [
                                  {
                                    "station": widget.station,
                                    "destination": widget.destination,
                                  }
                                ],
                                "payerName": widget.customerName,
                                "payerId": widget.customerId,
                                "date": paymentDetails['created'],
                              }).then((value) {
                                // Save to database
                                bookBus(
                                        station: widget.station as String,
                                        dateSearched: widget.dateSearched,
                                        destination:
                                            widget.destination as String,
                                        timeOfDepature:
                                            widget.timeOfDepature as String,
                                        customerId: widget.customerId,
                                        customerName: widget.customerName,
                                        transId: paymentId,
                                        cost: widget.cost as double,
                                        seatNo: widget.seatNo,
                                        nextOfKin: nextOfKin)
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Booked Successfully'),
                                    ),
                                  );
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TicketPage(
                                      ticketID: idTicket,
                                      cost: widget.cost as double,
                                      customerName: widget.customerName,
                                      dateCreated: Timestamp.fromDate(
                                        DateTime.now(),
                                      ),
                                      dateOfDepature:
                                          widget.dateOfTicket as String,
                                      from: widget.station as String,
                                      to: widget.destination as String,
                                      seatNo: widget.seatNo,
                                      timeOfDepature:
                                          widget.timeOfDepature as String,
                                    ),
                                  ),
                                );
                              }, onError: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Something went wrong' + e.toString(),
                                    ),
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchPage(),
                                  ),
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Fill in all the fields.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return veppoLightGrey;
                                return veppoBlue;
                              },
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Text(
                              'Process payment',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    // customer name
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: ListTile(
                        autofocus: true,
                        contentPadding: EdgeInsets.all(8),
                        leading: Icon(Icons.person_add),
                        title: TextFormField(
                          autofocus: true,
                          cursorColor: veppoBlue,
                          controller: anotherCustomerNameCtlr,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // customer name
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: ListTile(
                        autofocus: true,
                        contentPadding: EdgeInsets.all(8),
                        leading: const Icon(Icons.contact_phone),
                        title: TextFormField(
                          cursorColor: veppoBlue,
                          controller: anotherCustomerPhoneCtlr,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone Number",
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next of \nkin',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'who should we contact in an emergency?',
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // kin name
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: ListTile(
                        autofocus: true,
                        contentPadding: EdgeInsets.all(8),
                        leading: Icon(Icons.person_add),
                        title: TextFormField(
                          autofocus: true,
                          cursorColor: veppoBlue,
                          controller: kinNameCtlr,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // kin phone
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: ListTile(
                        autofocus: true,
                        contentPadding: EdgeInsets.all(8),
                        leading: Icon(Icons.contact_phone),
                        title: TextFormField(
                          autofocus: true,
                          cursorColor: veppoBlue,
                          controller: kinPhoneCtlr,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone Number",
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),

                    DelayedDisplay(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            if (kinNameCtlr.text.isNotEmpty &&
                                kinPhoneCtlr.text.isNotEmpty &&
                                anotherCustomerNameCtlr.text.isNotEmpty &&
                                anotherCustomerPhoneCtlr.text.isNotEmpty) {
                              Map<String, String> nextOfKin = {
                                "name": kinNameCtlr.text,
                                "phone": kinPhoneCtlr.text,
                              };
                              // Process payment & get paymentId
                              String paymentId = "kahsdbchsdbjhbfva";

                              // Save to database
                              bookBus(
                                station: widget.station as String,
                                dateSearched: widget.dateSearched,
                                destination: widget.destination as String,
                                timeOfDepature: widget.timeOfDepature as String,
                                customerId: widget.customerId,
                                customerName: anotherCustomerNameCtlr.text,
                                transId: paymentId,
                                cost: widget.cost as double,
                                seatNo: widget.seatNo,
                                nextOfKin: nextOfKin,
                              ).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Booked Successfully'),
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TicketPage(
                                      ticketID: idTicket,
                                      cost: widget.cost as double,
                                      customerName:
                                          anotherCustomerNameCtlr.text,
                                      dateCreated: Timestamp.fromDate(
                                        DateTime.now(),
                                      ),
                                      dateOfDepature:
                                          widget.dateOfTicket as String,
                                      from: widget.station as String,
                                      to: widget.destination as String,
                                      seatNo: widget.seatNo,
                                      timeOfDepature:
                                          widget.timeOfDepature as String,
                                    ),
                                  ),
                                );
                              }, onError: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Something went wrong' + e.toString(),
                                    ),
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchPage(),
                                  ),
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Fill in all the fields.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return veppoLightGrey;
                                return veppoBlue;
                              },
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Text(
                              'Proceed to payment',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
