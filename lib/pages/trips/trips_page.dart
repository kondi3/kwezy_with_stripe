import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwezy_with_stripe/pages/trips/trip_ticket_page.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  TripsPage() {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final id = _auth.currentUser!.uid;

    Future getName({required String id}) async {
      var user =
          await FirebaseFirestore.instance.collection("users").doc(id).get();

      customerName = user['name'] as String;
    }

    customerId = id;
  }
  String? customerId;
  String? customerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(customerId)
              .collection("tickets")
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return const Center(
                  child: Text("No trips yet."),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Timestamp dateOfCreation =
                          snapshot.data.docs[index]['dateCreated'];
                      DateTime createdOn = dateOfCreation.toDate();

                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       // padding: EdgeInsets.all(6),
                            //       margin:
                            //           const EdgeInsets.fromLTRB(26, 6, 26, 3),
                            //       child: Text(
                            //         createdOn.toString(),
                            //         style: TextStyle(fontSize: 12),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TripTicketPage(
                                      ticketID: snapshot.data.docs[index]['id'],
                                      from: snapshot.data.docs[index]['from'],
                                      dateCreated: snapshot.data.docs[index]
                                          ['dateCreated'],
                                      dateOfDepature: snapshot.data.docs[index]
                                          ['dateOfDepature'],
                                      seatNo: snapshot.data.docs[index]
                                          ['seatNo'],
                                      timeOfDepature: snapshot.data.docs[index]
                                          ['timeOfDepature'],
                                      to: snapshot.data.docs[index]['to'],
                                      customerName: customerName!,
                                      cost: snapshot.data.docs[index]['cost']
                                          as double,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(26),
                                margin:
                                    const EdgeInsets.fromLTRB(26, 26, 26, 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Icon(
                                            Icons.bus_alert,
                                            color: Colors.orange,
                                            size: 60,
                                          ),
                                        ),
                                        // Center(
                                        //   child: Image.asset(
                                        //     'assets/images/companies_logo/gol_logo.png',
                                        //   ),
                                        // ),
                                        const SizedBox(height: 28),
                                        Text(
                                          snapshot.data.docs[index]
                                              ['dateOfDepature'],
                                          style: const TextStyle(
                                            fontSize: 32,
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'From',
                                                  style: TextStyle(
                                                      color: veppoLightGrey),
                                                ),
                                                Text(snapshot.data.docs[index]
                                                    ['from']),
                                                const SizedBox(height: 28),
                                                Text(
                                                  'To',
                                                  style: TextStyle(
                                                      color: veppoLightGrey),
                                                ),
                                                Text(snapshot.data.docs[index]
                                                    ['to']),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Depart',
                                                  style: TextStyle(
                                                      color: veppoLightGrey),
                                                ),
                                                Text(snapshot.data.docs[index]
                                                    ['timeOfDepature']),
                                                const SizedBox(height: 28),
                                                Text(
                                                  'Arrive',
                                                  style: TextStyle(
                                                      color: veppoLightGrey),
                                                ),
                                                snapshot.data.docs[index][
                                                            'timeOfDepature'] ==
                                                        "7:00 AM"
                                                    ? const Text('11:30 AM')
                                                    : const Text('5:00 PM'),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            } else {
              return const Center(
                child: Text('Trips data loading...'),
              );
            }
          }),
    );
  }
}
