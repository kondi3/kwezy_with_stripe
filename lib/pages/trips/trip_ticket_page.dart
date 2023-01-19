import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';

class TripTicketPage extends StatelessWidget {
  TripTicketPage({
    required this.ticketID,
    required this.dateCreated,
    required this.dateOfDepature,
    required this.from,
    required this.to,
    required this.seatNo,
    required this.timeOfDepature,
    required this.customerName,
    required this.cost,
  });

  String ticketID;
  double cost;
  String customerName;
  Timestamp dateCreated;
  String dateOfDepature;
  String from;
  String to;
  int seatNo;
  String timeOfDepature;

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
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 32, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Booking details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total $cost',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 32),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                margin: const EdgeInsets.fromLTRB(26, 26, 26, 12),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.bus_alert,
                            color: Colors.orange,
                            size: 80,
                          ),
                        ),
                        // Center(
                        //   child: Image.asset(
                        //     'assets/images/companies_logo/gol_logo.png',
                        //   ),
                        // ),
                        const SizedBox(height: 28),
                        Text(
                          dateOfDepature,
                          style: const TextStyle(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text(from),
                                const SizedBox(height: 28),
                                Text(
                                  'To',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text(to),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Depart',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text(timeOfDepature),
                                const SizedBox(height: 28),
                                Text(
                                  'Arrive',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                timeOfDepature == "7:00 AM"
                                    ? const Text('11:30')
                                    : const Text('5:00 PM'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Divider(),
                    const SizedBox(height: 28),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Passenger',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text(
                                  customerName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                const Text(
                                  'COMPLETE',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Seat',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text(
                                  seatNo.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Divider(),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'barccodebarcodeb',
                          style: TextStyle(
                            fontFamily: 'Barcode',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'ticket ID: $ticketID',
                style: TextStyle(
                  color: veppoLightGrey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Downloading'),
            ),
          );
        },
        backgroundColor: veppoBlue,
        child: const Icon(
          Icons.download_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
