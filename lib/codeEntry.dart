import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/Material.dart';
import "package:flutter/cupertino.dart";
import "package:pin_code_text_field/pin_code_text_field.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:reale/mainPage.dart';
import 'package:reale/mobileEntry.dart';
import 'package:reale/setUserDetails.dart';
import 'package:reale/userInformationFormAfterOTP.dart';

TextEditingController codeField = TextEditingController();

class codeEntry extends StatefulWidget {
  final verifId;

  codeEntry(this.verifId);

  @override
  _codeEntryState createState() => _codeEntryState();
}

class _codeEntryState extends State<codeEntry> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter the 6 Digit Code sent to your phone",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont('Montserrat',
                    fontWeight: FontWeight.w500, fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                controller: codeField,
                pinBoxHeight: 50,
                pinBoxWidth: 50,
                maxLength: 6,
                isCupertino: true,
                pinBoxRadius: 15,
                hasTextBorderColor: Colors.green,
                pinTextStyle: GoogleFonts.getFont('Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.green),
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.defaultPinBoxDecoration,
              ),
              SizedBox(
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
                  MaterialButton(
                    onPressed: () async {},
                    child: Text("Resend",
                        style: GoogleFonts.getFont('Montserrat',
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                  )
                ],
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: new BoxDecoration(
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
                child: ButtonTheme(
                  minWidth: 240,
                  height: 70,
                  child: MaterialButton(
                    color: Colors.green,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verifId,
                              smsCode: codeField.value.text);

                      try {
                        await auth.signInWithCredential(phoneAuthCredential);
                        print("LOGGED IN");
                        print(auth.currentUser?.phoneNumber);

                        // await setUserDetails(auth.currentUser.uid,phone: auth.currentUser.phoneNumber);

                        await setUserDetails(auth.currentUser?.uid,
                            name: auth.currentUser?.displayName,
                            email: auth.currentUser?.email,
                            profile: auth.currentUser?.photoURL,
                            phone: auth.currentUser?.phoneNumber);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UserFormAfterOTP(
                            isFromLoginRoute: true,
                          );
                          //return mainPage();
                        }));
                      } catch (e) {
                        print(e);
                      }
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
