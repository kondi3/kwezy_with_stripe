import 'package:kwezy_with_stripe/models/bus_model.dart';
import 'package:kwezy_with_stripe/pages/search/widgets/myself.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

class PaymentBookingDetails extends StatefulWidget {
  PaymentBookingDetails({
    required this.selectedSeat,
    required this.customerId,
    required this.customerName,
    required this.dateOfTicket,
    this.bus,
    this.dateSearched,
    this.dateofDepature,
  });

  final BusModel? bus;
  final String? dateSearched;
  final String? dateofDepature;
  final String? dateOfTicket;
  final int selectedSeat;
  final String customerId;
  final String customerName;

  TextEditingController nextCustomerName = TextEditingController();

  @override
  _PaymentBookingDetailsState createState() => _PaymentBookingDetailsState();
}

class _PaymentBookingDetailsState extends State<PaymentBookingDetails> {
  bool myself = false;
  bool anotherPerson = false;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('This seat is for?'),
                  ],
                ),
              ),
              DelayedDisplay(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   widget.selectedSeats.clear();
                      // });
                      // int seatNo = widget.selectedSeats[0];
                      // print(widget.selectedSeats[0]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MyselfOrAnother(
                            myself: true,
                            customerId: widget.customerId,
                            customerName: widget.customerName,
                            station: widget.bus!.from,
                            dateSearched: widget.dateSearched,
                            destination: widget.bus!.to,
                            timeOfDepature: widget.bus!.timeOfDepature,
                            cost: widget.bus!.cost,
                            seatNo: 2,
                            dateOfDepature: widget.dateofDepature,
                            dateOfTicket: widget.dateOfTicket,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                        'Myself',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              DelayedDisplay(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   widget.selectedSeats.clear();
                      // });
                      int seatNo = widget.selectedSeat + 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MyselfOrAnother(
                            myself: false,
                            customerId: widget.customerId,
                            customerName: widget.customerName,
                            cost: widget.bus!.cost,
                            dateSearched: widget.dateSearched,
                            destination: widget.bus!.to,
                            seatNo: seatNo,
                            station: widget.bus!.from,
                            timeOfDepature: widget.bus!.timeOfDepature,
                            dateOfDepature: widget.dateofDepature,
                            dateOfTicket: widget.dateOfTicket,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                        'Another Person',
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
