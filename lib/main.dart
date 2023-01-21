import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwezy_with_stripe/controllers/pages_controller.dart';
import 'package:kwezy_with_stripe/firebase_options.dart';
import 'package:kwezy_with_stripe/pages/login/login_page.dart';
import 'package:kwezy_with_stripe/pages/login/providers/services.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      "pk_test_51MMEjpFmStvzW5sWM73NeaEzjbLszkgrHOdzykAzaCzny6iKZIfihK6VIZC19oVeQLajUmapyC9VpEetsKV0qN8n00r1ozlRYG";

  await Stripe.instance.applySettings();
  runApp(VeppoApp());
}

class VeppoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: white,
        // hintColor: Colors.transparent,
        // focusColor: Colors.transparent,
        // hoverColor: Colors.transparent,
        // indicatorColor: Colors.transparent,
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;

            TextEditingController nameCtlr = TextEditingController();

            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  // UserModel userModel = UserModel.fromJson(snapshot.data!);

                  return PagesController();
                } else {
                  return Scaffold(
                      appBar: AppBar(
                        title: Text('Profile'),
                      ),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: nameCtlr,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: "Full Name",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white38, width: 2),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                AuthServices().addNewUser(
                                    user.phoneNumber, nameCtlr.text);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PagesController(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return veppoLightGrey;
                                    return Color(0xFF3b7cfa);
                                  },
                                ),
                              ),
                              child: const Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                }
              },
            );
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
