import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:reale/listTab/selectPhase.dart";
import 'package:reale/widgets/stylishCustomButton.dart';

class NonSceme extends StatefulWidget {
  final city;
  NonSceme({this.city});

  @override
  _viewScemeState createState() => _viewScemeState();
}

class _viewScemeState extends State<NonSceme> {
  @override
  Widget build(BuildContext context) {
    print('scheme route');
    return Scaffold(
      body: StreamBuilder<dynamic>(
          stream: FirebaseFirestore.instance
              .collection("Non Scheme")
              .orderBy("name", descending: false)
              .where("cityID", isEqualTo: "${widget.city}")
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
                                'Select Scheme',
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return selectPhase(
                                          scheme: "${docs[index]["id"]}");
                                    }));
                              },
                              text: docs[index]["name"].toString(),
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
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return selectPhase(
                                        scheme: "${docs[index]["id"]}");
                                  }));
                            },
                            text: docs[index]["name"].toString(),
                          ),
                        ),
                      );
                    }
                  });
            } else {
              return Container(
                child: Center(
                  child: Text('No Content'),
                ),
              );
            }
          }),
    );
  }
}
