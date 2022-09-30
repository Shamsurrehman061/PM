import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:reale/Edit.dart';
import 'package:reale/propertyDetails.dart';
import 'package:reale/widgets/custom_text_widget.dart';
import 'package:reale/widgets/stylishCustomButton.dart';

var provinceName;
var schemeName;

// var currentFilterValue = 0;
// var currentFilterName = "province";
// TextEditingController currentSearch = TextEditingController();
// var filters = ["province", "type", "sold", "area"];

class sold extends StatefulWidget {
  @override
  _soldState createState() => _soldState();
}

class _soldState extends State<sold> {
  QuerySnapshot? userStream;

  @override
  void initState() {
    super.initState();
    // userStream = FirebaseFirestore
    //     .instance
    //     .collection("users").get().then((QuerySnapshot snapshot) => userStream = snapshot) as QuerySnapshot;

    FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot snapshot) {
      userStream = snapshot;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Sold/Unsold'),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top -
                80,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("listings")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print('data found');
                    QuerySnapshot? data = snapshot.data;
                    List<QueryDocumentSnapshot>? documents = data?.docs;
                    List<DocumentSnapshot>? fiteredList = data?.docs
                        .where((DocumentSnapshot ds) =>
                    ( ds.data() as Map<String,dynamic>)["seller"] ==
                            FirebaseAuth.instance.currentUser?.uid)
                        .toList();
                    print('Total Filtered List: ${fiteredList}');

                    return ListView.builder(
                        itemCount: fiteredList!.length,
                        itemBuilder: (context, index) {
                          // check() async {
                          //   print(currentFilterName);
                          //   DocumentSnapshot currentDoc = documents[index];
                          //   var data = await currentDoc.data();
                          //
                          //   FirebaseAuth auth = FirebaseAuth.instance;
                          //   var currentUid = await auth.currentUser.uid;
                          //   /*useless*/
                          //   // if (currentUid ==
                          //   //     documents[index].data()["seller"]) {
                          //   //   if (currentFilterName == "province") {
                          //   //     if (data["provinceName"]
                          //   //         .toString()
                          //   //         .toLowerCase()
                          //   //         .contains(currentSearch.value.text
                          //   //             .toString()
                          //   //             .toLowerCase())) {
                          //   //       print('province: found something');
                          //   //       return true;
                          //   //     } else {
                          //   //       print('province: found nothing');
                          //   //       return false;
                          //   //     }
                          //   //   } else if (currentFilterName == "type") {
                          //   //     if (data["type"]
                          //   //         .toString()
                          //   //         .toLowerCase()
                          //   //         .contains(currentSearch.value.text
                          //   //             .toString()
                          //   //             .toLowerCase())) {
                          //   //       return true;
                          //   //     } else {
                          //   //       return false;
                          //   //     }
                          //   //   } else if (currentFilterName == "sold") {
                          //   //     if (data["sold"]
                          //   //         .toString()
                          //   //         .toLowerCase()
                          //   //         .contains(currentSearch.value.text
                          //   //             .toString()
                          //   //             .toLowerCase())) {
                          //   //       return true;
                          //   //     } else {
                          //   //       return false;
                          //   //     }
                          //   //   } else if (currentFilterName == "area") {
                          //   //     if (data["area"]
                          //   //         .toString()
                          //   //         .toLowerCase()
                          //   //         .contains(currentSearch.value.text
                          //   //             .toString()
                          //   //             .toLowerCase())) {
                          //   //       return true;
                          //   //     } else {
                          //   //       return false;
                          //   //     }
                          //   //   }
                          //   // } else {
                          //   //   return false;
                          //   // }
                          // }
                          DocumentSnapshot currentDoc = fiteredList[index];
                          var data = currentDoc.data();
                          DateTime time =
                          (documents![index].data() as Map<String,dynamic>)["time"].toDate();
                          var timeHours = time.hour;
                          var timeMinutes = time.minute;
                          var timeCode = "am";
                          if (timeHours >= 12) {
                            timeHours = timeHours - 12;
                            timeCode = "pm";
                          }
                          var timeFormat =
                              "${time.year}-${time.month}-${time.day} $timeHours:$timeMinutes $timeCode ";

                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: Card(
                                  elevation: 8.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0, color: Colors.white)),
                                    // margin: EdgeInsets.only(
                                    //     bottom: 10,
                                    //     left: 10,
                                    //     right: 10,
                                    //     top: 10),
                                    padding: EdgeInsets.all(15),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return propertyDetails(
                                              documents[index].data());
                                        }));
                                      },
                                      child: Column(
                                        children: [
                                          // time row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                text1: "Time :",
                                                text2: "$timeFormat",
                                              ),
                                              // Text(
                                              //   "Time : $timeFormat",
                                              //   style: TextStyle(
                                              //       color: Colors.black,
                                              //       fontFamily:
                                              //           "Times New Roman",
                                              //       fontWeight: FontWeight.w700,
                                              //       fontSize: 20),
                                              // ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 0,
                                          ),
                                          // scheme row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                text1: "Scheme : ",
                                                text2:
                                                    "${(documents[index].data() as Map<String,dynamic>)["schemeName"]}",
                                              )
                                              // Text(
                                              //   "Scheme : ${documents[index].data()["schemeName"]}",
                                              //   style: TextStyle(
                                              //       color: Colors.black,
                                              //       fontFamily:
                                              //           "Times New Roman",
                                              //       fontWeight: FontWeight.w700,
                                              //       fontSize: 20),
                                              // ),
                                            ],
                                          ),
                                          //province name row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                text1: "Province :",
                                                text2:
                                                    "${(documents[index].data() as Map<String,dynamic>)["provinceName"]}",
                                              ),
                                              // Text(
                                              //   "Province : ${documents[index].data()["provinceName"]}",
                                              //   style: TextStyle(
                                              //       color: Colors.black,
                                              //       fontFamily:
                                              //           "Times New Roman",
                                              //       fontWeight:
                                              //           FontWeight.w700,
                                              //       fontSize: 20),
                                              // ),
                                              // Icon(
                                              //   Icons.location_on,
                                              //   size: 50,
                                              // )
                                            ],
                                          ),
                                          // seller row
                                          // RaisedButton(
                                          //   onPressed: () async {
                                          //     // QuerySnapshot querySnapshot =
                                          //     //     await userStream;
                                          //     // DocumentSnapshot docSnap =
                                          //     //     querySnapshot.docs.elementAt(
                                          //     //         index); //["seller"];
                                          //
                                          //     //List<DocumentSnapshot> docSnap = await userStream;
                                          //     //await userStream. documents[documents[index].data()["seller"]];
                                          //     // userStream.docs(documents[index]
                                          //     //     .data()["seller"]).data()["businessName"]);
                                          //   },
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: getUserSpecificDocument(
                          (documents[index]
                                                        .data() as Map<String,dynamic>)["seller"]) ??
                                                [Container()],
                                            // children: [
                                            //   StreamBuilder(
                                            //     stream: FirebaseFirestore
                                            //         .instance
                                            //         .collection("users")
                                            //         // seller uid is passed to the doc
                                            //         .doc(documents[index]
                                            //             .data()["seller"])
                                            //         .snapshots(),
                                            //     builder: (context, snapshot) {
                                            //       if (snapshot.hasData) {
                                            //         return Row(
                                            //           mainAxisAlignment:
                                            //               MainAxisAlignment
                                            //                   .center,
                                            //           children: [
                                            //             Text(
                                            //               "Seller : ",
                                            //               style: TextStyle(
                                            //                   color:
                                            //                       Colors.black,
                                            //                   fontFamily:
                                            //                       "Times New Roman",
                                            //                   fontWeight:
                                            //                       FontWeight
                                            //                           .w700,
                                            //                   fontSize: 20),
                                            //             ),
                                            //             Text(
                                            //               "${snapshot.data.data()["businessName"]}",
                                            //               style: TextStyle(
                                            //                 color: Colors
                                            //                     .deepOrangeAccent,
                                            //                 fontFamily:
                                            //                     "Times New Roman",
                                            //                 fontWeight:
                                            //                     FontWeight.w700,
                                            //                 fontSize: 20,
                                            //               ),
                                            //               overflow:
                                            //                   TextOverflow.fade,
                                            //             )
                                            //           ],
                                            //         );
                                            //       } else {
                                            //         return Text("LOADING");
                                            //       }
                                            //     },
                                            //   ),
                                            // ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // floating action buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // edit button
                                              // shown to user if its add by same user
                                              // if (FirebaseAuth.instance
                                              //         .currentUser.uid ==
                                              //     data["seller"])
                                              Expanded(
                                                child: IgnorePointer(
                                                  ignoring: (FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid ==
                                                      (data as Map<String,dynamic>)["seller"]),
                                                  child:
                                                      StylishCustomButton.icon(
                                                    buttonColor: (FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid ==
                                                        ( data as Map<String,dynamic>)[
                                                                    "seller"]) ==
                                                            true
                                                        ? null
                                                        : Colors.grey,
                                                    isSmallerSize: true,
                                                    text: 'Edit',
                                                    icon: Icons.edit,
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return Edit(
                                                            uid:
                                                                documents[index]
                                                                    .id,
                                                            data:
                                                                documents[index]
                                                                    .data());
                                                      }));
                                                    },
                                                  ),
                                                ),
                                              ),
                                              // RaisedButton(
                                              //   child: Icon(Icons.edit),
                                              //   onPressed: () {
                                              //     Navigator.push(context,
                                              //         MaterialPageRoute(
                                              //             builder:
                                              //                 (context) {
                                              //       return Edit(
                                              //           uid:
                                              //               documents[index]
                                              //                   .id,
                                              //           data:
                                              //               documents[index]
                                              //                   .data());
                                              //     }));
                                              //   },
                                              // ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: StylishCustomButton.icon(
                                                  isSmallerSize: true,
                                                  text: "delete",
                                                  icon: Icons.delete_sharp,
                                                  onPressed: () async {
                                                    FirebaseAuth auth =
                                                        FirebaseAuth.instance;
                                                    CollectionReference
                                                        listings =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'listings');
                                                    await listings
                                                        .doc(
                                                            documents[index].id)
                                                        .delete();
                                                  },
                                                ),
                                              ),
                                              // delete button
                                              SizedBox(width: 10),
                                              // sold button
                                              Expanded(
                                                child: IgnorePointer(
                                                  ignoring: (documents[index]
                                                          .data() as Map<String,dynamic>)["sold"] ==
                                                      'yes',
                                                  child: IgnorePointer(
                                                    ignoring: (FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid ==
                                                        data["seller"]),
                                                    child: StylishCustomButton
                                                        .icon(
                                                      buttonColor: (FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid ==
                                                                  data[
                                                                      "seller"]) ==
                                                              true
                                                          ? null
                                                          : Colors.grey,
                                                      isSmallerSize: true,
                                                      text: "Sold",
                                                      icon: Icons.code,
                                                      onPressed: () async {
                                                        print(
                                                            'Doc id: ${documents[index].id}');
                                                        bool? result=false;
                                                        result =
                                                            await showDialog<
                                                                bool>(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Change Sold status'),
                                                              content: Text(
                                                                  'Do you want to Sold ?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        'Yes');
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                                  child: Text(
                                                                      'Yes'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    print('no');
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false);
                                                                  },
                                                                  child: Text(
                                                                      'No'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );

                                                        if (result??false) {
                                                          setState(() {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "listings")
                                                                .doc(documents[
                                                                        index]
                                                                    .id)
                                                                .update(
                                                              {
                                                                "sold":( documents[index]
                                                                            .data() as Map<String,dynamic>)["sold"] ==
                                                                        'yes'
                                                                    ? 'no'
                                                                    : 'yes',
                                                              },
                                                            );
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // show red stripe if its not sold
                              // documents[index].data()["sold"] == 'yes'
                              //     ? Positioned(
                              //         right: 5, // 10
                              //         top: -25, // -15
                              //         //width: 29,
                              //         //height: 70,
                              //         child: Transform.rotate(
                              //           angle: -0.8,
                              //           child: Container(
                              //             alignment: Alignment.centerLeft,
                              //             margin: const EdgeInsets.all(0),
                              //             padding: const EdgeInsets.only(
                              //                 top: 0,
                              //                 left: 0,
                              //                 right: 0,
                              //                 bottom: 13),
                              //             color: Colors.red,
                              //             //width: 30,
                              //             height: 105,
                              //             child: Transform.rotate(
                              //               angle: 1.6,
                              //               child: Text(
                              //                 'Sold',
                              //                 style: TextStyle(
                              //                   fontWeight: FontWeight.bold,
                              //                   color: Colors.white,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       )
                              //     : Container(),
                              (documents[index].data() as Map<String,dynamic>)["sold"] == "yes"
                                  ? Positioned(
                                      right: 5, // 10
                                      top: -25, // -15
                                      //width: 29,
                                      //height: 70,
                                      child: Transform.rotate(
                                        angle: -0.8,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: const EdgeInsets.all(0),
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              left: 0,
                                              right: 0,
                                              bottom: 13),
                                          color: Colors.red,
                                          //width: 30,
                                          height: 105,
                                          child: Transform.rotate(
                                            angle: 1.6,
                                            child: Text(
                                              'Sold',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          );

                          // return FutureBuilder(
                          //   future: check(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.data == true) {
                          //       DateTime time = documents[index]
                          //           .data()["time"]
                          //           .toDate();
                          //       var timeHours = time.hour;
                          //       var timeMinutes = time.minute;
                          //       var timeCode = "am";
                          //       if (timeHours >= 12) {
                          //         timeHours = timeHours - 12;
                          //         timeCode = "pm";
                          //       }
                          //       var timeFormat =
                          //           "${time.year}-${time.month}-${time.day} $timeHours:$timeMinutes $timeCode ";
                          //
                          //       return Stack(children: [
                          //         // show red stripe if its not sold
                          //         documents[index].data()["sold"] == 'yes'
                          //             ? Positioned(
                          //                 right: 5, // 10
                          //                 top: -25, // -15
                          //                 //width: 29,
                          //                 //height: 70,
                          //                 child: Transform.rotate(
                          //                   angle: -0.8,
                          //                   child: Container(
                          //                     alignment:
                          //                         Alignment.centerLeft,
                          //                     margin:
                          //                         const EdgeInsets.all(0),
                          //                     padding:
                          //                         const EdgeInsets.only(
                          //                             top: 0,
                          //                             left: 0,
                          //                             right: 0,
                          //                             bottom: 13),
                          //                     color: Colors.red,
                          //                     //width: 30,
                          //                     height: 105,
                          //                     child: Transform.rotate(
                          //                       angle: 1.6,
                          //                       child: Text(
                          //                         'Sold',
                          //                         style: TextStyle(
                          //                           fontWeight:
                          //                               FontWeight.bold,
                          //                           color: Colors.white,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               )
                          //             : Container(),
                          //
                          //         Container(
                          //           decoration: BoxDecoration(
                          //               // change based on sold attribute
                          //               // color:
                          //               //     documents[index].data()["sold"] ==
                          //               //             "yes"
                          //               //         ? Colors.blueGrey
                          //               //         : Colors.white,
                          //               border: Border.all(width: 2)),
                          //           margin: EdgeInsets.only(
                          //               bottom: 40, left: 5, right: 5),
                          //           padding: EdgeInsets.all(20),
                          //           child: RaisedButton(
                          //             elevation: 0,
                          //             // change based on sold attribute
                          //             // color:
                          //             //     documents[index].data()["sold"] ==
                          //             //             "yes"
                          //             //         ? Colors.blueGrey
                          //             //         : Colors.white,
                          //             onPressed: () {
                          //               Navigator.push(context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) {
                          //                 return propertyDetails(
                          //                     documents[index].data());
                          //               }));
                          //             },
                          //             child: Column(
                          //               children: [
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                       "Time : $timeFormat",
                          //                       style: TextStyle(
                          //                           color: Colors.black,
                          //                           fontFamily:
                          //                               "Times New Roman",
                          //                           fontWeight:
                          //                               FontWeight.w700,
                          //                           fontSize: 20),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                       "Scheme : ${documents[index].data()["schemeName"]}",
                          //                       style: TextStyle(
                          //                           color: Colors.black,
                          //                           fontFamily:
                          //                               "Times New Roman",
                          //                           fontWeight:
                          //                               FontWeight.w700,
                          //                           fontSize: 20),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.start,
                          //                   children: [
                          //                     FittedBox(
                          //                       fit: BoxFit.cover,
                          //                       child: Text(
                          //                         "Province : ${documents[index].data()["provinceName"]}",
                          //                         style: TextStyle(
                          //                             color: Colors.black,
                          //                             fontFamily:
                          //                                 "Times New Roman",
                          //                             fontWeight:
                          //                                 FontWeight.w700,
                          //                             fontSize: 20),
                          //                       ),
                          //                     ),
                          //                     Icon(
                          //                       Icons.location_on,
                          //                       size: 50,
                          //                     )
                          //                   ],
                          //                 ),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.start,
                          //                   children: [
                          //                     StreamBuilder(
                          //                       stream: FirebaseFirestore
                          //                           .instance
                          //                           .collection("users")
                          //                           .doc(documents[index]
                          //                               .data()["seller"])
                          //                           .snapshots(),
                          //                       builder:
                          //                           (context, snapshot) {
                          //                         if (snapshot.hasData) {
                          //                           return Row(
                          //                             mainAxisAlignment:
                          //                                 MainAxisAlignment
                          //                                     .center,
                          //                             children: [
                          //                               Text(
                          //                                 "Seller : ",
                          //                                 style: TextStyle(
                          //                                     color: Colors
                          //                                         .black,
                          //                                     fontFamily:
                          //                                         "Times New Roman",
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .w700,
                          //                                     fontSize: 20),
                          //                               ),
                          //                               Text(
                          //                                 "${snapshot.data.data()["businessName"]}",
                          //                                 style: TextStyle(
                          //                                   color: Colors
                          //                                       .deepOrangeAccent,
                          //                                   fontFamily:
                          //                                       "Times New Roman",
                          //                                   fontWeight:
                          //                                       FontWeight
                          //                                           .w700,
                          //                                   fontSize: 20,
                          //                                 ),
                          //                                 overflow:
                          //                                     TextOverflow
                          //                                         .fade,
                          //                               )
                          //                             ],
                          //                           );
                          //                         } else {
                          //                           return Text("LOADING");
                          //                         }
                          //                       },
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 // floating action buttons
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.start,
                          //                   children: [
                          //                     RaisedButton(
                          //                       child: Icon(Icons.edit),
                          //                       onPressed: () {
                          //                         Navigator.push(context,
                          //                             MaterialPageRoute(
                          //                                 builder:
                          //                                     (context) {
                          //                           return Edit(
                          //                               uid:
                          //                                   documents[index]
                          //                                       .id,
                          //                               data:
                          //                                   documents[index]
                          //                                       .data());
                          //                         }));
                          //                       },
                          //                     ),
                          //                     SizedBox(
                          //                       width: 20,
                          //                     ),
                          //                     RaisedButton(
                          //                       child: Icon(
                          //                           Icons.delete_sharp),
                          //                       onPressed: () async {
                          //                         FirebaseAuth auth =
                          //                             FirebaseAuth.instance;
                          //                         CollectionReference
                          //                             listings =
                          //                             FirebaseFirestore
                          //                                 .instance
                          //                                 .collection(
                          //                                     'listings');
                          //                         await listings
                          //                             .doc(documents[index]
                          //                                 .id)
                          //                             .delete();
                          //                       },
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ]);
                          //     } else {
                          //       return SizedBox(
                          //         height: 0,
                          //       );
                          //     }
                          //   },
                          // );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? getUserSpecificDocument(String documentID) {
    // QuerySnapshot userQuerySnapshot = userStream;
    if (userStream != null) {
      List<DocumentSnapshot> userAllDocs = userStream!.docs
          .where((DocumentSnapshot documentSnapshot) =>
              documentID == documentSnapshot.id)
          .toList();
      List<Row> _userRow = userAllDocs
          .map(
            (DocumentSnapshot snapshot) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  text1: "Seller :",
                  text2: "${(snapshot.data() as Map<String,dynamic>)["businessName"]}",
                ),
              ],
            ),
          )
          .toList();
      return _userRow;
    }
  }
}
