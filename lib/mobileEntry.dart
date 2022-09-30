import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:reale/codeEntry.dart';
import 'package:reale/mainPage.dart';

// import 'package:reale/newCode/Notification/notifications.dart';
import 'package:reale/setUserDetails.dart';
import 'package:reale/widgets/stylishCustomButton.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:reale/userInformationFormAfterOTP.dart';

var countryCode = CountryCode(dialCode: "+92", code: "PK");

TextEditingController phoneField = TextEditingController();

class mobileEntry extends StatefulWidget {
  const mobileEntry({Key? key}) : super(key: key);

  @override
  mobileEntryState createState() => mobileEntryState();
}

class mobileEntryState extends State<mobileEntry> {
  @override
  final _db = FirebaseFirestore.instance;

  // final FirebaseMessaging _fcm = FirebaseMessaging();

  setUPNotifications() {
    // me +++++++++++++++++++*******************************
    // if (Platform.isIOS) {
    //   var iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     // save the token  OR subscribe to a topic here
    //   });
    //
    //   // ignore: deprecated_member_use
    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    // ...
    //
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['body']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // TODO optional
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // TODO optional
    //   },
    // );

    // ...

    //meee ******************************************************
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['body']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // TODO optional
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // TODO optional
    //   },
    // );
  }

  checkLoggedIn() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
  }

  void initState() {
    // TODO: implement initState
    checkLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 40),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your Mobile Number",
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont('Montserrat',
                  fontWeight: FontWeight.w500, fontSize: 30),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CountryCodePicker(
                      onChanged: (code) {
                        setState(() {
                          countryCode = code;
                        });
                      },
                      initialSelection: 'PK',
                      onInit: (d) async {
                      },
                      favorite: ['+92', 'PK'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: phoneField,
                      style: GoogleFonts.getFont('Montserrat',
                          fontWeight: FontWeight.w400, fontSize: 15),
                      decoration: InputDecoration(
                        //prefix: Text("${countryCode.dialCode}   "),
                        hintText: " 317 463 1188",
                        hintStyle: GoogleFonts.getFont('Montserrat',
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
           const SizedBox(
              height: 20,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Montserrat',
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () async {},
                  child: Text("Resend",
                      style: GoogleFonts.getFont('Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                )
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            // next button
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(249, 214, 148, 0.5),
                    blurRadius: 5, // soften the shadow
                    spreadRadius: 0.1, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: StylishCustomButton(
                // color: Colors.pinkAccent,
                text: 'Next',
                onPressed: () async {
                  print('${countryCode.dialCode}${phoneField.value.text}');
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.verifyPhoneNumber(
                    phoneNumber:
                        '${countryCode.dialCode}${phoneField.value.text}',
                    verificationFailed: (FirebaseAuthException e) {
                      FirebaseAuthException p = e;

                      Alert(
                        context: context,
                        title: p.code,
                        desc: p.message,
                        style: const AlertStyle(
                          descStyle: TextStyle(fontSize: 15),
                        ),
                        buttons: [
                          // StylishCustomButton(
                          //   text: "OK",
                          //   onPressed: () => Navigator.pop(context),
                          // ),
                          DialogButton(
                            color: Colors.green,
                            radius: BorderRadius.circular(10.0),
                            onPressed: () => Navigator.pop(context),
                            width: 80,
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ).show();
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      print("CODE SENT");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return codeEntry(verificationId);
                      }));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      print(
                          "***verificationCompleted:(PhoneAuthCredential credential)***");
                      PhoneAuthCredential d;

                      // credential.
                      await auth.signInWithCredential(credential);
                      print("LOGGED IN** *");
                      print(auth.currentUser!.phoneNumber);
                      //me *********************************
                      // await saveDeviceToken(auth.currentUser!.uid.toString());
                      setUPNotifications();

                      setUserDetails(auth.currentUser!.uid.toString(),
                          phone: phoneField.value.text);

                      // go to user info screen
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserFormAfterOTP(
                          isFromLoginRoute: true,
                        );
                        // return mainPage();
                      }));
                    },
                  );

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => UserFormAfterOTP(),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
