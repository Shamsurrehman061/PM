import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:reale/stepper_steps/selectAdress.dart";
import "package:reale/stepper_steps/addListing.dart";
import 'package:reale/stepper_steps/select_scheme_route.dart';
import 'package:reale/widgets/setting_stepper.dart';
import 'package:simple_database/simple_database.dart';


import '../main.dart';
import 'selectPropertyType.dart';

var subblocks = [];
var subblockIds = [];
var selectedSubblock;
var SubblockId;

class selectSubblocks extends StatefulWidget {
  final scheme;
  final province;
  final city;
  final phase;
  final block;
  final blockName;
  final provinceName;
  final cityName;
  final phaseName;
  final schemeName;

  selectSubblocks(
      {this.scheme,
      this.schemeName,
      this.province,
      this.city,
      this.phase,
      this.block,
      this.phaseName,
      this.cityName,
      this.provinceName,
      this.blockName});

  @override
  _selectSubblocksState createState() => _selectSubblocksState();
}

class _selectSubblocksState extends State<selectSubblocks> {

  // bool _isSubBlockDropDownEnable;
  //
  // _selectSubblocksState(): _isSubBlockDropDownEnable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("subblock")
              .orderBy('name', descending: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var el = snapshot.data.docs;
              subblocks = [];
              subblockIds = [];

              for (var e in el) {
                if (e.data() != null) {
                  if (e.data()["blockID"] == widget.block) {
                    subblocks.add(e.data()["name"]);
                    subblockIds.add(e.data()["id"]);
                  }
                }
              }

              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Screen 6/12",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    IgnorePointer(
                      ignoring: !stepperStateModel.isSubBlockDropDownEnable,
                      child: DropDown<dynamic>(
                        items: subblocks,
                        hint: Text("select Sub Block"),
                        initialValue: houseModel.subBlockName.length > 0
                            ? houseModel.subBlockName
                            : null,
                        onChanged: (val) async {
                          if (SchemeType.isScheme()) {
                            // if isScheme is true
                            var previousStep1 = InformationStepper.allSteps[0];
                            var previousStep2 = InformationStepper.allSteps[1];
                            var previousStep3 = InformationStepper.allSteps[2];
                            var previousStep4 = InformationStepper.allSteps[3];
                            var previousStep5 = InformationStepper.allSteps[4];
                            var previousStep6 = InformationStepper.allSteps[5];
                            var previousStep7 = InformationStepper.allSteps[6];
                            InformationStepper.allSteps.clear();
                            InformationStepper.allSteps = [
                              previousStep1,
                              previousStep2,
                              previousStep3,
                              previousStep4,
                              previousStep5,
                              previousStep6,
                              previousStep7,
                            ];
                          }
                          else {
                            // if isScheme is false
                            var previousStep1 = InformationStepper.allSteps[0];
                            var previousStep2 = InformationStepper.allSteps[1];
                            var previousStep3 = InformationStepper.allSteps[2];
                            var previousStep4 = InformationStepper.allSteps[3];
                            var previousStep5 = InformationStepper.allSteps[4];
                            var previousStep6 = InformationStepper.allSteps[5];
                            var previousStep7 = InformationStepper.allSteps[6];
                            InformationStepper.allSteps.clear();
                            InformationStepper.allSteps = [
                              previousStep1,
                              previousStep2,
                              previousStep3,
                              previousStep4,
                              previousStep5,
                              previousStep6,
                              previousStep7,
                            ];
                          }

                          SimpleDatabase subBlock =
                              SimpleDatabase(name: 'subBlock');
                          await subBlock.clear();
                          await subBlock.add('${val}');

                          setState(() {
                            selectedSubblock = val.toString();
                            print(selectedSubblock);
                            SubblockId =
                                subblockIds[subblocks.indexOf(selectedSubblock)];
                            print(SubblockId);

                            houseModel.subBlock = subblockIds;
                            houseModel.subBlockName = selectedSubblock;
                            stepperStateModel.isSubBlockDropDownEnable = false;
                          });
                          // add
                          InformationStepper.refresh(isShowLoader: true);
                          InformationStepper.allSteps.add({
                            'color': Colors.white,
                            'background': Colors.green,
                            'label': SchemeType.isScheme() ? '8' : '7',
                            'content': Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  // 'Select Address', old one
                                  'Select Property Type', // new one
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                selectPropertyType(
                                  province: widget.province,
                                  provinceName: widget.provinceName,
                                  schemeName: widget.schemeName,
                                  scheme: widget.scheme,
                                  city: widget.city,
                                  cityName: widget.cityName,
                                  phaseName: widget.phaseName,
                                  phase: widget.phase,
                                  block: widget.block,
                                  blockName: widget.blockName,
                                  subBlock: subblockIds, // now changed
                                  subBlockName:
                                      selectedSubblock, // subBlockName ?? null,
                                  //adress: adress.value.text,
                                ),
                                // removed this from this page
                                // selectAdress(
                                //   province: widget.province,
                                //   provinceName: widget.provinceName,
                                //   schemeName: widget.schemeName,
                                //   scheme: widget.scheme,
                                //   city: widget.city,
                                //   cityName: widget.cityName,
                                //   phaseName: widget.phaseName,
                                //   phase: widget.phase,
                                //   block: widget.block,
                                //   blockName: widget.blockName,
                                //   subBlock: SubblockId,
                                //   subBlockName: selectedSubblock,
                                //   clear: true,
                                // ),
                              ],
                            ),
                          });
                          InformationStepper.refresh(isShowLoader: false);
                        },
                      ),
                    ),
                    // RaisedButton(
                    //   onPressed: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) {
                    //       return selectAdress(
                    //           province: widget.province,
                    //           provinceName: widget.provinceName,
                    //           schemeName: widget.schemeName,
                    //           scheme: widget.scheme,
                    //           city: widget.city,
                    //           cityName: widget.cityName,
                    //           phaseName: widget.phaseName,
                    //           phase: widget.phase,
                    //           block: widget.block,
                    //           blockName: widget.blockName,
                    //           subBlock: SubblockId,
                    //           subBlockName: selectedSubblock);
                    //     }));
                    //   },
                    //   child: Icon(Icons.navigate_next),
                    // )
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
