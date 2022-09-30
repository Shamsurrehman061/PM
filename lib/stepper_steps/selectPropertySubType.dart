import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import "package:reale/stepper_steps/selectFloor.dart";
import 'package:reale/stepper_steps/selectPropertyPurpose.dart';
import 'package:reale/stepper_steps/select_scheme_route.dart';
import 'package:reale/widgets/setting_stepper.dart';

var dynamicItems = [];
var propertySubType;
// TextEditingController houseNo = TextEditingController();

class selectPropertySubType extends StatefulWidget {
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

  selectPropertySubType({
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
    this.adress,
    this.propertyType,
  });

  @override
  _selectPropertySubTypeState createState() => _selectPropertySubTypeState();
}

class _selectPropertySubTypeState extends State<selectPropertySubType> {
  // bool _isSelectPropertySubTypeDropDownEnable;
  // _selectPropertySubTypeState():_isSelectPropertySubTypeDropDownEnable = true ;


  @override
  void initState() {
    if (widget.propertyType == "Commercial") {
      dynamicItems = [
        'Food Court',
        "Factory",
        "Gym",
        "Hall",
        "Office",
        "Shop",
        "Theatre",
        "Warehouse",
      ];
    } else if (widget.propertyType == "Residential") {
      dynamicItems = [
        'Farm House',
        'Guest House',
        'Hostel',
        'House',
        'Penthouse',
        "Room",
        'Villas',
      ];
    } else if (widget.propertyType == "Land / Plot") {
      dynamicItems = [
        'Commercial Land',
        'Residential Land',
        'Plot File',
        //'Agricultural Land',
      ];
    } else {
      dynamicItems = ["None"];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.propertyType == "Commercial") {
      dynamicItems = [
        'Food Court',
        "Factory",
        "Gym",
        "Hall",
        "Office",
        "Shop",
        "Theatre",
        "Warehouse",
      ];
    } else if (widget.propertyType == "Residential") {
      dynamicItems = [
        'Farm House',
        'Guest House',
        'Hostel',
        'House',
        'Penthouse',
        "Room",
        'Villas',
      ];
    } else if (widget.propertyType == "Land / Plot") {
      dynamicItems = [
        'Commercial Land',
        'Residential Land',
        'Plot File',
        //'Agricultural Land',
      ];
    } else {
      dynamicItems = ["None"];
    }
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(
          //   "Screen 9/12",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          IgnorePointer(
            ignoring: !stepperStateModel.isSelectPropertySubTypeDropDownEnable,
            child: DropDown<dynamic>(
              items: dynamicItems,
              hint: Text("select property Sub type"),
              initialValue: houseModel.propertySubType.length > 0
                  ? houseModel.propertySubType
                  : null,
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
                  // var previousStep7 = InformationStepper.allSteps[6];
                  // var previousStep8 = InformationStepper.allSteps[7];
                  // var previousStep9 = InformationStepper.allSteps[8];
                  InformationStepper.allSteps.clear();
                  InformationStepper.allSteps = [
                    previousStep1,
                    previousStep2,
                    previousStep3,
                    previousStep4,
                    previousStep5,
                    previousStep6,
                    // previousStep7,
                    // previousStep8,
                    // previousStep9,
                  ];
                }
                setState(() {
                  propertySubType = val;
                  houseModel.propertySubType = propertySubType;
                  stepperStateModel.isSelectPropertySubTypeDropDownEnable = false;
                });
                // add
                InformationStepper.refresh(isShowLoader: true);
                InformationStepper.allSteps.add({
                  'color': Colors.white,
                  'background': Colors.green,
                  'label': SchemeType.isScheme() ? '10' : '7',
                  'content': Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Purpose of property',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      // dont call floor rather directly call "select property purpose"
                      selectPropertyPurpose(
                        province: widget.province,
                        scheme: widget.scheme,
                        city: widget.city,
                        phase: widget.phase,
                        block: widget.block,
                        subBlock: widget.subBlock,
                        subBlockName: widget.subBlockName,
                        adress: widget.adress,
                        propertyType: widget.propertyType,
                        propertySubType: propertySubType,
                        // sent by this class 6 parameters
                        // want to replace it position in hierarchy
                        // washrooms: washrooms.value.text,
                        // kitchens: kitchens.value.text,
                        // basements: basements.value.text,
                        // floors: floors.value.text,
                        // parkings: parkings.value.text,
                        // rooms: rooms.value.text,
                      ),
                      // selectFloor(
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
                      //   subBlock: widget.subBlock,
                      //   subBlockName: widget.subBlockName,
                      //   adress: widget.adress,
                      //   propertyType: widget.propertyType,
                      //   propertySubType: propertySubType,
                      // ),
                    ],
                  ),
                });
                InformationStepper.refresh(isShowLoader: false);
              },
            ),
          ),
          //commented out this temporary
          // TextField(
          //   controller: houseNo,
          //   decoration: InputDecoration(hintText: "House No/Flat No/Plot No"),
          // ),
          // RaisedButton(
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return selectFloor(
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
          //           subBlock: widget.subBlock,
          //           subBlockName: widget.subBlockName,
          //           adress: widget.adress,
          //           propertyType: widget.propertyType,
          //           propertySubType: propertySubType);
          //     }));
          //   },
          //   child: Icon(Icons.navigate_next),
          // )
        ],
      ),
    );
  }
}
