import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import "package:reale/stepper_steps/selectArea.dart";
import 'package:reale/stepper_steps/select_scheme_route.dart';
import 'package:reale/widgets/setting_stepper.dart';

var purpose;
var washrooms;

var floors;
var rooms;
var kitchens;
var basements;
var parkings;

class selectPropertyPurpose extends StatefulWidget {
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
  final subBlock;
  final subBlockName;
  final adress;
  final propertyType;
  final propertySubType;

  selectPropertyPurpose(
      {this.scheme,
      this.province,
      this.city,
      this.phase,
      this.block,
      this.subBlock,
      this.adress,
      this.propertyType,
      this.propertySubType,
      floors,
      rooms,
      basements,
      kitchens,
      washrooms,
      parkings,
      this.subBlockName,
      this.blockName,
      this.phaseName,
      this.cityName,
      this.schemeName,
      this.provinceName});

  @override
  _selectPropertyPurposeState createState() => _selectPropertyPurposeState();
}

class _selectPropertyPurposeState extends State<selectPropertyPurpose> {

  // bool _selectPropertyPurposeDropDownEnable;
  //
  // _selectPropertyPurposeState():_selectPropertyPurposeDropDownEnable = true ;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IgnorePointer(
            ignoring: !stepperStateModel.selectPropertyPurposeDropDownEnable,
            child: DropDown(
              items: [
                "Lease",
                "Rent",
                "Sale",
              ],
              hint: Text("Property Purpose"),
              initialValue:
                  houseModel.purpose.length > 0 ? houseModel.purpose : null,
              onChanged: (val) {
                if (SchemeType.isScheme()) {
                  // if isScheme is true
                  var previousStep1 = InformationStepper.allSteps[0];
                  var previousStep2 = InformationStepper.allSteps[1];
                  var previousStep3 = InformationStepper.allSteps[2];
                  var previousStep4 = InformationStepper.allSteps[3];
                  var previousStep5 = InformationStepper.allSteps[4];
                  var previousStep6 = InformationStepper.allSteps[5];
                  var previousStep7 = InformationStepper.allSteps[6];
                  var previousStep8 = InformationStepper.allSteps[7];
                  var previousStep9 = InformationStepper.allSteps[8];
                  var previousStep10 = InformationStepper.allSteps[9];
                  // //var previousStep11 = InformationStepper.allSteps[10];
                  InformationStepper.allSteps.clear();
                  InformationStepper.allSteps = [
                    previousStep1,
                    previousStep2,
                    previousStep3,
                    previousStep4,
                    previousStep5,
                    previousStep6,
                    previousStep7,
                    previousStep8,
                    previousStep9,
                    previousStep10,
                    //   //previousStep11,
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
                  // var previousStep8 = InformationStepper.allSteps[7];
                  // var previousStep9 = InformationStepper.allSteps[8];
                  // var previousStep10 = InformationStepper.allSteps[9];
                  // //var previousStep11 = InformationStepper.allSteps[10];
                  InformationStepper.allSteps.clear();
                  InformationStepper.allSteps = [
                    previousStep1,
                    previousStep2,
                    previousStep3,
                    previousStep4,
                    previousStep5,
                    previousStep6,
                    previousStep7,
                    // previousStep8,
                    // previousStep9,
                    // previousStep10,
                    //   //previousStep11,
                  ];
                }

                setState(() {
                  purpose = val;
                  houseModel.purpose = purpose;
                  stepperStateModel.selectPropertyPurposeDropDownEnable = false;
                });

                // add
                InformationStepper.refresh(isShowLoader: true);
                InformationStepper.allSteps.add({
                  'color': Colors.white,
                  'background': Colors.green,
                  'label': SchemeType.isScheme() ? '11' : '8',
                  'content': Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Total Area',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      selectArea(
                        province: widget.province,
                        scheme: widget.scheme,
                        city: widget.city,
                        phase: widget.phase,
                        block: widget.block,
                        subBlock: widget.subBlock,
                        subBlockName: widget.subBlockName,
                        adress: widget.adress,
                        propertyType: widget.propertyType,
                        propertySubType: widget.propertySubType,
                        // sent by floor--which we want to replace
                        washrooms: washrooms,
                        kitchens: kitchens,
                        basements: basements,
                        floors: floors,
                        parkings: parkings,
                        rooms: rooms,
                        // ---------------------------
                        purpose: purpose,
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
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return selectArea(
          //         province: widget.province,
          //         scheme: widget.scheme,
          //         city: widget.city,
          //         phase: widget.phase,
          //         block: widget.block,
          //         subBlock: widget.subBlock,
          //         subBlockName: widget.subBlockName,
          //         adress: widget.adress,
          //         propertyType: widget.propertyType,
          //         propertySubType: widget.propertySubType,
          //         washrooms: widget.washrooms,
          //         kitchens: widget.kitchens,
          //         basements: widget.basements,
          //         floors: widget.floors,
          //         parkings: widget.parkings,
          //         rooms: widget.rooms,
          //         purpose: purpose,
          //       );
          //     }));
          //   },
          //   child: Icon(Icons.navigate_next),
          // )
        ],
      ),
    );
  }
}
