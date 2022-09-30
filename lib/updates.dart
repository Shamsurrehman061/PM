import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'package:reale/main.dart';
import 'package:reale/widgets/stylishCustomButton.dart';
import 'listTab/viewCity.dart';

class updates extends StatefulWidget {
  const updates({Key? key}) : super(key: key);

  @override
  updatesState createState() => updatesState();
}

class updatesState extends State<updates> {
  @override
  Widget build(BuildContext context) {
    print('this is the province page');
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("province")
            .orderBy("name", descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print('province data: ${snapshot.data?.size}');
          if (snapshot.hasData ) {
            print('province data: ${snapshot.data?.size}');
            var docData = snapshot.data;
            var docs = docData?.docs;

            return ListView.builder(
                itemCount: docs?.length,
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
                              'Select Province',
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
                          margin:const EdgeInsets.only(bottom: 15, top: 5, left: 20),
                          child: StylishCustomButton(
                            text: docs![index]["name"],
                            onPressed: () async {
                              listingModel.province =
                                  docs[index]["name"].toString();
                              // print('Province name: ${docs[index]["name"]}');
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return viewCity(
                                    province: "${docs[index]["id"]}");
                              }));
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        margin: EdgeInsets.only(bottom: 15, top: 5),
                        child: StylishCustomButton(
                          text: docs![index]["name"],
                          onPressed: () {
                            listingModel.province =
                                docs[index]["name"].toString();
                            // print('Province name: ${docs[index]["name"]}');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return viewCity(province: "${docs[index]["id"]}");
                            }));
                          },
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
        });
  }
}
