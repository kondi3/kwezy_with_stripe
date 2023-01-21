import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwezy_with_stripe/models/bus_model.dart';
import 'package:kwezy_with_stripe/pages/search/payment_booking_details.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

class SeatsGridPage extends StatefulWidget {
  SeatsGridPage({
    this.bus,
    this.dateAndTime,
    this.dateOfDepature,
    required this.dateOfTicket,
  });
  final BusModel? bus;
  final String? dateAndTime;
  final String? dateOfDepature;
  final String? dateOfTicket;

  @override
  _SeatsGridPageState createState() => _SeatsGridPageState();
}

class _SeatsGridPageState extends State<SeatsGridPage> {
  int seatSelected = -1;

  String? customerId;
  String? customerName;

  Future<String> getName({required String id}) async {
    var user =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    final name = user['name'] as String;
    return name;
  }

  @override
  void initState() {
    // TODO: implement initState
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final id = _auth.currentUser!.uid;

    setState(() async {
      String customerNem = await getName(id: id);

      customerName = customerNem;
      customerId = id;
    });
    super.initState();
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'from ${widget.bus!.from}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'to ${widget.bus!.to}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    seatSelected < 0
                        ? const Text(
                            'Select Your Seat(s)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            'You\'ve Selected ${seatSelected + 1} Seat(s)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                    const SizedBox(height: 8),
                    seatSelected > 0
                        ? Text(
                            'Total MK ${widget.bus!.cost!}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        : Text(
                            'Each ${widget.bus!.cost}',
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
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DelayedDisplay(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: EdgeInsets.fromLTRB(64, 16, 64, 16),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Spacer(),
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              border: Border.all(color: veppoBlue, width: 2),
                            ),
                          ),
                          Spacer(flex: 2),
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              border: Border.all(color: veppoBlue, width: 2),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          border: Border.all(color: veppoBlue, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: GridView.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                            children: widget.bus!.seats!
                                .asMap()
                                .map((index, element) {
                                  return MapEntry(
                                    index,
                                    InkWell(
                                      onTap: () {
                                        if (element.available) {
                                          setState(() {
                                            seatSelected = index;
                                            // seatSelected.add(index);
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Seat is already booked'),
                                              backgroundColor: Colors.red,
                                              duration: Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(16),
                                        child: Image.asset(
                                          seatSelected == index
                                              ? 'assets/images/seats/seat_3.jpg'
                                              : element.available!
                                                  ? 'assets/images/seats/seat_1.jpg'
                                                  : 'assets/images/seats/seat_2.jpg',
                                          width: 28,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/seats/seat_1.jpg',
                      width: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'available',
                      style: TextStyle(
                        color: veppoLightGrey,
                      ),
                    ),
                    SizedBox(width: 12),
                    Image.asset(
                      'assets/images/seats/seat_2.jpg',
                      width: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'booked',
                      style: TextStyle(
                        color: veppoLightGrey,
                      ),
                    ),
                    SizedBox(width: 12),
                    Image.asset(
                      'assets/images/seats/seat_3.jpg',
                      width: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'select',
                      style: TextStyle(
                        color: veppoLightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              seatSelected >= 0
                  ? DelayedDisplay(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            int temp = seatSelected;
                            setState(() {
                              seatSelected = -1;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PaymentBookingDetails(
                                  customerId: customerId!,
                                  customerName: customerName!,
                                  selectedSeat: temp,
                                  bus: widget.bus,
                                  dateSearched: widget.dateAndTime,
                                  dateofDepature: widget.dateOfDepature,
                                  dateOfTicket: widget.dateOfTicket,
                                ),
                              ),
                            );
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
                              'Next step',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
