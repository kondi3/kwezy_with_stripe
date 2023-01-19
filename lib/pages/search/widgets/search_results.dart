import 'package:kwezy_with_stripe/providers/bus_provider.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  PageController _cardController = PageController(initialPage: 0);
  int currentIndex = 0;
  bool direct = true;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: busesAvailable.length,
      itemBuilder: (context, index) {
        return DelayedDisplay(
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: MediaQuery.of(context).size.width * .8,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: MediaQuery.of(context).size.height * .3),
                      // height: MediaQuery.of(context).size.height * .2,
                      child: Card(
                        child: ListTile(
                          trailing: GestureDetector(
                            onTap: () {
                              final dateSelected = showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2050),
                                confirmText: 'Ok',
                                cancelText: 'Cancel',
                              );
                            },
                            child: Icon(Icons.calendar_month_outlined),
                          ),
                          title: Text('Select date'),
                        ),
                      ),
                    );
                  });
              setState(() {
                currentIndex = index;
              });
            },
            child: Container(
              height: 134,
              margin: EdgeInsets.fromLTRB(
                  16, 0, 16, index == busesAvailable.length - 1 ? 80 : 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bus_alert,
                        color: Colors.orange,
                      ),
                      // Image.asset(
                      //   busesAvailable[index].logo!,
                      //   width: 64,
                      // ),
                      Spacer(),
                      Text(
                        '11:30',
                        style: TextStyle(
                          color: Colors.grey[900],
                        ),
                      ),
                      SizedBox(width: 16),
                      direct
                          ? Column(
                              children: [
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: veppoBlue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      color: veppoBlue,
                                      height: 1,
                                      width: 50,
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: veppoBlue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'direct',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: veppoBlue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      color: veppoBlue,
                                      height: 1,
                                      width: 20,
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      color: veppoBlue,
                                      height: 1,
                                      width: 20,
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: veppoBlue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'semi-direct',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(width: 16),
                      Text(
                        '11:30',
                        style: TextStyle(
                          color: veppoLightGrey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Divider(),
                  Container(
                    height: 32,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Text(
                          'Mzuzu To Blantyre',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'MK 20,000',
                          style: TextStyle(
                            color: veppoBlue,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
