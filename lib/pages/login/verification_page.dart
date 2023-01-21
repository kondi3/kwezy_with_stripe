// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwezy_with_stripe/main.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  final String verificationCode;
  final String phoneNumber;

  VerificationPage({required this.verificationCode, required this.phoneNumber});
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController numberCtlr = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Verify', style: TextStyle(color: Colors.white)),
        backgroundColor: veppoBlue,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: numberCtlr,
                style: TextStyle(color: Colors.black38),
                cursorColor: Colors.black87,
                decoration: InputDecoration(
                  labelText: "6 digit code",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        // check if code input is not empty
                        if (numberCtlr.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          final credintials = PhoneAuthProvider.credential(
                            verificationId: widget.verificationCode,
                            smsCode: numberCtlr.text,
                          );

                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(credintials);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VeppoApp(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "An error occurred. Please make sure you provided the correct code!",
                                ),
                              ),
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => VeppoApp(),
                            //   ),
                            // );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please provide the 6 digit code sent to ${widget.phoneNumber}!"),
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
                            return Color(0xFF3b7cfa);
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
