import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwezy_with_stripe/controllers/pages_controller.dart';
import 'package:kwezy_with_stripe/main.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  final String verificationCode;

  VerificationPage({required this.verificationCode});
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController nameCtlr = TextEditingController();
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
                style: TextStyle(color: Colors.black38),
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
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  final credintials = PhoneAuthProvider.credential(
                    verificationId: widget.verificationCode,
                    smsCode: nameCtlr.text,
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
                  } catch (e) {}

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagesController(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
