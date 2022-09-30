import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:reale/widgets/stylishCustomButton.dart';

TextEditingController area = TextEditingController();
TextEditingController areaUnits = TextEditingController();
TextEditingController adress = TextEditingController();
TextEditingController demands = TextEditingController();
TextEditingController description = TextEditingController();
// TextEditingController floors = TextEditingController();
// TextEditingController rooms = TextEditingController();
// TextEditingController kitchens = TextEditingController();
// TextEditingController basements = TextEditingController();
// TextEditingController parkings = TextEditingController();
// TextEditingController washrooms = TextEditingController();
TextEditingController sold = TextEditingController();
TextEditingController purpose = TextEditingController();
// TextEditingController loc_x = TextEditingController();
// TextEditingController loc_y = TextEditingController();

class Edit extends StatefulWidget {
  final uid;
  final data;

  Edit({this.uid, this.data});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  void initState() {
    var data = widget.data;
    area.value = TextEditingValue(text: data["area"] ?? "");
    adress.value = TextEditingValue(text: data["adress"] ?? "");
    demands.value = TextEditingValue(text: data["demand"] ?? "");
    description.value = TextEditingValue(text: data["description"] ?? "");
    // floors.value = TextEditingValue(text: data["floors"] ?? "");
    // rooms.value = TextEditingValue(text: data["rooms"] ?? "");
    // kitchens.value = TextEditingValue(text: data["kitchens"] ?? "");
    // basements.value = TextEditingValue(text: data["basements"] ?? "");
    // parkings.value = TextEditingValue(text: data["parkings"] ?? "");
    // washrooms.value = TextEditingValue(text: data["washroom"] ?? "");
    // loc_x.value = TextEditingValue(text: data["marker_x"] ?? "");
    // loc_y.value = TextEditingValue(text: data["marker_y"] ?? "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("listings").snapshots(),
          builder: (context, snapshot) {
            //areaUnits.value = TextEditingValue(text: "");
            return Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.all(15),
                      child: Text(
                        "${widget.data["provinceName"]}, ${widget.data["cityName"]}\n${widget.data["schemeName"]}, ${widget.data["phaseName"]}\n${widget.data["blockName"]}, ${widget.data["subBlockName"]}\n${widget.data["type"]}, ${widget.data["subType"]}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: area,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: "Area"),
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: adress,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: "Adress"),
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: DropDown(
                        initialValue: widget.data["areaUnit"],
                        onChanged: (val) {
                          setState(() {
                            areaUnits.value = TextEditingValue(text: "$val");
                          });
                        },
                        //hint: Text("Area Unit"),
                        items: [
                          "Squareft",
                          "Marla",
                          "Canal",
                          "Acre",
                          "Hectare"
                        ],
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: demands,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: "Demand"),
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: description,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: "Description"),
                      )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: floors,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Floors"),
                  //     )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: rooms,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Rooms"),
                  //     )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: kitchens,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Kitchens"),
                  //     )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: basements,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Basements"),
                  //     )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: parkings,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Parkings"),
                  //     )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: washrooms,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Washrooms"),
                  //     )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: loc_x,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Location X"),
                  //     )),
                  // Container(
                  //     alignment: Alignment.center,
                  //     child: TextField(
                  //       controller: loc_y,
                  //       textAlign: TextAlign.center,
                  //       decoration: InputDecoration(labelText: "Location Y"),
                  //     )),
                  Container(
                      alignment: Alignment.center,
                      child: DropDown(
                        initialValue: widget.data["sold"],
                        onChanged: (val) {
                          setState(() {
                            sold.value = TextEditingValue(text: "$val");
                          });
                        },
                        hint: Text("Sold"),
                        items: ["yes", "no"],
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: DropDown(
                        initialValue: widget.data["sale"],
                        onChanged: (val) {
                          setState(() {
                            purpose.value = TextEditingValue(text: "$val");
                          });
                        },
                        hint: Text("Purpose"),
                        items: ["Sale", "Rent", "Lease"],
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: StylishCustomButton.icon(
                        text: "Done",
                        //elevation: 5,
                        icon: Icons.done,
                        onPressed: () async {
                          CollectionReference listings =
                              FirebaseFirestore.instance.collection('listings');
                          FirebaseAuth auth = FirebaseAuth.instance;

                          listings.doc(widget.uid).update({
                            "adress": adress.value.text,
                            // "washroom": washrooms.value.text,
                            // "kitchens": kitchens.value.text,
                            // "basements": basements.value.text,
                            // "floors": floors.value.text,
                            // "parkings": parkings.value.text,
                            // "rooms": rooms.value.text,
                            "sale": purpose.value.text,
                            "sold": sold.value.text,
                            "area": area.value.text,
                            "areaUnit": areaUnits.value.text,
                            "demand": demands.value.text,
                            "description": description.value.text,
                            // "marker_x": loc_x.value.text,
                            // "marker_y": loc_y.value.text,
                            "seller": "${await auth.currentUser?.uid}",
                            "name": await auth.currentUser?.displayName,
                            "time": DateTime.now(),
                          }).then((value) async {
                            CollectionReference updates = FirebaseFirestore
                                .instance
                                .collection('updates');
                            updates.add({
                              "user": "${auth.currentUser?.displayName}",
                              "action": "updated",
                              "createdAt": Timestamp.now(),
                              "id": widget.uid
                            });
                          });

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return SafeArea(
                              child: Scaffold(
                                body: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Your Listing was Successfully Posted",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: StylishCustomButton.icon(
                                        icon: Icons.check_circle,
                                        text: "DONE",
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    // RaisedButton(
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(18.0),
                                    //       side: BorderSide(color: Colors.white)),
                                    //   color: Colors.blueAccent,
                                    //   elevation: 10,
                                    //   padding: EdgeInsets.all(15),
                                    //   onPressed: () {
                                    //     // new code
                                    //
                                    //     // old code
                                    //     // for (var i = 0; i <= 12; i++) {
                                    //     //   Navigator.pop(context);
                                    //     // }
                                    //   },
                                    //   child: Text(
                                    //     "DONE",
                                    //     style: TextStyle(
                                    //         color: Colors.white,
                                    //         fontFamily: "Times New Roman",
                                    //         fontWeight: FontWeight.w700,
                                    //         fontSize: 20),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          }));

                          // Navigator.pushReplacement(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return Scaffold(
                          //     body: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Center(
                          //           child: Text(
                          //             "Your Listing was Succesfully Updated",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //               fontSize: 25,
                          //             ),
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           height: 30,
                          //         ),
                          //         RaisedButton(
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(18.0),
                          //               side: BorderSide(color: Colors.white)),
                          //           color: Colors.blueAccent,
                          //           elevation: 10,
                          //           padding: EdgeInsets.all(15),
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //           },
                          //           child: Text(
                          //             "DONE",
                          //             style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontFamily: "Times New Roman",
                          //                 fontWeight: FontWeight.w700,
                          //                 fontSize: 20),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }));
                        },
                      )),
                ],
              ),
            );
          }),
    );
  }
}
