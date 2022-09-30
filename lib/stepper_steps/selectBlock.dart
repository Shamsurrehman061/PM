import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:reale/main.dart';
import "package:reale/stepper_steps/selectSubblocks.dart";
import "package:reale/stepper_steps/addListing.dart";
import 'package:reale/stepper_steps/select_scheme_route.dart';
import 'package:reale/widgets/setting_stepper.dart';
import 'package:simple_database/simple_database.dart';

var blocks = [];
var blockIds = [];
var selectedBlock;
var blockId;

class selectBlock extends StatefulWidget {
  final scheme;
  final schemeName;
  final provinceName;
  final province;
  final city;
  final cityName;
  final phase;
  final phaseName;

  selectBlock(
      {this.scheme,
      this.province,
      this.city,
      this.phase,
      this.cityName,
      this.provinceName,
      this.schemeName,
      this.phaseName});

  @override
  _selectBlockState createState() => _selectBlockState();
}

class _selectBlockState extends State<selectBlock> {

  // bool _isBlockDropDownEnable;
  //
  // _selectBlockState(): _isBlockDropDownEnable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("block")
              .orderBy("name", descending: false)
              .snapshots(),
          builder: (BuildContext context,AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var el = snapshot.data.docs;
              blocks = [];
              blockIds = [];
              print(widget.scheme);

              for (var e in el) {
                if (e.data() != null) {
                  if (e.data()["phaseID"] == widget.phase) {
                    blocks.add(e.data()["name"]);
                    blockIds.add(e.data()["id"]);
                  }
                }
              }

              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text("Screen 5/12",style: TextStyle(fontWeight: FontWeight.bold),),
                    IgnorePointer(
                      ignoring: !stepperStateModel.isBlockDropDownEnable,
                      child: DropDown<dynamic>(
                        items: blocks,
                        hint: Text("select Block"),
                        initialValue: houseModel.blockName.length > 0
                            ? houseModel.blockName
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
                            InformationStepper.allSteps.clear();
                            InformationStepper.allSteps = [
                              previousStep1,
                              previousStep2,
                              previousStep3,
                              previousStep4,
                              previousStep5,
                              previousStep6,
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
                            InformationStepper.allSteps.clear();
                            InformationStepper.allSteps = [
                              previousStep1,
                              previousStep2,
                              previousStep3,
                              previousStep4,
                              previousStep5,
                              previousStep6,
                            ];
                          }

                          SimpleDatabase block = SimpleDatabase(name: 'block');
                          await block.clear();
                          await block.add('${val}');

                          setState(() {
                            selectedBlock = val.toString();
                            print(selectedBlock);
                            blockId = blockIds[blocks.indexOf(selectedBlock)];
                            print(blockId);
                            houseModel.block = blockId;
                            houseModel.blockName = selectedBlock;
                            stepperStateModel.isBlockDropDownEnable = false;
                          });

                          // add
                          InformationStepper.refresh(isShowLoader: true);
                          InformationStepper.allSteps.add({
                            'color': Colors.white,
                            'background': Colors.green,
                            'label': SchemeType.isScheme() ? '7' : '6',
                            'content': Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Select Sub Sector/ Sub Block',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                selectSubblocks(
                                  province: widget.province,
                                  provinceName: widget.provinceName,
                                  schemeName: widget.schemeName,
                                  scheme: widget.scheme,
                                  city: widget.city,
                                  cityName: widget.cityName,
                                  phase: widget.phase,
                                  phaseName: widget.phaseName,
                                  block: blockId,
                                  blockName: null, //selectedBlock,
                                ),
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
                    //       return selectSubblocks(
                    //           province: widget.province,
                    //           provinceName: widget.provinceName,
                    //           schemeName: widget.schemeName,
                    //           scheme: widget.scheme,
                    //           city: widget.city,
                    //           cityName: widget.cityName,
                    //           phase: widget.phase,
                    //           phaseName: widget.phaseName,
                    //           block: blockId,
                    //           blockName: selectedBlock);
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
