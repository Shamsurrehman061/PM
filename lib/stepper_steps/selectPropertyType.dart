import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import "package:reale/stepper_steps/selectPropertySubType.dart";
import 'package:reale/stepper_steps/select_scheme_route.dart';
import 'package:reale/widgets/setting_stepper.dart';

var propertyType;

class selectPropertyType extends StatefulWidget {
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
  //final adress;

  selectPropertyType({
    this.scheme,
    this.schemeName,
    this.province,
    this.city,
    this.phase,
    this.block,
    this.phaseName,
    this.cityName,
    this.provinceName,
    this.blockName,
    this.subBlockName,
    this.subBlock,
    //this.adress,
  });

  @override
  _selectPropertyTypeState createState() => _selectPropertyTypeState();
}

class _selectPropertyTypeState extends State<selectPropertyType> {

  // bool _isSelectPropertyDropDownEnable;
  // _selectPropertyTypeState(): _isSelectPropertyDropDownEnable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IgnorePointer(
            ignoring: !stepperStateModel.isSelectPropertyDropDownEnable,
            child: DropDown(
              items: ["Commercial", "Land / Plot", "Residential"],
              hint: Text("Property Type"),
              initialValue: houseModel.propertyType.length > 0
                  ? houseModel.propertyType
                  : null,
              onChanged: (val) {
                if (SchemeType.isScheme()) {
                  // if isScheme is true
                  print('List Length: ${InformationStepper.allSteps.length}');
                  var previousStep1 = InformationStepper.allSteps[0];
                  var previousStep2 = InformationStepper.allSteps[1];
                  var previousStep3 = InformationStepper.allSteps[2];
                  var previousStep4 = InformationStepper.allSteps[3];
                  var previousStep5 = InformationStepper.allSteps[4];
                  var previousStep6 = InformationStepper.allSteps[5];
                  var previousStep7 = InformationStepper.allSteps[6];
                  var previousStep8 = InformationStepper.allSteps[7];
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
                  ];
                }
                else {
                  // if isScheme is false
                  var previousStep1 = InformationStepper.allSteps[0];
                  var previousStep2 = InformationStepper.allSteps[1];
                  var previousStep3 = InformationStepper.allSteps[2];
                  var previousStep4 = InformationStepper.allSteps[3];
                  var previousStep5 = InformationStepper.allSteps[4];
                  // var previousStep6 = InformationStepper.allSteps[5];
                  // var previousStep7 = InformationStepper.allSteps[6];
                  // var previousStep8 = InformationStepper.allSteps[7];
                  InformationStepper.allSteps.clear();
                  InformationStepper.allSteps = [
                    previousStep1,
                    previousStep2,
                    previousStep3,
                    previousStep4,
                    previousStep5,
                    // previousStep6,
                    // previousStep7,
                    // previousStep8,
                  ];
                }

                setState(() {
                  propertyType = val!;
                  houseModel.propertyType = val.toString();
                  //InformationStepper.refresh();
                  stepperStateModel.isSelectPropertyDropDownEnable = false;

                  print("sub block name ad  ${widget.subBlockName}");
                });
                // add
                InformationStepper.refresh(isShowLoader: true);
                InformationStepper.allSteps.add({
                  'color': Colors.white,
                  'background': Colors.green,
                  'label': SchemeType.isScheme() ? '9' : '6',
                  'content': Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Select Property Sub Type',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      selectPropertySubType(
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
                        subBlock: widget.subBlock,
                        subBlockName: widget.subBlockName,
                        adress: null, // widget.adress,
                        propertyType: propertyType,
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
          //
          //     //----------------------------------------
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //     //   return selectPropertySubType(
          //     //     province: widget.province,
          //     //     provinceName: widget.provinceName,
          //     //     schemeName: widget.schemeName,
          //     //     scheme: widget.scheme,
          //     //     city: widget.city,
          //     //     cityName: widget.cityName,
          //     //     phaseName: widget.phaseName,
          //     //     phase: widget.phase,
          //     //     block: widget.block,
          //     //     blockName: widget.blockName,
          //     //     subBlock: widget.subBlock,
          //     //     subBlockName: widget.subBlockName,
          //     //     adress: widget.adress,
          //     //     propertyType: propertyType,
          //     //   );
          //     // }));
          //   },
          //   child: Icon(Icons.navigate_next),
          // )
        ],
      ),
    );
  }
}
