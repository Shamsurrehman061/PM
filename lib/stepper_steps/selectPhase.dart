import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import "package:reale/stepper_steps/selectBlock.dart";
import "package:reale/stepper_steps/addListing.dart";
import 'package:reale/stepper_steps/select_scheme_route.dart';
import 'package:reale/widgets/setting_stepper.dart';
import 'package:simple_database/simple_database.dart';

var phases = [];
var phaseIds = [];
var selectedPhase;
var phaseId;

class selectPhase extends StatefulWidget {
  final scheme;
  final schemeName;
  final province;
  final provinceName;
  final city;
  final cityName;

  selectPhase(
      {this.scheme,
      this.province,
      this.city,
      this.cityName,
      this.provinceName,
      this.schemeName});

  @override
  _selectPhaseState createState() => _selectPhaseState();
}

class _selectPhaseState extends State<selectPhase> {

  // bool _isPhaseDropDownEnable;
  //
  // _selectPhaseState(): _isPhaseDropDownEnable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Phase")
              .orderBy("name", descending: false)
              .snapshots(),
          builder: (BuildContext context,AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var el = snapshot.data.docs;
              phases = [];
              phaseIds = [];
              print(widget.scheme);

              for (var e in el) {
                if (e.data() != null) {
                  if (e.data()["schemeID"] == widget.scheme) {
                    phases.add(e.data()["name"]);
                    phaseIds.add(e.data()["id"]);
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
                    //   "Screen 4/12",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    IgnorePointer(
                      ignoring: !stepperStateModel.isPhaseDropDownEnable,
                      child: DropDown<dynamic>(
                        items: phases,
                        hint: Text("select phase"),
                        initialValue: houseModel.phaseName.length > 0
                            ? houseModel.phaseName
                            : null,
                        onChanged: (val) async {
                          //save the previous state of previous tree
                          if (SchemeType.isScheme()) {
                            // if isScheme is true
                            var previousStep1 = InformationStepper.allSteps[0];
                            var previousStep2 = InformationStepper.allSteps[1];
                            var previousStep3 = InformationStepper.allSteps[2];
                            var previousStep4 = InformationStepper.allSteps[3];
                            var previousStep5 = InformationStepper.allSteps[4];
                            InformationStepper.allSteps.clear();
                            InformationStepper.allSteps = [
                              previousStep1,
                              previousStep2,
                              previousStep3,
                              previousStep4,
                              previousStep5,
                            ];
                          }
                          else {
                            // if isScheme is false
                            var previousStep1 = InformationStepper.allSteps[0];
                            var previousStep2 = InformationStepper.allSteps[1];
                            var previousStep3 = InformationStepper.allSteps[2];
                            var previousStep4 = InformationStepper.allSteps[3];
                            var previousStep5 = InformationStepper.allSteps[4];
                            InformationStepper.allSteps.clear();
                            InformationStepper.allSteps = [
                              previousStep1,
                              previousStep2,
                              previousStep3,
                              previousStep4,
                              previousStep5,
                            ];
                          }

                          SimpleDatabase phase = SimpleDatabase(name: 'phase');
                          await phase.clear();
                          await phase.add('${val}');

                          setState(() {
                            selectedPhase = val.toString();
                            print(selectedPhase);
                            phaseId = phaseIds[phases.indexOf(selectedPhase)];
                            print(phaseId);
                            houseModel.phase = phaseId;
                            houseModel.phaseName = selectedPhase;
                            stepperStateModel.isPhaseDropDownEnable  = false;
                          });
                          // add
                          InformationStepper.refresh(isShowLoader: true);
                          InformationStepper.allSteps.add({
                            'color': Colors.white,
                            'background': Colors.green,
                            'label': SchemeType.isScheme() ? '6' : '5',
                            'content': Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Select Sub Zone/ Sub Phase/ Sector/ Block',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                selectBlock(
                                    scheme: widget.scheme,
                                    schemeName: widget.schemeName,
                                    phase: phaseId,
                                    phaseName: selectedPhase,
                                    province: widget.province,
                                    provinceName: widget.provinceName,
                                    city: widget.city,
                                    cityName: widget.cityName),
                              ],
                            ),
                          });
                          InformationStepper.refresh(isShowLoader: false);
                        },
                      ),
                    ),
                    // RaisedButton(
                    //   onPressed: (){
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context){
                    //           return selectBlock(
                    //             scheme: widget.scheme,
                    //             schemeName:widget.schemeName,
                    //             phase: phaseId,
                    //             phaseName:selectedPhase,
                    //             province: widget.province,
                    //             provinceName:widget.provinceName,
                    //             city: widget.city,
                    //             cityName:widget.cityName
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
              return Container();
            }
          }),
    );
  }
}
