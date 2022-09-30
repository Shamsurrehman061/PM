import 'package:carousel_images/carousel_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:reale/chat.dart';

import './widgets/custom_text_widget.dart';
import "./image_preview.dart";
import 'constant.dart';

var provinceName;
var districtName;

fetchUserInfo(id) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  var userInfo =
      await FirebaseFirestore.instance.collection('users').doc("${id}").get();
  return userInfo;
}

class propertyDetails extends StatefulWidget {
  final data;
  String? currentListingDocumentID;

  propertyDetails(this.data, {this.currentListingDocumentID});

  @override
  propertyDetailsState createState() => propertyDetailsState();
}

class propertyDetailsState extends State<propertyDetails> {
  List<String> _allPropertyImages = [];
  Map<String, dynamic>? data;
  bool _isPropertyImagesLoading = false;

  Future<void> getAllImages() async {
    _allPropertyImages.clear();
    setState(() {
      _isPropertyImagesLoading = true;
    });
    DocumentSnapshot _snapshot = await FirebaseFirestore.instance
        .collection("plots_images")
        .doc(widget.currentListingDocumentID)
        .get();
    print('Current Listing document id: ${widget.currentListingDocumentID}');
    if (_snapshot.exists == true) {
      print('non empty Listing document');
      for (String imageURL
          in (_snapshot.data() as Map<String, dynamic>).values) {
        _allPropertyImages.add(imageURL.toString());
      }
      print(
          'All images in current listing length: ${_allPropertyImages.length}');
      setState(() {
        print(
            'Current Listing document id: ${widget.currentListingDocumentID}');
      });
    } else {
      print('empty Listing document');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init state');
    getAllImages().then((value) {
      print("All images downloaded from plot_images");
      setState(() {
        _isPropertyImagesLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Timestamp posted = widget.data["time"];
    DateTime time = widget.data["time"].toDate();
    var timeHours = time.hour;
    var timeMinutes = time.minute;
    var timeCode = "am";
    if (timeHours >= 12) {
      timeHours = timeHours - 12;
      timeCode = "pm";
    }
    var timeFormat =
        "${time.year}-${time.month}-${time.day} $timeHours:$timeMinutes $timeCode ";
    return SafeArea(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc("${widget.data["seller"]}")
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //DocumentSnapshot doc = snapshot.data.;
          if (snapshot.hasData) {
            data = snapshot.data?.data() as Map<String, dynamic>?;
            // print('Firebase Map: $data');
            return SafeArea(
                child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                elevation: 10,
                //padding: EdgeInsets.all(15),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return chatScreen(widget.data["seller"]);
                  }));
                },
                child: Icon(Icons.message),
              ),
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: Text('Detail'),
              ),
              body: Column(
                children: [
                  Container(
                    color: BackGroundComtainerColor,
                    padding: const EdgeInsets.all(7),
                    //color: Color.fromRGBO(122, 100, 87, 0.7),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: _isPropertyImagesLoading
                        ? Center(child: CircularProgressIndicator())
                        : _allPropertyImages.length == 0
                            ? Center(child: Text('No image found'))
                            : CarouselImages(
                                listImages: _allPropertyImages,
                                height: 250,
                                onTap: (index) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImagePreview(
                                          _allPropertyImages[index]),
                                    ),
                                  );
                                },
                              ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Card(
                            elevation: 12.0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.access_time),
                                      CustomTextWidget(
                                        text1: ' $timeFormat',
                                        text2: '',
                                      ),
                                    ],
                                  ),
                                  /*view location and demand*/
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //   children: [
                                  //     Column(
                                  //       children: [
                                  //         RaisedButton(
                                  //           onPressed: () {
                                  //             Navigator.push(context,
                                  //                 MaterialPageRoute(builder: (context) {
                                  //               return Container(
                                  //                 height: 400,
                                  //                 child: GoogleMap(
                                  //                   mapType: MapType.normal,
                                  //                   markers: Set.from([
                                  //                     Marker(
                                  //                         markerId: MarkerId("main"),
                                  //                         position: LatLng(
                                  //                             double.parse(widget
                                  //                                 .data["marker_x"]),
                                  //                             double.parse(widget
                                  //                                 .data["marker_y"])))
                                  //                   ]),
                                  //                   initialCameraPosition: CameraPosition(
                                  //                       zoom: 9,
                                  //                       target: LatLng(
                                  //                           double.parse(
                                  //                               widget.data["marker_x"]),
                                  //                           double.parse(widget
                                  //                               .data["marker_y"]))),
                                  //                 ),
                                  //               );
                                  //             }));
                                  //           },
                                  //           child: Text(
                                  //             "View Location",
                                  //             style: TextStyle(
                                  //                 color: Colors.black,
                                  //                 fontFamily: "Times New Roman",
                                  //                 fontWeight: FontWeight.w700,
                                  //                 fontSize: 20),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     Container(
                                  //       padding: EdgeInsets.all(5),
                                  //       decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //               color: Colors.blueAccent, width: 2)),
                                  //       child: Column(
                                  //         children: [
                                  //           Text(
                                  //             "Demand:",
                                  //             style: TextStyle(
                                  //                 color: Colors.green,
                                  //                 fontFamily: "Times New Roman",
                                  //                 fontWeight: FontWeight.w700,
                                  //                 fontSize: 20),
                                  //           ),
                                  //           Text(
                                  //             "${widget.data["demand"]}",
                                  //             style: TextStyle(
                                  //                 color: Colors.purple,
                                  //                 fontFamily: "Times New Roman",
                                  //                 fontWeight: FontWeight.w700,
                                  //                 fontSize: 20),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  /*demand and price*/
                                  CustomTextWidget(
                                    text1: 'Demand: ',
                                    text2: '${widget.data["demand"] ?? 'N/A'}',
                                  ),

                                  CustomTextWidget(
                                    text1: 'Sold: ',
                                    text2: '${widget.data["sold"]}',
                                  ),

                                  CustomTextWidget(
                                    text1: 'Posted By: ',
                                    text2: '${data!["businessName"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Owner: ',
                                    text2: '${data!["businessOwner"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Property Type: ',
                                    text2:
                                        '${widget.data["type"]} ${widget.data["subType"]}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(2.0),
                            elevation: 8.0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text1: 'Listing For: ',
                                    text2: '${widget.data["sale"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Province: ',
                                    text2: '${widget.data["provinceName"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'District: ',
                                    text2: '${widget.data["cityName"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Scheme: ',
                                    text2: '${widget.data["schemeName"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Phase: ',
                                    text2: '${widget.data["phaseName"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Block: ',
                                    text2: '${widget.data["blockName"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Sub Block: ',
                                    text2: '${widget.data["subBlockName"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Address: ',
                                    text2: '${widget.data["adress"]}',
                                  ),
                                  CustomTextWidget(
                                    text1: 'Total Area: ',
                                    text2:
                                        '${widget.data["area"]} ${widget.data["areaUnit"]}',
                                  ),
                                  widget.data["isShowPlotInfoToUser"] == null ||
                                          widget.data["isShowPlotInfoToUser"] ==
                                              false
                                      ? Container()
                                      : CustomTextWidget(
                                          text1: 'plot/house/room no: ',
                                          text2:
                                              '${widget.data["area"]} ${widget.data["plotInfo"]}',
                                        ),
                                  /*CustomTextWidget(
                                        text1: 'Floors: ',
                                        text2: '${widget.data["floors"]}',
                                      ),
                                      // Text(
                                      //   " Floors: ${widget.data["floors"]}",
                                      //   style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontFamily: "Times New Roman",
                                      //       fontWeight: FontWeight.w400,
                                      //       fontSize: 20),
                                      // ),
                                      CustomTextWidget(
                                        text1: 'Rooms: ',
                                        text2: '${widget.data["rooms"]}',
                                      ),
                                      // Text(
                                      //   " Rooms: ${widget.data["rooms"]}",
                                      //   style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontFamily: "Times New Roman",
                                      //       fontWeight: FontWeight.w400,
                                      //       fontSize: 20),
                                      // ),
                                      CustomTextWidget(
                                        text1: 'Kitchens: ',
                                        text2: '${widget.data["kitchens"]}',
                                      ),
                                      // Text(
                                      //   " Kitchens: ${widget.data["kitchens"]}",
                                      //   style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontFamily: "Times New Roman",
                                      //       fontWeight: FontWeight.w400,
                                      //       fontSize: 20),
                                      // ),
                                      CustomTextWidget(
                                        text1: 'Washrooms: ',
                                        text2: '${widget.data["washroom"]}',
                                      ),
                                      // Text(
                                      //   " Washrooms: ${widget.data["washroom"]}",
                                      //   style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontFamily: "Times New Roman",
                                      //       fontWeight: FontWeight.w400,
                                      //       fontSize: 20),
                                      // ),
                                      CustomTextWidget(
                                        text1: 'Parkings: ',
                                        text2: '${widget.data["parkings"]}',
                                      ),
                                      // Text(
                                      //   " Parkings: ${widget.data["parkings"]}",
                                      //   style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontFamily: "Times New Roman",
                                      //       fontWeight: FontWeight.w400,
                                      //       fontSize: 20),
                                      // ),*/
                                  /*address component*/
                                  SizedBox(height: 30),
                                  CustomTextWidget(
                                    text1: 'Description: ',
                                  ),

                                  CustomTextWidget(
                                    text1: '',
                                    text2: "${widget.data["description"]}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //},)
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
