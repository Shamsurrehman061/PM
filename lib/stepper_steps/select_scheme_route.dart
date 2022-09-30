import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/stepper_steps/selectCity.dart';
import "package:reale/stepper_steps/selectPropertySubType.dart";
import 'package:reale/stepper_steps/selectPropertyType.dart';
import 'package:reale/stepper_steps/selectScheme.dart';
import 'package:reale/stepper_steps/selectSubblocks.dart';
import 'package:reale/widgets/setting_stepper.dart';

import '../main.dart';



enum SchemeTypes {
  Scheme,
  Non_Scheme,
}
bool boolSelectScheme=true;
class SchemeType extends StatefulWidget {
  String? province;
  String? provinceName;
  String? city;
  String? cityName;

  SchemeType({
    this.province,
    this.provinceName,
    this.city,
    this.cityName,
  });
  static bool _isScheme = false;

  static bool isScheme() {
    return _isScheme;
  }

  @override
  _SchemeTypeState createState() => _SchemeTypeState();
}

class _SchemeTypeState extends State<SchemeType> {

  //bool _isSchemeDropDownEnable;
  //
  // _SchemeTypeState(): _isSchemeDropDownEnable = true;

  SchemeTypes selectedScheme = SchemeTypes.Scheme;
  @override
  Widget build(BuildContext context) {
    print('Scheme Type build method');
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IgnorePointer(
            ignoring: !stepperStateModel.isSchemeDropDownEnable,
            child: DropDown(
              items: [
                "Scheme",
                "Non Scheme",
              ],
              initialValue: houseModel.isNonScheme ? "Non Scheme" : "Scheme",
              hint: Text("Select Scheme"),
              onChanged: (String? value) {
                print('Length of th list: ${InformationStepper.allSteps.length}');
                var previousStep1 = InformationStepper.allSteps[0];
                var previousStep2 = InformationStepper.allSteps[1];
                var previousStep3 =
                    InformationStepper.allSteps[2]; // repn current drop down

                InformationStepper.allSteps.clear();
                InformationStepper.allSteps = [
                  previousStep1,
                  previousStep2,
                  previousStep3,
                ];
                //---------------
                selectedScheme = (value == "Scheme"
                    ? SchemeTypes.Scheme
                    : SchemeTypes.Non_Scheme);
                if (selectedScheme == SchemeTypes.Scheme) {
                  setState(() {
                    stepperStateModel.isSchemeDropDownEnable = false;
                    boolSelectScheme=true;
                  });
                  print('scheme selected');
                  SchemeType._isScheme = true;
                  houseModel.isNonScheme = false;
                  // go there if scheme is selected
                  // then go to step-3 <scheme step>
                  InformationStepper.refresh(isShowLoader: true);
                  InformationStepper.allSteps.add({
                    'color': Colors.white,
                    'background': Colors.green,
                    'label': '4',
                    'content': Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'List',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        // new code

                        selectScheme(
                          province: widget.province,
                          provinceName: widget.provinceName,
                          city: widget.city,
                          cityName: widget.cityName,
                          isNonScheme: false,
                        ),
                        // old code
                        // selectScheme(
                        //   province: widget.province,
                        //   provinceName: widget.provinceName,
                        //   city: cityId,
                        //   cityName: selectedCity,
                        // ),
                      ],
                    ),
                  });
                  InformationStepper.refresh(isShowLoader: false);
                }
                else {
                  setState(() {
                    stepperStateModel.isSchemeDropDownEnable = false;
                  });
                  // go there if non-scheme is selected
                  print('non scheme selected');
                  SchemeType._isScheme = false;
                  houseModel.isNonScheme = true;
                  boolSelectScheme=false;
                  // add
                  InformationStepper.refresh(isShowLoader: true);
                  InformationStepper.allSteps.add({
                    'color': Colors.white,
                    'background': Colors.green,
                    'label': '4',
                    'content': Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'List',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        /*call the select scheme*/
                        selectScheme(
                          province: widget.province,
                          provinceName: widget.provinceName,
                          city: widget.city,
                          cityName: widget.cityName,
                          isNonScheme: true,
                        ),
                        // selectPropertyType( // recently commented code
                        //   province: widget.province,
                        //   provinceName: widget.provinceName,
                        //   schemeName: null,
                        //   scheme: null,
                        //   city: widget.city,
                        //   cityName: widget.cityName,
                        //   phaseName: null,
                        //   phase: null,
                        //   block: null,
                        //   blockName: null,
                        //   subBlock: subblockIds, // now changed
                        //   subBlockName: null, // subBlockName ?? null,
                        //   //adress: adress.value.text,
                        // ),
                      ],
                    ),
                  });
                  InformationStepper.refresh(isShowLoader: false);
                }
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
