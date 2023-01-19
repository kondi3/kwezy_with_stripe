import 'package:kwezy_with_stripe/models/bus_model.dart';
import 'package:kwezy_with_stripe/pages/search/seats_grid_page.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBus extends StatefulWidget {
  @override
  _SearchBusState createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> with TickerProviderStateMixin {
  _SearchBusState() {
    _selectedVal = _routeNames[0];
    _selectedVal2 = _routeNames[1];
    _selectedTime = _departureTime[0];
    selectedDate = DateTime.now().day.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().year.toString();
    dateOfTicket =
        DateTime.now().day.toString() + " " + _getMonth(DateTime.now());
  }
  final PageController _cardController = PageController(initialPage: 0);

  final _routeNames = [
    "Mzuzu",
    "Lilongwe",
    "Blantyre",
    "Zomba",
  ];

  // get month name from month no. or index
  String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  String? _selectedVal = "";
  String? _selectedVal2 = "";
  String? _selectedTime = "";
  String selectedDate = "";
  String dateOfTicket = "";

  final _departureTime = [
    "7:00 AM",
    "12:00 NOON",
  ];

  @override
  dispose() {
    super.dispose();
    _cardController.dispose();
  }

  bool isBooked = false;
  bool isLoading = false;
  // 1. Searching a bus
  Future<List<Map<String, dynamic>>> searchBus({
    required String station,
    required String? dateSearched,
  }) async {
    // 1. get a document of a specified date + hour of depature
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(station)
        .doc(dateSearched)
        .get();

    // check if the doc exists
    if (snapshot.exists) {
      // check is seats are available
      final seatJson = (snapshot["seats"] as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
      final int totalSeatsAvailable = snapshot["totalAvailableSeats"] as int;
      // SeatDataModel busData = SeatDataModel.fromJson(snapshot);

      if (totalSeatsAvailable > 0) {
        // bus is available return the seat chart
        return seatJson;
      }
      // seats are full, bus is unavailable
      return [];
    } else {
      // create the document
      const int totalSeats = 90;
      List<Map<String, dynamic>> seats = [];

      for (var index = 0; index < totalSeats; index++) {
        seats.add({
          "available": true,
        });
      }

      FirebaseFirestore.instance.collection(station).doc(dateSearched).set({
        "totalAvailableSeats": totalSeats,
        "seats": seats,
      }).then((value) {});

      return seats;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 40, 16, 18),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(
        //   Radius.circular(16),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     spreadRadius: 2,
        //     blurRadius: 4,
        //   )
        // ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.bus_alert,
                color: Colors.orange,
              ),
              const SizedBox(width: 16),
              Container(
                color: veppoLightGrey,
                height: 32,
                width: 1,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select',
                    style: TextStyle(
                      color: veppoLightGrey,
                    ),
                  ),
                  Text(
                    'Travel Destination + Date',
                    style: TextStyle(
                      color: veppoLightGrey,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: Colors.grey[100],
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Container(
                  child: DropdownButtonFormField(
                    value: _selectedVal,
                    items: _routeNames
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedVal = val as String;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: veppoBlue,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Traveling From",
                      labelStyle: TextStyle(color: Colors.black38),
                      prefixIcon:
                          Icon(Icons.bus_alert_rounded, color: Colors.black38),
                      // border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  child: DropdownButtonFormField(
                    value: _selectedVal2,
                    items: _routeNames
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedVal2 = val as String;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: veppoBlue,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Traveling To",
                      labelStyle: TextStyle(color: Colors.black38),
                      prefixIcon:
                          Icon(Icons.bus_alert_rounded, color: Colors.black38),
                      // border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                          2023,
                        ),
                        lastDate: DateTime(2050),
                      );

                      if (date != null) {
                        String day = '${date.day}';
                        String month = '${date.month}';
                        String year = '${date.year}';

                        setState(() {
                          dateOfTicket = day + " " + _getMonth(date);
                          selectedDate = day + "-" + month + "-" + year;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.orange,
                      size: 35,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 60,
              ),
              Expanded(
                child: DropdownButtonFormField(
                  value: _selectedTime,
                  items: _departureTime
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedTime = val as String;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: veppoBlue,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return veppoLightGrey;
                          return veppoBlue;
                        },
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : DelayedDisplay(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        String docSearched =
                            selectedDate + " " + _selectedTime!;

                        final res = await searchBus(
                            station: _selectedVal!, dateSearched: docSearched);

                        if (res.isNotEmpty) {
                          // bus is available
                          // Get the route cost from route table
                          final busDetails = {
                            "from": _selectedVal,
                            "to": _selectedVal2,
                            "timeOfDepature": _selectedTime,
                            "cost": 20000,
                            "seats": res,
                          };

                          BusModel bus = BusModel.fromMap(busDetails);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatsGridPage(
                                bus: bus,
                                dateAndTime: docSearched,
                                dateOfDepature: selectedDate,
                                dateOfTicket: dateOfTicket,
                              ),
                            ),
                          );

                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('The bus is full'),
                              backgroundColor: Colors.orange,
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
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
