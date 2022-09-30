import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import "package:reale/stepper_steps/selectPhase.dart";
import 'package:reale/stepper_steps/selectPropertyType.dart';
import 'package:reale/stepper_steps/selectSubblocks.dart';
import 'package:reale/stepper_steps/select_scheme_route.dart';
import 'package:reale/widgets/setting_stepper.dart';
import 'package:simple_database/simple_database.dart';

var schemes = []; // hold scheme names means city names
var schemeIds = [];
var selectedScheme;
var schemeId;

// schemeId means scheme type which is scheme and non-scheme
class selectScheme extends StatefulWidget {
  final province;
  final provinceName;
  final city;
  final cityName;
  bool isNonScheme;

  selectScheme({
    this.province,
    this.city,
    this.provinceName,
    this.cityName,
    required this.isNonScheme,
  });

  @override
  _selectSchemeState createState() => _selectSchemeState();
}

class _selectSchemeState extends State<selectScheme> {

  // bool _isListSchemeDropDownEnable;
  //
  // _selectSchemeState(): _isListSchemeDropDownEnable = true;

  @override
  Widget build(BuildContext context) {
    print('SelectScheme Build method called');
    print('Is non scheme: ${widget.isNonScheme}');

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.isNonScheme ? "Non Scheme" : "Scheme")
              .orderBy("name", descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print('Stream builder invoked...SelectScheme');
            // schemeNameList = [];
            print(
                '${widget.isNonScheme ? "Non Scheme" : "Scheme"} data: ${snapshot.data?.docs}');
            if (snapshot.data != null && snapshot.hasData) {
              var snapshotData = snapshot.data?.docs;
              schemes = [];
              schemeIds = [];
              for (DocumentSnapshot document in snapshotData!) {
                if (document.data() != null) {
                  // print(
                  //     '${widget.isNonScheme ? "Non Scheme" : "Scheme"} data: ${e.data()}');
                  if ((document.data() as Map<String,dynamic>)["cityID"] == widget.city) {
                    schemes.add((document.data() as Map<String,dynamic>)["name"]);
                    schemeIds.add((document.data() as Map<String,dynamic>)["id"]);
                  }
                }
              }
              print('All scheme names list : $schemes');
              print('All scheme type list: $schemeIds');
              // hold dropdown
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    schemes.length > 0
                        ? IgnorePointer(
                      ignoring: !stepperStateModel.isListSchemeDropDownEnable,

                          //meeee  ********************************************************
                          child: DropDown<dynamic>(
                              items: schemes,
                              hint: Text(
                                  "Select ${widget.isNonScheme ? "Non Scheme" : "Scheme"}"),
                              initialValue: houseModel.schemeName.length > 0
                                  ? houseModel.schemeName
                                  : null,
                              onChanged: ( schemeType) async {
                                if (SchemeType.isScheme()) {
                                  var previousStep1 =
                                      InformationStepper.allSteps[0];
                                  var previousStep2 =
                                      InformationStepper.allSteps[1];
                                  var previousStep3 =
                                      InformationStepper.allSteps[2];
                                  var previousStep4 =
                                      InformationStepper.allSteps[3];
                                  InformationStepper.allSteps.clear();
                                  InformationStepper.allSteps = [
                                    previousStep1,
                                    previousStep2,
                                    previousStep3,
                                    previousStep4,
                                  ];
                                }
                                else {
                                  // if isScheme is false
                                  var previousStep1 =
                                      InformationStepper.allSteps[0];
                                  var previousStep2 =
                                      InformationStepper.allSteps[1];
                                  var previousStep3 =
                                      InformationStepper.allSteps[2];
                                  var previousStep4 =
                                      InformationStepper.allSteps[3];
                                  InformationStepper.allSteps.clear();
                                  InformationStepper.allSteps = [
                                    previousStep1,
                                    previousStep2,
                                    previousStep3,
                                    previousStep4,
                                  ];
                                }

                                SimpleDatabase schemeLocalDatabase =
                                    SimpleDatabase(name: 'scheme');
                                await schemeLocalDatabase.clear();
                                await schemeLocalDatabase.add('$schemeType');

                                setState(() {
                                  selectedScheme = schemeType.toString();
                                  print(selectedScheme);
                                  schemeId =
                                      schemeIds[schemes.indexOf(selectedScheme)];
                                  // saving value to runtime storage
                                  houseModel.scheme = schemeId;
                                  houseModel.schemeName = selectedScheme;
                                  houseModel.subBlock = subblockIds;
                                  print(schemeId);
                                  stepperStateModel.isListSchemeDropDownEnable = false;
                                });
                                InformationStepper.refresh(isShowLoader: true);
                                InformationStepper.allSteps.add({
                                  'color': Colors.white,
                                  'background': Colors.green,
                                  'label': '5',
                                  'content': Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.isNonScheme // TODO: check this behaviour later on
                                            ? 'Select Property Type'
                                            : 'Select Zone/ Phase',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      widget.isNonScheme
                                          ? selectPropertyType(
                                              // recently commented code
                                              province: widget.province,
                                              provinceName: widget.provinceName,
                                              schemeName: selectScheme,
                                              scheme: schemeId,
                                              city: widget.city,
                                              cityName: widget.cityName,
                                              phaseName: null,
                                              phase: null,
                                              block: null,
                                              blockName: null,
                                              subBlock:
                                                  subblockIds, // now changed
                                              subBlockName: null,
                                              // subBlockName ?? null,
                                              //adress: adress.value.text,
                                            )
                                          : selectPhase(
                                              province: widget.province,
                                              provinceName: widget.provinceName,
                                              city: widget.city,
                                              cityName: widget.cityName,
                                              scheme: schemeId,
                                              schemeName: selectedScheme,
                                            ),
                                    ],
                                  ),
                                });
                                InformationStepper.refresh(isShowLoader: false);
                              },
                            ),
                        )
                        : Text('No data found'),
                    // : Center(
                    //     child: CircularProgressIndicator(
                    //       valueColor:
                    //           AlwaysStoppedAnimation<Color>(Colors.orange),
                    //     ),
                    //   ),
                    // RaisedButton(
                    //   onPressed: (){
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context){
                    //           return selectPhase(
                    //             province: widget.province,
                    //             provinceName:widget.provinceName,
                    //             city: widget.city,
                    //             cityName:widget.cityName,
                    //             scheme:schemeId,
                    //             schemeName:selectedScheme
                    //           );
                    //         })
                    //     );
                    //   },
                    //   child: Icon(
                    //       Icons.navigate_next
                    //   ),
                    // )
                  ],
                ),
              );
            } else {
              return Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 20),
                  ));
              //   Center(
              //   child: CircularProgressIndicator(
              //     valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              //   ),
              // );
            }
          }),
    );
  }
}
