import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'package:reale/listTab/selectSchemeNonScheme.dart';
import "package:reale/listTab/viewScheme.dart";
import 'package:reale/main.dart';
import 'package:reale/widgets/stylishCustomButton.dart';

class viewCity extends StatefulWidget {
  final province;
  viewCity({this.province});

  @override
  _viewCityState createState() => _viewCityState();
}

class _viewCityState extends State<viewCity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<dynamic>(
          stream: FirebaseFirestore.instance
              .collection("cities")
              .where("provinceID", isEqualTo: "${widget.province}")
              .orderBy("name", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docData = snapshot.data;
              var docs = docData.docs;

              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.green,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Select District',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            margin:
                                const EdgeInsets.only(top: 15, bottom: 5, left: 20),
                            child: StylishCustomButton(
                              onPressed: () {
                                listingModel.city = docs[index]["name"];
                                // print('city name: ${docs[index]["name"]}');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SelectSchemeNonScheme(
                                      city: "${docs[index]["id"]}");
                                  return viewSceme(
                                      city: "${docs[index]["id"]}");
                                }));
                              },
                              text: docs[index]["name"],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          margin: EdgeInsets.only(top: 15, bottom: 5),
                          child: StylishCustomButton(
                            onPressed: () {
                              listingModel.city = docs[index]["name"];
                              // print('city name: ${docs[index]["name"]}');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SelectSchemeNonScheme(city: "${docs[index]["id"]}");
                                return viewSceme(city: "${docs[index]["id"]}");
                              }));
                            },
                            text: docs[index]["name"],
                          ),
                        ),
                      );
                    }
                  });
            } else {
              return const Center(
                child: Text('No Content'),
              );
            }
          }),
    );
  }
}
