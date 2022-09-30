import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectSchemeDetails.dart';
import 'package:reale/policy.dart';
import 'package:reale/dealers.dart';
import 'package:reale/sold.dart';
import 'package:reale/userInformationFormAfterOTP.dart';
import 'package:reale/widgets/custom_text_widget.dart';
import 'package:reale/widgets/setting_stepper.dart';
import 'package:reale/widgets/stylishCustomButton.dart';
import 'Auth/login.dart';

import 'EntryDetails/selectProvinceDetails.dart';
import 'main.dart';
import 'mainPage.dart';
import 'newCode/Functions.dart';

class propertyManagement extends StatefulWidget {
  @override
  _propertyManagementState createState() => _propertyManagementState();
}

class _propertyManagementState extends State<propertyManagement> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // String? _userName;
  // String? _userPhone;
  // String? _userProfileImage;
  // int i = 0;
  // Future? myFuture;

  String userName = "";
  String phoneNumber = "";
  String imgUrl = "";



  Future<void> getUserData()async
  {
    final result =await db.collection("users").doc(auth.currentUser!.uid).get().then((value){
      final userData = value.data();
      setState(() {
        userName = userData!['name'];
        phoneNumber = userData!['phone'];
        imgUrl = userData!['profile'];
      });

    }
    ).onError((error, stackTrace){

    });
  }

  Future<void> getUserNameAndPhoneNumber() async {
    print('getUserNameAndPhoneNumber() ');
    //print('i value: ${i++}');
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection("users")
        .doc({auth.currentUser?.uid}.toString())
        .get();
    if (user.exists) {
      setState(() {
        // _userName = (user.data()  as Map<String,dynamic>)['name'] ?? "No Name";
        // _userPhone = (user.data()  as Map<String,dynamic>)['phone'] ?? "No Number";
        // _userProfileImage = (user.data() as Map<String,dynamic>)['profile'];
        print('image url: ${(user.data() as Map<String,dynamic>)['profile']}');
      });
      // setState(() {
      //   _userName = user.data()['name'];
      //   _userPhone = user.data()['phone'];
      //   _userProfileImage = user.data()['profile'];
      // });
      // print('Name: ${(user.data() as Map<String,dynamic>)['name']}');
      // print('Number: ${user.data()['phone']}');
      print('future builder is completed');
    }
  }

  @override
  void initState() {
    super.initState();
    print('init state...property management');
    //myFuture = getUserNameAndPhoneNumber();
    getUserData();
    // getUserNameAndPhoneNumber().then(
    //     (value) => print('downloaded profile image and name and phone number'));
  }

  @override
  Widget build(BuildContext context) {
    //myFuture = getUserNameAndPhoneNumber();
    // getUserNameAndPhoneNumber().then((value) => print(
    //     'inside build:::downloaded profile image and name and phone number'));
    //FirebaseAuth auth = FirebaseAuth.instance;
    var photo = currentUser?.photoURL ?? "none";

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: imgUrl != null
                                ? CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(imgUrl),
                            )
                                : Center(
                                    child: Container(
                                        child: CircularProgressIndicator())),
                          ),
                          SizedBox(height: 10),
                          CustomTextWidget(
                            text1: 'Name: ',
                            text2: userName ?? "",
                          ),
                          CustomTextWidget(
                            text1: 'Phone Number: ',
                            text2: phoneNumber ?? "",
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 3),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StylishCustomButton(
                            text: "Entries",
                            // text: "REPORTS",
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return SelectProvinceDetails();
                                // here we need to reset the stepper state model
                               // stepperStateModel.reset();
                                // return policy();
                                // me **************************
                               // return InformationStepper();
                                // return reports();
                              }));
                            },
                          ),
                          SizedBox(height: 12),
                          StylishCustomButton(
                            text: "DEALERS",
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    // return policy();
                                    // me **************************
                                return dealers();
                              }));
                            },
                          ),
                          SizedBox(height: 12),
                          StylishCustomButton(
                            text: "SOLD/UNSOLD",
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    // me **************************
                                return sold();
                                // return policy();

                              }));
                            },
                          ),
                          SizedBox(height: 12),
                          StylishCustomButton(
                            text: "Profile",
                            onPressed: () async {
                              // go to user info screen
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UserFormAfterOTP(
                                  isFromLoginRoute: false,
                                );
                                // return mainPage();
                              }));
                            },
                          ),
                          SizedBox(height: 12),
                          StylishCustomButton(
                            text: "Logout",
                            onPressed: () async {
                              print('logout text tapped');
                              bool? result = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Logout'),
                                    content: Text('Do you want to Logout ?'),
                                    actions: [
                                     ElevatedButton(
                                        onPressed: () {
                                          print('Log out user');
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('No'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          print('Login user');
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              // if true the logout otherwise stay same
                              if (result!) {
                                FirebaseAuth auth = FirebaseAuth.instance;
                                await removeFCMTok(auth.currentUser!.uid);
                                await auth.signOut();

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SafeArea(
                                      child: Scaffold(body: login()));
                                }));
                              }
                            },
                          ),
                          /*RaisedButton(
                              padding: EdgeInsets.all(20),
                              elevation: 5,
                              color: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.black)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return addListing(); /*Entries();*/
                                }));
                              },
                              child: Text("ENTRIES",
                                  style: TextStyle(
                                      fontFamily: "Times New Roman",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20))),*/
                          // REPORTS

                          /*RaisedButton(
                              padding: EdgeInsets.all(20),
                              elevation: 5,
                              color: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.black)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return reports();
                                }));
                              },
                              child: Text("REPORTS",
                                  style: TextStyle(
                                      fontFamily: "Times New Roman",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20))),*/
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     // "HELP"
                          //     RaisedButton(
                          //         padding: EdgeInsets.all(20),
                          //         elevation: 5,
                          //         color: Colors.pinkAccent,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10.0),
                          //             side: BorderSide(color: Colors.black)),
                          //         onPressed: () {
                          //           Navigator.push(context,
                          //               MaterialPageRoute(builder: (context) {
                          //             return help();
                          //           }));
                          //         },
                          //         child: Text("HELP",
                          //             style: TextStyle(
                          //                 fontFamily: "Times New Roman",
                          //                 fontWeight: FontWeight.w700,
                          //                 color: Colors.white,
                          //                 fontSize: 20))),
                          //     // DEALERS
                          //
                          //   ],
                          // ),
                          //SizedBox(height: 35),

                          /*RaisedButton(
                              padding: EdgeInsets.all(20),
                              elevation: 5,
                              color: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.black)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return dealers();
                                }));
                              },
                              child: Text("DEALERS",
                                  style: TextStyle(
                                      fontFamily: "Times New Roman",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20))),*/
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     // about
                          //     RaisedButton(
                          //         padding: EdgeInsets.all(20),
                          //         elevation: 5,
                          //         color: Colors.pinkAccent,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10.0),
                          //             side: BorderSide(color: Colors.black)),
                          //         onPressed: () {
                          //           Navigator.push(context,
                          //               MaterialPageRoute(builder: (context) {
                          //             return about();
                          //           }));
                          //         },
                          //         child: Text("ABOUT PM",
                          //             style: TextStyle(
                          //                 fontFamily: "Times New Roman",
                          //                 fontWeight: FontWeight.w700,
                          //                 color: Colors.white,
                          //                 fontSize: 20))),
                          //     // poloices
                          //     RaisedButton(
                          //         padding: EdgeInsets.all(20),
                          //         elevation: 5,
                          //         color: Colors.pinkAccent,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10.0),
                          //             side: BorderSide(color: Colors.black)),
                          //         onPressed: () {
                          //           Navigator.push(context,
                          //               MaterialPageRoute(builder: (context) {
                          //             return policy();
                          //           }));
                          //         },
                          //         child: Text("POLICIES",
                          //             style: TextStyle(
                          //                 fontFamily: "Times New Roman",
                          //                 fontWeight: FontWeight.w700,
                          //                 color: Colors.white,
                          //                 fontSize: 20))),
                          //   ],
                          // ),
                          // sold
                          //SizedBox(height: 35),

                          /*RaisedButton(
                              padding: EdgeInsets.all(20),
                              elevation: 5,
                              color: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.black)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return sold();
                                }));
                              },
                              child: Text("SOLD/UNSOLD",
                                  style: TextStyle(
                                      fontFamily: "Times New Roman",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20))),*/
                          //Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
