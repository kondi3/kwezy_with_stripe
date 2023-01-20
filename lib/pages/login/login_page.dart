import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwezy_with_stripe/pages/login/verification_page.dart';
import 'package:kwezy_with_stripe/utils/consts.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneCtlr = TextEditingController();
  TextEditingController passwordCtlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(
      //     'Welcome',
      //   ),
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   backgroundColor: Color(0xFF3b7cfa),
      // ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spacer(flex: 2),
            // Image.asset(
            //   'assets/images/logo/veppo_logo.png',
            //   width: MediaQuery.of(context).size.width / 2,
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: phoneCtlr,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.black38,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.contact_mail,
                    color: Colors.black,
                  ),
                  labelText: "Phone Number",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextField(
            //     obscureText: !_showPassword!,
            //     style: TextStyle(color: Colors.white),
            //     decoration: InputDecoration(
            //       prefixIcon: Icon(
            //         Icons.lock_outline,
            //         color: Colors.white,
            //       ),
            //       labelText: "Password",
            //       labelStyle: TextStyle(
            //         color: Colors.white,
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(color: Colors.white38, width: 2),
            //       ),
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Row(
            //       children: [
            //         Checkbox(
            //           value: _showPassword,
            //           onChanged: (newValue) {
            //             setState(() {
            //               _showPassword = !_showPassword!;
            //             });
            //           },
            //         ),
            //         TextButton(
            //           onPressed: () {
            //             setState(() {
            //               _showPassword = !_showPassword!;
            //             });
            //           },
            //           style: ElevatedButton.styleFrom(
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            //           ),
            //           child: Text(
            //             'Show Password',
            //             style: TextStyle(
            //               color: Colors.black,
            //             ),
            //           ),
            //         ),
            //         Spacer(),
            //         TextButton(
            //           onPressed: () {},
            //           child: Text(
            //             'Forgot your password?',
            //             style: TextStyle(
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Spacer(),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  FirebaseAuth _auth = FirebaseAuth.instance;

                  _auth.verifyPhoneNumber(
                    phoneNumber: phoneCtlr.text,
                    verificationCompleted: (_) {},
                    verificationFailed: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    },
                    codeSent: (String verificationCode, int? token) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationPage(
                              verificationCode: verificationCode),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    },
                  );
                  // ConfirmationResult verifyCode =
                  //     await _auth.signInWithPhoneNumber(
                  //   phoneCtlr.text,
                  // );

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => VerificationPage(
                  //         verificationCode: verifyCode.verificationId),
                  //   ),
                  // );

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PagesController(),
                  //   ),
                  // );
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
                    'Sign in',
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
