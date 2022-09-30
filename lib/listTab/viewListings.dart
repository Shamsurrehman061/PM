import 'dart:async';

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:reale/main.dart';
import "package:reale/propertyDetails.dart";
import 'package:simple_database/simple_database.dart';

import '../list.dart';

class viewListings extends StatefulWidget {
  final subBlock;
  static var subBlockListing;
  viewListings({this.subBlock}) {
    subBlockListing = subBlock;
  }

  @override
  _viewListingsState createState() => _viewListingsState();
}

class _viewListingsState extends State<viewListings> {
  final StreamController<QuerySnapshot> _currentStream =
      StreamController<QuerySnapshot>();

  Stream<QuerySnapshot>? querySnapShot;
  SimpleDatabase listingPropertySelectedBasedOnRange =
      SimpleDatabase(name: 'listingPropertySearchDialog3');
  bool isFilteredExist = false;
  bool isFilteredDataLoading = false;
  bool isShowNoneData = false;

  void CancellingStream() {
    print('add null to stream');
    //_currentStream.sink.add();
    FirebaseFirestore.instance
        .collection("listings")
        .where(
          'provinceName',
          isEqualTo: listingModel.province,
        )
        .where('cityName', isEqualTo: listingModel.city)
        .where("subblock", isEqualTo: widget.subBlock)
        .orderBy("time", descending: true)
        .get()
        .then((QuerySnapshot _query) {
      print('cancelling stream: with data: ${_query.size}');
      _currentStream.sink.add(_query);
      //setState(() {});
    });
    // setState(() {
    //   print('adding default query snapshot to stream controller');
    // });

    // setState(() {
    //   print('refreshing List Widget');
    //   querySnapShot = null;
    // });
  }

  void showNoneDataToUser(bool isTrue) {
    setState(() {
      isShowNoneData = true;
    });
  }

  void addToStream(QuerySnapshot _snap) {
    print('add to query snapshot stream with data size: ${_snap.size}');
    _currentStream.sink.add(_snap);
  }

  // invoke in initState()
  Future<void> getFilterData() async {
    setState(() {
      isFilteredDataLoading = true;
    });
    print('getFilterData() started');
    Map<String, dynamic> propertySearchDialog = Map<String, dynamic>();
    var result = await listingPropertySelectedBasedOnRange.getAll();
    print('result length: ${result.length}');
    if (result.length == 0 || result.length == null) {
      print('(result.length == 0 || result.length == null)');
      // QuerySnapshot _query = await FirebaseFirestore.instance
      //     .collection("listings")
      //     .orderBy("time", descending: true)
      //     .get();

      // here the query for firebase
      print(
          'Province name: ${listingModel.province}, City Name: ${listingModel.city}, sub block Name: ${widget.subBlock}');
      QuerySnapshot _query = await FirebaseFirestore.instance
          .collection("listings")
          .where(
            'provinceName',
            isEqualTo: listingModel.province,
          )
          .where('cityName', isEqualTo: listingModel.city)
          .where("subblock", isEqualTo: widget.subBlock)
          .get();
      _currentStream.sink.add(_query);

      setState(() {
        isFilteredExist = false;
        isFilteredDataLoading = false;
      });
      return;
    } else {
      print('not in (result.length == 0 || result.length == null)');
      for (var item in result) {
        print('All Items: $item');
        propertySearchDialog['selectedProvince'] = item['selectedProvince'];
        propertySearchDialog['selectedCity'] = item['selectedCity'];
        propertySearchDialog['selectPropertySubType'] =
            item['selectPropertySubType'];
        propertySearchDialog['minRange'] = item['minRange'];
        propertySearchDialog['maxRange'] = item['maxRange'];
      }
      print('(var item in await listingPropertySelectedBasedOnRange.getAll())');
      FirebaseFirestore.instance
          .collection('listings')
          .where(
            'provinceName',
            isEqualTo: propertySearchDialog['selectedProvince'],
          )
          .where('cityName', isEqualTo: propertySearchDialog['selectedCity'])
          .where('subType',
              isEqualTo: propertySearchDialog['selectPropertySubType'])
          .where('area',
              isGreaterThanOrEqualTo:
                  propertySearchDialog['minRange'].toString())
          .where('area',
              isLessThanOrEqualTo: propertySearchDialog['maxRange'].toString())
          .where("subblock", isEqualTo: widget.subBlock)
          .get()
          .then((QuerySnapshot query) {
        //querySnapShot = Stream.fromFuture(Future.value(query));
        isFilteredExist = true;
        isFilteredDataLoading = false;
        print('query adding to a stream: <query Legnth>: ${query.docs.length}');
        _currentStream.sink.add(query);
        if (query.docs.length == 0) {
          isShowNoneData = true;
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("Listing Model province: ${listingModel.province}");
    print("Listing Model city: ${listingModel.city}");
    getFilterData();
  }

  @override
  void dispose() {
    if (querySnapShot != null) {
      querySnapShot = null;
    }
    _currentStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('View Listing'),
          actions: [
            Container(
              //height: 40,
              //width: 90,
              color: Colors.transparent,
              //width: MediaQuery.of(context).size.width - 100,
              child: IconButton(
                onPressed: () async {
                  querySnapShot = await showDialog<Stream<QuerySnapshot>>(
                    //useRootNavigator: false,
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ListingRangeDialog(
                        refresh: CancellingStream,
                        addToStream: addToStream,
                        showNoneDataToUser: showNoneDataToUser,
                      );
                    },
                  );
                  setState(() {});
                  print('get stream');
                  print('start searching from this button');
                },
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                //label: Text("Filter"),
              ),
            )
          ],
          // actions: [
          //   IconButton(icon: Icon(Icons.filter_list, color: Colors.white,),
          //       onPressed: () async {
          //         await showDialog<Stream<QuerySnapshot>>(
          //           //useRootNavigator: false,
          //           barrierDismissible: false,
          //           context: context,
          //           builder: (context) {
          //             return RangePropertyDialog();
          //           },
          //         );
          //         setState(() {});
          //         print('get stream');
          //         print('start searching from this button');
          //       }
          //   )
          // ],
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4),
                  height: MediaQuery.of(context).size.height - 50,
                  child: isShowNoneData
                      ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No Data Found',
                                  style: TextStyle(fontSize: 26)),
                              TextButton(
                                onPressed: () {
                                  listingPropertySelectedBasedOnRange.clear();
                                  CancellingStream();
                                  setState(() {
                                    isShowNoneData = false;
                                  });
                                },
                                child: Text('Show All Data'),
                              ),
                            ],
                          ),
                        )
                      : StreamBuilder(
                          // stream: _currentStream.stream,
                          stream: FirebaseFirestore.instance
                              .collection("listings")
                              .where("subblock", arrayContains: widget.subBlock)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            print('Stream builder build method');
                            print('Total data: ${snapshot.data?.size}');
                            if (snapshot.hasData == true) {
                              // data has receive from stream builder
                              QuerySnapshot? data = snapshot.data  ;
                              List<QueryDocumentSnapshot>? documents = data?.docs ;

                              return ListView.builder(
                                  itemCount: documents?.length,
                                  itemBuilder: (context, index) {
                                    print('List builder itemBuilder invoked');
                                    // bool check() {
                                    //   print(currentFilterName);
                                    //   DocumentSnapshot currentDoc = documents[index];
                                    //   var data = currentDoc.data();
                                    //   if (currentFilterName == "province") {
                                    //     if (data["provinceName"]
                                    //         .toString()
                                    //         .toLowerCase()
                                    //         .contains(currentSearch.value.text
                                    //         .toString()
                                    //         .toLowerCase())) {
                                    //       return true;
                                    //     } else {
                                    //       return false;
                                    //     }
                                    //   } else if (currentFilterName == "type") {
                                    //     if (data["type"]
                                    //         .toString()
                                    //         .toLowerCase()
                                    //         .contains(currentSearch.value.text
                                    //         .toString()
                                    //         .toLowerCase())) {
                                    //       return true;
                                    //     } else {
                                    //       return false;
                                    //     }
                                    //   } else if (currentFilterName == "sold") {
                                    //     if (data["sold"]
                                    //         .toString()
                                    //         .toLowerCase()
                                    //         .contains(currentSearch.value.text
                                    //         .toString()
                                    //         .toLowerCase())) {
                                    //       return true;
                                    //     } else {
                                    //       return false;
                                    //     }
                                    //   } else if (currentFilterName == "area") {
                                    //     if (data["area"]
                                    //         .toString()
                                    //         .toLowerCase()
                                    //         .contains(currentSearch.value.text
                                    //         .toString()
                                    //         .toLowerCase())) {
                                    //       return true;
                                    //     } else {
                                    //       return false;
                                    //     }
                                    //   }
                                    // }
                                    DateTime time =( documents![index]
                                        .data()as Map<String,dynamic>)["time"]
                                        .toDate();
                                    var timeHours = time.hour;
                                    var timeMinutes = time.minute;
                                    var timeCode = "am";
                                    if (timeHours >= 12) {
                                      timeHours = timeHours - 12;
                                      timeCode = "pm";
                                    }
                                    var timeFormat =
                                        "${time.year}-${time.month}-${time.day} $timeHours:$timeMinutes $timeCode ";

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return propertyDetails(
                                              documents[index].data());
                                        }));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        child: Card(
                                          elevation: 8,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0,
                                                  color: Colors.white),
                                            ),
                                            margin: const EdgeInsets.all(0),
                                            // margin: EdgeInsets.only(
                                            //     bottom: 40, left: 5, right: 5),
                                            padding: EdgeInsets.all(10),
                                            child: Container(
                                              // show the red stripe if its sold otherwise show nothing
                                              //------
                                              // color: documents[index]
                                              //             .data()["sold"] ==
                                              //         "yes"
                                              //     ? Colors.blueGrey
                                              //     : Colors.white,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: (documents[
                                                                        index]
                                                                    .data()as Map<String,dynamic>)[
                                                                "schemeImageURL"] ==
                                                            null
                                                        ? null
                                                        : NetworkImage(
                                                      (documents[index]
                                                                    .data()as Map<String,dynamic>)[
                                                                "schemeImageURL"],
                                                          ),
                                                    // child: documents[index]
                                                    //                 .data()[
                                                    //             "schemeImageURL"] ==
                                                    //         null
                                                    //     ? Text('No Image')
                                                    //     : Image.network(
                                                    //         documents[index]
                                                    //                 .data()[
                                                    //             "schemeImageURL"],
                                                    //         fit: BoxFit.cover),
                                                    backgroundColor:
                                                        Colors.blue,
                                                    radius: 40,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Stack(
                                                      children: [
                                                        //show the stripe if its sold otherwise show nothing
                                                        ( documents[index].data()as Map<String,dynamic>)[
                                                                    "sold"] ==
                                                                "yes"
                                                            ? Positioned(
                                                                right: 5, // 10
                                                                top: -25, // -15
                                                                //width: 29,
                                                                //height: 70,
                                                                child: Transform
                                                                    .rotate(
                                                                  angle: -0.8,
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    margin: const EdgeInsets
                                                                        .all(0),
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            13),
                                                                    color: Colors
                                                                        .red,
                                                                    //width: 30,
                                                                    height: 105,
                                                                    child: Transform
                                                                        .rotate(
                                                                      angle:
                                                                          1.6,
                                                                      child:
                                                                          Text(
                                                                        'Sold',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),

                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // for time
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(Icons
                                                                    .timer_rounded),
                                                                SizedBox(
                                                                    width: 3),
                                                                Text(
                                                                  "$timeFormat",
                                                                  style:const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "Times New Roman",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                          const  SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              // width:
                                                              //     MediaQuery.of(
                                                              //             context)
                                                              //         .size
                                                              //         .width,
                                                              //---------
                                                              /*for scheme*/
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 170,
                                                                    child: Text(
                                                                      "Scheme : ${(documents[index].data()as Map<String,dynamic>)["schemeName"]}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      softWrap:
                                                                          true,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              "Times New Roman",
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // demand
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    "Demand : ${(documents[index].data()as Map<String,dynamic>)["demand"]}",
                                                                    // overflow:
                                                                    //     TextOverflow
                                                                    //         .ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            "Times New Roman",
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            //posted by
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                               const Text(
                                                                  "Posted By:",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "Times New Roman",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                Text(
                                                                  "${(documents[index].data()as Map<String,dynamic>)["businessName"]}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:const TextStyle(
                                                                      color: Colors
                                                                          .orangeAccent,
                                                                      fontFamily:
                                                                          "Times New Roman",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              ],
                                                            ),
                                                            // plot info
                                                            (documents[index].data()as Map<String,dynamic>)[
                                                                            "isShowPlotInfoToUser"] ==
                                                                        null ||
                                                                (documents[index]
                                                                            .data()as Map<String,dynamic>)["isShowPlotInfoToUser"] ==
                                                                        false
                                                                ? Container()
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                     const Text(
                                                                        "Plot Info:",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontFamily:
                                                                                "Times New Roman",
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize: 16),
                                                                      ),
                                                                      Text(
                                                                        "${(documents[index].data()as Map<String,dynamic>)["plotInfo"]}",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:const TextStyle(
                                                                            color: Colors
                                                                                .orangeAccent,
                                                                            fontFamily:
                                                                                "Times New Roman",
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize: 20),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            // province name
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    "Province : ${(documents[index].data()as Map<String,dynamic>)["cityName"]} ${(documents[index].data()as Map<String,dynamic>)["provinceName"]}",
                                                                    // overflow:
                                                                    //     TextOverflow
                                                                    //         .ellipsis,
                                                                    //maxLines: 2,
                                                                    style:const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            "Times New Roman",
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                               const Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  size: 30,
                                                                )
                                                              ],
                                                            ),
                                                            // seller info

                                                            /*Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                StreamBuilder(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(documents[index]
                                                                              .data()[
                                                                          "seller"])
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      return Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Seller : ",
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontFamily: "Times New Roman",
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 14),
                                                                          ),
                                                                          Text(
                                                                            "${snapshot.data.data()["businessName"]}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.deepOrangeAccent,
                                                                              fontFamily: "Times New Roman",
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 14,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.fade,
                                                                          )
                                                                        ],
                                                                      );
                                                                    } else {
                                                                      return Text(
                                                                          "LOADING");
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),*/
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                    // if (check() == true) {
                                    //
                                    // } else {
                                    //   return SizedBox(
                                    //     height: 0,
                                    //   );
                                    // }

                                    // return FutureBuilder(
                                    //   future: check(),
                                    //   builder: (context, snapshot) {
                                    //     print('Future buider body invoked');
                                    //     //print(documents[index].data());
                                    //     print(
                                    //         'image address: ${documents[index].data()["schemeImageURL"]}');
                                    //
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
                                    //       return GestureDetector(
                                    //         onTap: () {
                                    //           Navigator.push(context,
                                    //               MaterialPageRoute(
                                    //                   builder: (context) {
                                    //             return propertyDetails(
                                    //                 documents[index].data());
                                    //           }));
                                    //         },
                                    //         child: Container(
                                    //           margin: const EdgeInsets.all(2),
                                    //           child: Card(
                                    //             elevation: 8,
                                    //             child: Container(
                                    //               decoration: BoxDecoration(
                                    //                 // changing color based on the sold or un-sold
                                    //                 //--------------
                                    //                 // color: documents[index]
                                    //                 //             .data()["sold"] ==
                                    //                 //         "yes"
                                    //                 //     ? Colors.blueGrey
                                    //                 //     : Colors.white,
                                    //                 border: Border.all(
                                    //                     width: 0,
                                    //                     color: Colors.white),
                                    //               ),
                                    //               margin: const EdgeInsets.all(0),
                                    //               // margin: EdgeInsets.only(
                                    //               //     bottom: 40, left: 5, right: 5),
                                    //               padding: EdgeInsets.all(10),
                                    //               child: Container(
                                    //                 // show the red stripe if its sold otherwise show nothing
                                    //                 //------
                                    //                 // color: documents[index]
                                    //                 //             .data()["sold"] ==
                                    //                 //         "yes"
                                    //                 //     ? Colors.blueGrey
                                    //                 //     : Colors.white,
                                    //                 child: Row(
                                    //                   children: [
                                    //                     CircleAvatar(
                                    //                       backgroundImage: documents[
                                    //                                           index]
                                    //                                       .data()[
                                    //                                   "schemeImageURL"] ==
                                    //                               null
                                    //                           ? null
                                    //                           : NetworkImage(
                                    //                               documents[index]
                                    //                                       .data()[
                                    //                                   "schemeImageURL"],
                                    //                             ),
                                    //                       // child: documents[index]
                                    //                       //                 .data()[
                                    //                       //             "schemeImageURL"] ==
                                    //                       //         null
                                    //                       //     ? Text('No Image')
                                    //                       //     : Image.network(
                                    //                       //         documents[index]
                                    //                       //                 .data()[
                                    //                       //             "schemeImageURL"],
                                    //                       //         fit: BoxFit.cover),
                                    //                       backgroundColor:
                                    //                           Colors.blue,
                                    //                       radius: 40,
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 5,
                                    //                     ),
                                    //                     Flexible(
                                    //                       child: Stack(
                                    //                         children: [
                                    //                           // show the stripe if its sold otherwise show nothing
                                    //                           documents[index].data()[
                                    //                                       "sold"] ==
                                    //                                   "yes"
                                    //                               ? Positioned(
                                    //                                   right: 5, // 10
                                    //                                   top: -25, // -15
                                    //                                   //width: 29,
                                    //                                   //height: 70,
                                    //                                   child: Transform
                                    //                                       .rotate(
                                    //                                     angle: -0.8,
                                    //                                     child:
                                    //                                         Container(
                                    //                                       alignment:
                                    //                                           Alignment
                                    //                                               .centerLeft,
                                    //                                       margin: const EdgeInsets
                                    //                                           .all(0),
                                    //                                       padding: const EdgeInsets
                                    //                                               .only(
                                    //                                           top: 0,
                                    //                                           left: 0,
                                    //                                           right:
                                    //                                               0,
                                    //                                           bottom:
                                    //                                               13),
                                    //                                       color: Colors
                                    //                                           .red,
                                    //                                       //width: 30,
                                    //                                       height: 105,
                                    //                                       child: Transform
                                    //                                           .rotate(
                                    //                                         angle:
                                    //                                             1.6,
                                    //                                         child:
                                    //                                             Text(
                                    //                                           'Sold',
                                    //                                           style:
                                    //                                               TextStyle(
                                    //                                             fontWeight:
                                    //                                                 FontWeight.bold,
                                    //                                             color:
                                    //                                                 Colors.white,
                                    //                                           ),
                                    //                                         ),
                                    //                                       ),
                                    //                                     ),
                                    //                                   ),
                                    //                                 )
                                    //                               : Container(),
                                    //
                                    //                           Column(
                                    //                             crossAxisAlignment:
                                    //                                 CrossAxisAlignment
                                    //                                     .start,
                                    //                             children: [
                                    //                               // for time
                                    //                               Row(
                                    //                                 mainAxisAlignment:
                                    //                                     MainAxisAlignment
                                    //                                         .start,
                                    //                                 children: [
                                    //                                   Icon(Icons
                                    //                                       .timer_rounded),
                                    //                                   SizedBox(
                                    //                                       width: 3),
                                    //                                   Text(
                                    //                                     "$timeFormat",
                                    //                                     style: TextStyle(
                                    //                                         color: Colors
                                    //                                             .black,
                                    //                                         fontFamily:
                                    //                                             "Times New Roman",
                                    //                                         fontWeight:
                                    //                                             FontWeight
                                    //                                                 .w700,
                                    //                                         fontSize:
                                    //                                             14),
                                    //                                   ),
                                    //                                 ],
                                    //                               ),
                                    //                               SizedBox(
                                    //                                 height: 10,
                                    //                               ),
                                    //                               Container(
                                    //                                 // width:
                                    //                                 //     MediaQuery.of(
                                    //                                 //             context)
                                    //                                 //         .size
                                    //                                 //         .width,
                                    //                                 //---------
                                    //                                 /*for scheme*/
                                    //                                 child: Row(
                                    //                                   mainAxisAlignment:
                                    //                                       MainAxisAlignment
                                    //                                           .start,
                                    //                                   children: [
                                    //                                     SizedBox(
                                    //                                       width: 170,
                                    //                                       child: Text(
                                    //                                         "Scheme : ${documents[index].data()["schemeName"]}",
                                    //                                         overflow:
                                    //                                             TextOverflow
                                    //                                                 .ellipsis,
                                    //                                         maxLines:
                                    //                                             2,
                                    //                                         softWrap:
                                    //                                             true,
                                    //                                         style: TextStyle(
                                    //                                             color: Colors
                                    //                                                 .black,
                                    //                                             fontFamily:
                                    //                                                 "Times New Roman",
                                    //                                             fontWeight: FontWeight
                                    //                                                 .w700,
                                    //                                             fontSize:
                                    //                                                 14),
                                    //                                       ),
                                    //                                     ),
                                    //                                   ],
                                    //                                 ),
                                    //                               ),
                                    //                               // demand
                                    //                               Row(
                                    //                                 mainAxisAlignment:
                                    //                                     MainAxisAlignment
                                    //                                         .spaceBetween,
                                    //                                 children: [
                                    //                                   Flexible(
                                    //                                     child: Text(
                                    //                                       "Demand : ${documents[index].data()["demand"]}",
                                    //                                       // overflow:
                                    //                                       //     TextOverflow
                                    //                                       //         .ellipsis,
                                    //                                       maxLines: 2,
                                    //                                       style: TextStyle(
                                    //                                           color: Colors
                                    //                                               .black,
                                    //                                           fontFamily:
                                    //                                               "Times New Roman",
                                    //                                           fontWeight:
                                    //                                               FontWeight
                                    //                                                   .w700,
                                    //                                           fontSize:
                                    //                                               14),
                                    //                                     ),
                                    //                                   ),
                                    //                                 ],
                                    //                               ),
                                    //                               //posted by
                                    //                               Row(
                                    //                                 mainAxisAlignment:
                                    //                                     MainAxisAlignment
                                    //                                         .start,
                                    //                                 children: [
                                    //                                   Text(
                                    //                                     "Posted By:",
                                    //                                     textAlign:
                                    //                                         TextAlign
                                    //                                             .left,
                                    //                                     style: TextStyle(
                                    //                                         color: Colors
                                    //                                             .black,
                                    //                                         fontFamily:
                                    //                                             "Times New Roman",
                                    //                                         fontWeight:
                                    //                                             FontWeight
                                    //                                                 .w700,
                                    //                                         fontSize:
                                    //                                             16),
                                    //                                   ),
                                    //                                   Text(
                                    //                                     "${documents[index].data()["businessName"]}",
                                    //                                     textAlign:
                                    //                                         TextAlign
                                    //                                             .left,
                                    //                                     style: TextStyle(
                                    //                                         color: Colors
                                    //                                             .orangeAccent,
                                    //                                         fontFamily:
                                    //                                             "Times New Roman",
                                    //                                         fontWeight:
                                    //                                             FontWeight
                                    //                                                 .w700,
                                    //                                         fontSize:
                                    //                                             20),
                                    //                                   ),
                                    //                                 ],
                                    //                               ),
                                    //                               // plot info
                                    //                               documents[index].data()[
                                    //                                               "isShowPlotInfoToUser"] ==
                                    //                                           null ||
                                    //                                       documents[index]
                                    //                                               .data()["isShowPlotInfoToUser"] ==
                                    //                                           false
                                    //                                   ? Container()
                                    //                                   : Row(
                                    //                                       mainAxisAlignment:
                                    //                                           MainAxisAlignment
                                    //                                               .start,
                                    //                                       children: [
                                    //                                         Text(
                                    //                                           "Plot Info:",
                                    //                                           textAlign:
                                    //                                               TextAlign.left,
                                    //                                           style: TextStyle(
                                    //                                               color: Colors
                                    //                                                   .black,
                                    //                                               fontFamily:
                                    //                                                   "Times New Roman",
                                    //                                               fontWeight:
                                    //                                                   FontWeight.w700,
                                    //                                               fontSize: 16),
                                    //                                         ),
                                    //                                         Text(
                                    //                                           "${documents[index].data()["plotInfo"]}",
                                    //                                           textAlign:
                                    //                                               TextAlign.left,
                                    //                                           style: TextStyle(
                                    //                                               color: Colors
                                    //                                                   .orangeAccent,
                                    //                                               fontFamily:
                                    //                                                   "Times New Roman",
                                    //                                               fontWeight:
                                    //                                                   FontWeight.w700,
                                    //                                               fontSize: 20),
                                    //                                         ),
                                    //                                       ],
                                    //                                     ),
                                    //                               // province name
                                    //                               Row(
                                    //                                 mainAxisAlignment:
                                    //                                     MainAxisAlignment
                                    //                                         .start,
                                    //                                 children: [
                                    //                                   Flexible(
                                    //                                     child: Text(
                                    //                                       "Province : ${documents[index].data()["cityName"]} ${documents[index].data()["provinceName"]}",
                                    //                                       // overflow:
                                    //                                       //     TextOverflow
                                    //                                       //         .ellipsis,
                                    //                                       //maxLines: 2,
                                    //                                       style: TextStyle(
                                    //                                           color: Colors
                                    //                                               .black,
                                    //                                           fontFamily:
                                    //                                               "Times New Roman",
                                    //                                           fontWeight:
                                    //                                               FontWeight
                                    //                                                   .w700,
                                    //                                           fontSize:
                                    //                                               14),
                                    //                                     ),
                                    //                                   ),
                                    //                                   Icon(
                                    //                                     Icons
                                    //                                         .location_on,
                                    //                                     size: 30,
                                    //                                   )
                                    //                                 ],
                                    //                               ),
                                    //                               // seller info
                                    //
                                    //                               /*Row(
                                    //                                 mainAxisAlignment:
                                    //                                     MainAxisAlignment
                                    //                                         .start,
                                    //                                 children: [
                                    //                                   StreamBuilder(
                                    //                                     stream: FirebaseFirestore
                                    //                                         .instance
                                    //                                         .collection(
                                    //                                             "users")
                                    //                                         .doc(documents[index]
                                    //                                                 .data()[
                                    //                                             "seller"])
                                    //                                         .snapshots(),
                                    //                                     builder: (context,
                                    //                                         snapshot) {
                                    //                                       if (snapshot
                                    //                                           .hasData) {
                                    //                                         return Row(
                                    //                                           mainAxisAlignment:
                                    //                                               MainAxisAlignment.center,
                                    //                                           children: [
                                    //                                             Text(
                                    //                                               "Seller : ",
                                    //                                               style: TextStyle(
                                    //                                                   color: Colors.black,
                                    //                                                   fontFamily: "Times New Roman",
                                    //                                                   fontWeight: FontWeight.w700,
                                    //                                                   fontSize: 14),
                                    //                                             ),
                                    //                                             Text(
                                    //                                               "${snapshot.data.data()["businessName"]}",
                                    //                                               style:
                                    //                                                   TextStyle(
                                    //                                                 color: Colors.deepOrangeAccent,
                                    //                                                 fontFamily: "Times New Roman",
                                    //                                                 fontWeight: FontWeight.w700,
                                    //                                                 fontSize: 14,
                                    //                                               ),
                                    //                                               overflow:
                                    //                                                   TextOverflow.fade,
                                    //                                             )
                                    //                                           ],
                                    //                                         );
                                    //                                       } else {
                                    //                                         return Text(
                                    //                                             "LOADING");
                                    //                                       }
                                    //                                     },
                                    //                                   ),
                                    //                                 ],
                                    //                               ),*/
                                    //                             ],
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     } else {
                                    //       return SizedBox(
                                    //         height: 0,
                                    //       );
                                    //     }
                                    //   },
                                    // );
                                  });
                            } else {
                              return Container(
                                child: Center(
                                  child: Text('No Content'),
                                ),
                              );
                            }
                          },
                        ),
                  // child: StreamBuilder(
                  //   stream: FirebaseFirestore.instance
                  //       .collection("listings")
                  //       .where("subblock", isEqualTo: widget.subBlock)
                  //       .snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       QuerySnapshot data = snapshot.data;
                  //       List<QueryDocumentSnapshot> documents = data.docs;
                  //
                  //       return ListView.builder(
                  //           itemCount: documents.length,
                  //           itemBuilder: (context, index) {
                  //             if (snapshot.hasData == true) {
                  //               DateTime time =
                  //                   documents[index].data()["time"].toDate();
                  //               var timeHours = time.hour;
                  //               var timeMinutes = time.minute;
                  //               var timeCode = "am";
                  //               if (timeHours >= 12) {
                  //                 timeHours = timeHours - 12;
                  //                 timeCode = "pm";
                  //               }
                  //               var timeFormat =
                  //                   "${time.year}-${time.month}-${time.day} $timeHours:$timeMinutes $timeCode ";
                  //
                  //               return Container(
                  //                 decoration: BoxDecoration(
                  //                     color: documents[index].data()["sold"] ==
                  //                             "yes"
                  //                         ? Colors.blueGrey
                  //                         : Colors.white,
                  //                     border: Border.all(width: 2)),
                  //                 margin: EdgeInsets.only(
                  //                     bottom: 40, left: 5, right: 5),
                  //                 padding: EdgeInsets.all(20),
                  //                 child: RaisedButton(
                  //                   elevation: 0,
                  //                   color:
                  //                       documents[index].data()["sold"] == "yes"
                  //                           ? Colors.blueGrey
                  //                           : Colors.white,
                  //                   onPressed: () {
                  //                     Navigator.push(context,
                  //                         MaterialPageRoute(builder: (context) {
                  //                       return propertyDetails(
                  //                           documents[index].data());
                  //                     }));
                  //                   },
                  //                   child: Column(
                  //                     children: [
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             "Time : $timeFormat",
                  //                             style: TextStyle(
                  //                                 color: Colors.black,
                  //                                 fontFamily: "Times New Roman",
                  //                                 fontWeight: FontWeight.w700,
                  //                                 fontSize: 16),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       Container(
                  //                         width:
                  //                             MediaQuery.of(context).size.width,
                  //                         child: Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.start,
                  //                           children: [
                  //                             Text(
                  //                               "Scheme : ${documents[index].data()["schemeName"]}",
                  //                               overflow: TextOverflow.ellipsis,
                  //                               style: TextStyle(
                  //                                   color: Colors.black,
                  //                                   fontFamily:
                  //                                       "Times New Roman",
                  //                                   fontWeight: FontWeight.w700,
                  //                                   fontSize: 16),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Text(
                  //                             "Province : ${documents[index].data()["provinceName"]}",
                  //                             overflow: TextOverflow.ellipsis,
                  //                             style: TextStyle(
                  //                                 color: Colors.black,
                  //                                 fontFamily: "Times New Roman",
                  //                                 fontWeight: FontWeight.w700,
                  //                                 fontSize: 16),
                  //                           ),
                  //                           Icon(
                  //                             Icons.location_on,
                  //                             size: 50,
                  //                           )
                  //                         ],
                  //                       ),
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         children: [
                  //                           StreamBuilder(
                  //                             stream: FirebaseFirestore.instance
                  //                                 .collection("users")
                  //                                 .doc(documents[index]
                  //                                     .data()["seller"])
                  //                                 .snapshots(),
                  //                             builder: (context, snapshot) {
                  //                               if (snapshot.hasData) {
                  //                                 return Row(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   children: [
                  //                                     Text(
                  //                                       "Seller : ",
                  //                                       style: TextStyle(
                  //                                           color: Colors.black,
                  //                                           fontFamily:
                  //                                               "Times New Roman",
                  //                                           fontWeight:
                  //                                               FontWeight.w700,
                  //                                           fontSize: 20),
                  //                                     ),
                  //                                     Text(
                  //                                       "${snapshot.data.data()["businessName"]}",
                  //                                       style: TextStyle(
                  //                                         color: Colors
                  //                                             .deepOrangeAccent,
                  //                                         fontFamily:
                  //                                             "Times New Roman",
                  //                                         fontWeight:
                  //                                             FontWeight.w700,
                  //                                         fontSize: 20,
                  //                                       ),
                  //                                       overflow:
                  //                                           TextOverflow.fade,
                  //                                     )
                  //                                   ],
                  //                                 );
                  //                               } else {
                  //                                 return Text("LOADING");
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               );
                  //             } else {
                  //               return SizedBox(
                  //                 height: 0,
                  //               );
                  //             }
                  //           });
                  //     } else {
                  //       return Text("LOADING");
                  //     }
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListingRangeDialog extends StatefulWidget {
  Function refresh;
  Function addToStream;
  Function showNoneDataToUser;
  ListingRangeDialog({required this.refresh, required this.addToStream, required this.showNoneDataToUser});
  @override
  _ListingRangeDialogState createState() => _ListingRangeDialogState();
}

class _ListingRangeDialogState extends State<ListingRangeDialog> {
  // Future<void> getAllCitiesFromFirebase() async {
  //   print('invoked.....getAllCitiesFromFirebase()');
  //   QuerySnapshot _snapshot = await FirebaseFirestore.instance
  //       .collection("cities")
  //       .orderBy("name", descending: false)
  //       .get();
  //
  //   _allCityFromFirebase = [];
  //   _allCityIDFromFirebase = [];
  //
  //   print('city snapshot length: ${_snapshot.docs.length}');
  //   //var el = _snapshot.docs;
  //   for (var e in _snapshot.docs) {
  //     if (e.data() != null) {
  //       print('current province id: $currentProvinceID');
  //       if (e.data()["provinceID"] == currentProvinceID) {
  //         _allCityFromFirebase.add(e.data()["name"]);
  //         _allCityIDFromFirebase.add(e.data()["id"]);
  //       }
  //     }
  //   }
  //   print('all cities names from firebase: $_allCityFromFirebase');
  //   setState(() {});
  // }

  // List<String> _allProvinceFromFirebase = [];
  // List<String> _allProvinceIDFromFirebase = [];
  // String currentProvinceID = '';

  // List<String> _allCityFromFirebase = [];
  // List<String> _allCityIDFromFirebase = [];
  // String currentCityID;

  // bool _isProvinceSelected = false;
  // bool _isCitySelected = false;

  bool _isSubTypeSelected = false;
  bool _isRangeSelected = false;

  String selectedProvince = listingModel.province;
  String selectedCity = listingModel.city;
  String? propertySubType = '';
  int minRange = 0;
  int maxRange = 0;
  String areaUnit = '';

  List<String> subtypes = [
    'Food Court',
    "Factory",
    "Gym",
    "Hall",
    "Office",
    "Shop",
    "Theatre",
    "Warehouse",
    'Farm House',
    'Guest House',
    'Hostel',
    'House',
    'Penthouse',
    "Room",
    'Villas',
    'Commercial Land',
    'Residential Land',
    'Plot File',
  ];

  SimpleDatabase listingPropertySelectedBasedOnRange = // name changed
      SimpleDatabase(name: 'listingPropertySearchDialog3'); // name changed
  int _totalRecord = 0;

  SimpleDatabase? propertyDialogData;
  bool isLoading = false;

  @override
  void initState() {
    listingPropertySelectedBasedOnRange
        .count()
        .then((value) => _totalRecord = value);
    setState(() {
      isLoading = true;
    });
    super.initState();
    print('init state...range dialog');
    // FirebaseFirestore.instance
    //     .collection("province")
    //     .orderBy("name", descending: false)
    //     .get()
    //     .then((QuerySnapshot _snapshot) {
    //   var el = _snapshot.docs;
    //   // _allProvinceFromFirebase = [];
    //   // for (var e in el) {
    //   //   if (e.data() != null) {
    //   //     _allProvinceFromFirebase.add(e.data()["name"]);
    //   //     _allProvinceIDFromFirebase.add(e.data()["id"]);
    //   //   }
    //   // }
    //   // print('All provinces: $_allProvinceFromFirebase');
    //   // print('All provinces ID: $_allProvinceIDFromFirebase');
    //   setState(() {});
    //
    //   // get all data from database and show it to the dialog
    //   propertyDialogData =
    //       SimpleDatabase(name: 'listingPropertySearchDialog2');
    //   propertyDialogData.getAll().then((List<dynamic> userData) {
    //     isLoading = false;
    //     print('User All data: $userData');
    //     if(userData.length > 0){
    //       selectedProvince = userData[0]['selectedProvince'];
    //       selectedCity = userData[0]['selectedCity'];
    //       propertySubType = userData[0]['selectPropertySubType'];
    //       minRange = userData[0]['minRange'];
    //       maxRange = userData[0]['maxRange'];
    //       areaUnit = userData[0]['areaUnit'];
    //     } else {
    //       print('no user stored filter data found');
    //     }
    //     setState(() {});
    //   });
    // });
    // get all data from database and show it to the dialog
    propertyDialogData = SimpleDatabase(name: 'listingPropertySearchDialog2');
    propertyDialogData?.getAll().then((List<dynamic> userData) {
      isLoading = false;
      print('User All data: $userData');
      if (userData.length > 0) {
        selectedProvince = userData[0]['selectedProvince'];
        selectedCity = userData[0]['selectedCity'];
        propertySubType = userData[0]['selectPropertySubType'];
        minRange = userData[0]['minRange'];
        maxRange = userData[0]['maxRange'];
        areaUnit = userData[0]['areaUnit'];
      } else {
        print('no user stored filter data found');
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // already have city and province
    return Dialog(
      child: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //width: 200,
              height: 240,
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  // province
                  // DropDown(
                  //   items: _allProvinceFromFirebase,
                  //   hint: selectedProvince.length > 0 ? Text(selectedProvince) : Text("select province"),
                  //   //initialValue: _allProvinceFromFirebase.length == 0 ? selectedProvince : null,
                  //   onChanged: (val) async {
                  //     print('onChanged callback');
                  //     selectedProvince = val;
                  //     print('selected province: $val');
                  //     int provinceIndex = _allProvinceFromFirebase.indexOf(val);
                  //     print('province index: $provinceIndex');
                  //     if (provinceIndex != -1 && provinceIndex != null) {
                  //       currentProvinceID =
                  //           _allProvinceIDFromFirebase[provinceIndex].toString();
                  //       print('current province ID: $currentProvinceID');
                  //       print('province selected: $_isProvinceSelected');
                  //       setState(() {});
                  //       await getAllCitiesFromFirebase();
                  //     }
                  //   },
                  // ),
                  // SizedBox(height: 5),
                  // city
                  // DropDown(
                  //   items: _allCityFromFirebase,
                  //   hint:  selectedCity.length > 0 ? Text(selectedCity) : Text("select city"),
                  //   onChanged: _allCityFromFirebase.length > 0
                  //       ? (val) async {
                  //     print('onChanged callback');
                  //     selectedCity = val;
                  //     currentCityID = _allCityIDFromFirebase[
                  //     _allCityFromFirebase.indexOf(val)]
                  //         .toString();
                  //     print('selected city ID: $currentCityID');
                  //
                  //     // setState(() {
                  //     //   _isCitySelected = true;
                  //     // });
                  //   }
                  //       : null,
                  // ),
                  // SizedBox(height: 5),
                  //sub type

                  DropDown(
                      items: subtypes,
                      hint: propertySubType != null
                          ? Text(propertySubType!)
                          : Text("select sub type"),
                      onChanged: (String? val) async {
                        _isSubTypeSelected = true;
                        propertySubType = val;
                        print('onChanged callback');
                        // setState(() {
                        //   _isSubTypeSelected = true;
                        // });
                      }),
                 const SizedBox(height: 5),
                  // range
                  // SliderTheme(
                  //   data: SliderThemeData(
                  //     //activeTickMarkColor: Colors.blue.withOpacity(0.4),
                  //     //overlayColor: Colors.black45,
                  //     /// overlappingShapeStrokeColor: Colors.teal[300],
                  //     showValueIndicator: ShowValueIndicator.always,
                  //     disabledThumbColor: Colors.grey,
                  //   ),
                  //   child: Row(
                  //     //mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
                  //       //SizedBox(width: 10),
                  //       Expanded(
                  //         child: RangeDialog(
                  //           populateMinMaxRange: (double _minRange, double _maxRange) {
                  //             minRange = _minRange;
                  //             maxRange = _maxRange;
                  //             _isRangeSelected = true;
                  //             // setState(() {
                  //             //   _isRangeSelected = true;
                  //             // });
                  //           },
                  //         ),
                  //       ),
                  //       //SizedBox(width: 10),
                  //       Text('1000', style: TextStyle(fontWeight: FontWeight.bold)),
                  //     ],
                  //   ),
                  // ),
                  /*Row for min and max drop down*/
                  Row(
                    children: [
                      DropDown(
                          items: [5, 10, 20, 50, 100],
                          hint: Text(minRange.toString()),
                          onChanged: (int? val) async {
                            print('min range: $val');
                            minRange = val!;
                            _isRangeSelected = true;
                          }),
                      Spacer(),
                      DropDown(
                          items: [300, 500, 1000, 2000, 4000, 5000],
                          hint: Text(maxRange.toString()),
                          onChanged: (int? val) async {
                            print('max range: $val');
                            maxRange = val!;
                          }),
                    ],
                  ),
                  SizedBox(height: 5),
                  // drop down for area unit
                  DropDown(
                      items: ["Squareft", "Marla", "Canal", "Acre", "Hectare"],
                      hint: areaUnit.length > 0
                          ? Text(areaUnit)
                          : Text("Select Unit"),
                      onChanged: (String? val) async {
                        areaUnit = val!;
                      }),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      // search button
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            print('Selected province: $selectedProvince');
                            //print('Selected province ID: $currentProvinceID');
                            print('Selected city: $selectedCity');
                            //print('Selected city ID: $currentCityID');
                            print('property sub type: $propertySubType');
                            print('Min Range: $minRange');
                            print('Max Range: $maxRange');

                            print('setState() selected....');
                            // setting up the database
                          });
                          // storing values into database
                          SimpleDatabase listingPropertySelectedBasedOnRange =
                              SimpleDatabase(
                                  name: 'listingPropertySearchDialog2');
                          await listingPropertySelectedBasedOnRange.clear();
                          // map represent user current selected value
                          Map<String, dynamic> propertySearchDialog =
                              Map<String, dynamic>();

                          propertySearchDialog['selectedProvince'] =
                              selectedProvince;
                          propertySearchDialog['selectedCity'] = selectedCity;
                          propertySearchDialog['selectPropertySubType'] =
                              propertySubType;
                          propertySearchDialog['minRange'] = minRange;
                          propertySearchDialog['maxRange'] = maxRange;
                          propertySearchDialog['areaUnit'] = areaUnit;

                          // adding user provided value to the database
                          await listingPropertySelectedBasedOnRange
                              .add(propertySearchDialog);

                          print('Range Based Property Selection attribute: ');
                          Future<QuerySnapshot> querySnap;
                          for (var item
                              in await listingPropertySelectedBasedOnRange
                                  .getAll()) {
                            print('item: $item');
                          }
                          if (_isRangeSelected && _isSubTypeSelected) {
                            querySnap = FirebaseFirestore.instance
                                .collection('listings')
                                .where(
                                  'provinceName',
                                  isEqualTo: selectedProvince,
                                )
                                .where('cityName', isEqualTo: selectedCity)
                                .where('subType', isEqualTo: propertySubType)
                                .where('area',
                                    isGreaterThanOrEqualTo: minRange.toString())
                                .where('area',
                                    isLessThanOrEqualTo: maxRange.toString())
                                .where("subblock",
                                    isEqualTo: viewListings.subBlockListing)
                                .get();
                          } else if (_isSubTypeSelected &&
                              _isRangeSelected == false) {
                            querySnap = FirebaseFirestore.instance
                                .collection('listings')
                                .where(
                                  'provinceName',
                                  isEqualTo: selectedProvince,
                                )
                                .where('cityName', isEqualTo: selectedCity)
                                .where('subType', isEqualTo: propertySubType)
                                .where("subblock",
                                    isEqualTo: viewListings.subBlockListing)
                                .
                                //where('area', isGreaterThanOrEqualTo: minRange.toString()).
                                //where('area', isLessThanOrEqualTo: maxRange.toString()).
                                get();
                          } else if (_isRangeSelected &&
                              _isSubTypeSelected == false) {
                            print(
                                '_isRangeSelected && _isSubTypeSelected == false');
                            querySnap = FirebaseFirestore.instance
                                .collection('listings')
                                .where(
                                  'provinceName',
                                  isEqualTo: selectedProvince,
                                )
                                .where('cityName', isEqualTo: selectedCity)
                                .where('area',
                                    isGreaterThanOrEqualTo: minRange.toString())
                                .where('area',
                                    isLessThanOrEqualTo: maxRange.toString())
                                .where("subblock",
                                    isEqualTo: viewListings.subBlockListing)
                                .get();
                          } else {
                            // rand sub type both are not selected
                            querySnap = FirebaseFirestore.instance
                                .collection('listings')
                                .where(
                                  'provinceName',
                                  isEqualTo: selectedProvince,
                                )
                                .where('cityName', isEqualTo: selectedCity)
                                .where("subblock",
                                    isEqualTo: viewListings.subBlockListing)
                                .
                                // where('subType', isEqualTo: propertySubType).
                                //where('area', isGreaterThanOrEqualTo: minRange.toString()).
                                //where('area', isLessThanOrEqualTo: maxRange.toString()).
                                get();
                          }
                          // // firebase searching start
                          // querySnap = FirebaseFirestore.instance.collection('listings').
                          // where('provinceName', isEqualTo: selectedProvince.toLowerCase(), ).
                          // where('cityName', isEqualTo: selectedCity.toLowerCase()).
                          // where('subType', isEqualTo: propertySubType).
                          // where('area', isGreaterThanOrEqualTo: minRange.toString()).
                          // where('area', isLessThanOrEqualTo: maxRange.toString()).
                          // get();
                          //querySnap.listen((event) {print('Total Document: ${event.docs.length}');});
                          //where('cityName', isEqualTo: selectedCity).
                          //where('subType', isEqualTo: propertySubType).
                          //where('area', isGreaterThan: minRange).
                          //where('area', isLessThanOrEqualTo: maxRange).
                          //orderBy('cityName', descending: false);
                          print('pre loading');
                          //int totalLength = await querySnap.length;
                          //print('total query Lenght: $totalLength');

                          querySnap.then((QuerySnapshot _snap) async {
                            if (_snap.docs.length == 0) {
                              // no data found
                              print('if- Total Docs: ${_snap.docs.length}');

                              // TODO: show no data to user on the screen
                              await showDialog(
                                context: context,
                                builder: (context) => AlertErrorWidget(),
                              );
                              widget.showNoneDataToUser(true);
                            } else {
                              // data found
                              print('else- Total Docs: ${_snap.docs.length}');
                              widget.addToStream(_snap);
                              Navigator.of(context).pop();
                              //Navigator.of(context).pop(Stream.fromFuture(Future.value(_snap)));
                            }
                          });

                          print('post loading');
                          int totalDocuments = -1;
                          // querySnap.listen((QuerySnapshot snap) {
                          //   print('Total Documents: ${snap.docs.length}');
                          //   totalDocuments = snap.docs.length;
                          //
                          // });

                          // if(totalDocuments == 0){
                          //   print('if Total Document: $totalDocuments');
                          //   // show dialog and return
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return AlertErrorWidget();
                          //     },
                          //   );
                          //
                          //   //Navigator.of(context).pop();
                          // }
                          // else if (totalDocuments == -1){
                          //   setState(() {
                          //
                          //   });
                          //   print('else-if Total Document: $totalDocuments');
                          //   return ProgressWidget();
                          // }
                          // else{
                          //   print('else Total Document: $totalDocuments');
                          //   Navigator.of(context).pop(querySnap);
                          // }
                          //Navigator.of(context).pop(querySnap);
                        },
                        child: Text('search'),
                      ),
                      // exit button
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text('Exit'),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: _totalRecord > 0
                            ? () async {
                                await listingPropertySelectedBasedOnRange
                                    .clear();
                                widget.refresh();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text('clear Filter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
