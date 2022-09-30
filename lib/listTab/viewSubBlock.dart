import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:reale/listTab/viewListings.dart";
import 'package:reale/widgets/stylishCustomButton.dart';

class viewSubBlock extends StatefulWidget {
  final block;

  viewSubBlock({this.block});

  @override
  viewSubBlockState createState() => viewSubBlockState();
}

class viewSubBlockState extends State<viewSubBlock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<dynamic>(
            stream: FirebaseFirestore.instance
                .collection("subblock")
                .where("blockID", isEqualTo: "${widget.block}")
                .orderBy("name", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              print('snapshot.hasData dd: ${snapshot.hasData}');
              if (snapshot.hasData) {
                var docData = snapshot.data;
                var docs = docData.docs;
                print("print data $docs");
                // builder: (BuildContext context, snapshot) {
                return !snapshot.hasData
                    ? const Text('PLease Wait')
                    : ListView.builder(
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
                                      'Select Sub Block',
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
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 5, left: 20),
                                  child: StylishCustomButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return viewListings(
                                          subBlock: "${docs[index]["id"]}",
                                        );
                                      }));
                                    },
                                    text: docs[index]["name"].toString(),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width - 50,
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 5),
                                child: StylishCustomButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return viewListings(
                                        subBlock: "${docs[index]["id"]}",
                                      );
                                    }));
                                  },
                                  text: docs[index]["name"].toString(),
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
            }));
  }
}
