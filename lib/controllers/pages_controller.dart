// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwezy_with_stripe/pages/search/search_page.dart';
import 'package:kwezy_with_stripe/pages/trips/trips_page.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';

class PagesController extends StatefulWidget {
  @override
  _PagesControllerState createState() => _PagesControllerState();
}

class _PagesControllerState extends State<PagesController> {
  PageController _pageController = PageController(initialPage: 0);
  int bottomNavigationIndex = 0;

  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          SearchPage(),
          TripsPage(),
          Container(
            child: Center(
              child: Text('Notifications'),
            ),
          ),
          Container(
            child: Center(
              child: isBusy
                  ? CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Profile'),
                        ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isBusy = true;
                            });

                            await FirebaseAuth.instance.signOut();
                          },
                          icon: Icon(Icons.logout),
                          label: Text("Sign Out"),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
            )
          ],
        ),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: veppoBlue,
          unselectedItemColor: veppoLightGrey,
          currentIndex: bottomNavigationIndex,
          onTap: (index) {
            setState(() {
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 400),
                curve: Curves.decelerate,
              );
              bottomNavigationIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(Icons.search_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Trips',
              icon: Icon(Icons.menu),
            ),
            BottomNavigationBarItem(
              label: 'Notifications',
              icon: Icon(Icons.notifications),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.supervised_user_circle_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
