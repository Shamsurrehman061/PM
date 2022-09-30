import 'package:flutter/material.dart';
import 'package:reale/stepper_steps/selectAdress.dart';
import 'package:reale/stepper_steps/selectArea.dart';
import 'package:reale/stepper_steps/selectBlock.dart';
import 'package:reale/stepper_steps/selectPhase.dart';
import 'package:reale/main.dart';
import 'package:reale/stepper_steps/selectCity.dart';
import 'package:reale/stepper_steps/selectPropertyPurpose.dart';
import 'package:reale/stepper_steps/selectPropertySubType.dart';
import 'package:reale/stepper_steps/selectPropertyType.dart';
import 'package:reale/stepper_steps/selectScheme.dart';
import 'package:reale/stepper_steps/selectSubblocks.dart';
import 'package:reale/stepper_steps/select_scheme_route.dart';

import '../stepper_steps/selectProvince.dart';

int index = 0;

class InformationStepper extends StatefulWidget {
  static List<dynamic> allSteps = <dynamic>[];

  static bool isLoading = false;

  static void refresh({bool isShowLoader = false}) {
    //InformationStepper.isLoading = isShowLoader;
    _stateInstance?._refreshState(isShowLoader: isShowLoader);
  }

  static _InformationStepperState? _stateInstance;

  @override
  _InformationStepperState createState() {
    _stateInstance = _InformationStepperState();
    return _stateInstance!;
  }
}

class _InformationStepperState extends State<InformationStepper> {
  void _refreshState({bool isShowLoader = false}) {
    print('refresh state value: $isShowLoader');
    setState(() {
      InformationStepper.isLoading = isShowLoader;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      InformationStepper.allSteps.add({
        'color': Colors.white,
        'background': Colors.green,
        'label': '1',
        'content': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select Province',
              style: TextStyle(fontSize: 18.0),
            ),
            selectProvince(),
          ],
        ),
      });
    });
  }

  @override
  void dispose() {
    print('dispose setting_stepper');
    InformationStepper.allSteps.clear();
    houseModel.resetValue();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Enter Details'),
        ),
        body: InformationStepper.isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Theme(
                data: ThemeData(
                    primarySwatch: Colors.green,
                    colorScheme: ColorScheme.light(primary: Colors.green)),
                child: Stepper(
                  physics: ClampingScrollPhysics(),
                  currentStep: index,
                  // onStepCancel: () {
                  //   if (index > 0) {
                  //     setState(() {
                  //       index -= 1;
                  //     });
                  //   }
                  // },
                  onStepContinue: () {
                    if (index >= 0) {
                      setState(() {
                        index += 1;
                      });
                    }
                  },
                  onStepTapped: (int index) {
                    setState(() {
                      index = index;
                    });
                  },
                  // steps:InformationStepper.allSteps,
                  steps: <Step>[
                    Step(
                      isActive: true,
                      title: const Text('Select Province'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: selectProvince(),
                      ),
                    ),
                    Step(
                      isActive: true,
                      title: const Text('Select District'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: selectCity(
                          province: currentId,
                          provinceName: selectedProvince,
                        ),
                      ),
                    ),
                    Step(
                      isActive: true,
                      title: const Text('Select Scheme/ Non-Scheme'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: SchemeType(
                          province: currentId,
                          provinceName: selectedProvince,
                          city: cityId,
                          cityName: selectedCity,
                        ),
                      ),
                    ),
                    Step(
                      isActive: true,
                      title: const Text('Select Type'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: boolSelectScheme
                            ? selectScheme(
                                province: currentId,
                                provinceName: selectedProvince,
                                city: cityId,
                                cityName: selectedCity,
                                isNonScheme: false,
                              )
                            : selectScheme(
                                province: currentId,
                                provinceName: selectedProvince,
                                city: cityId,
                                cityName: selectedCity,
                                isNonScheme: true,
                              ),
                      ),
                    ),
                    Step(
                      isActive: true,
                      title: boolSelectScheme
                          ? Text("Select Phase")
                          : Text('Select Sub Zone/ Sub Phase/ Sector/ Block'),
                      content: Container(
                          alignment: Alignment.centerLeft,
                          child: boolSelectScheme
                              ? selectPhase(
                                  province: currentId,
                                  provinceName: selectedProvince,
                                  city: cityId,
                                  cityName: selectedCity,
                                  scheme: schemeId,
                                  schemeName: selectedScheme,
                                )
                              : selectPropertyType(
                                  // recently commented code
                                  province: currentId,
                                  provinceName: selectedProvince,
                                  schemeName: selectScheme,
                                  scheme: schemeId,
                                  city: cityId,
                                  cityName: selectedCity,
                                  phaseName: null,
                                  phase: null,
                                  block: null,
                                  blockName: null,
                                  subBlock: subblockIds,

                                  subBlockName: null,
                                  // subBlockName ?? null,
                                  //adress: adress.value.text,
                                )),
                    ),
                    Step(
                      isActive: true,
                      title: boolSelectScheme
                          ? Text("Select Block")
                          : Text('Select Sub Zone/ Sub Phase/ Sector/ Block'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: boolSelectScheme
                            ? selectBlock(
                                scheme: schemeId,
                                schemeName: selectScheme,
                                phase: phaseId,
                                phaseName: selectedPhase,
                                province: currentId,
                                provinceName: selectedProvince,
                                city: cityId,
                                cityName: selectedCity)
                            : selectPropertySubType(
                                province: currentId,
                                provinceName: selectedProvince,
                                schemeName: selectScheme,
                                scheme: schemeId,
                                city: cityId,
                                cityName: selectedCity,
                                phaseName: null,
                                phase: null,
                                block: null,
                                blockName: null,
                                subBlock: subblockIds,
                                subBlockName: null,
                                adress: null,
                                // widget.adress,
                                propertyType: propertyType,
                              ),
                      ),
                    ),
                    // boolSelectScheme?Step(title: title, content: content);:Container();
                    Step(
                      isActive: true,
                      title: boolSelectScheme
                          ? Text("Select Subblocks")
                          : Text('Select Property Purpose'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: boolSelectScheme
                            ? selectSubblocks(
                                province: currentId,
                                provinceName: selectedProvince,
                                schemeName: selectScheme,
                                scheme: schemeId,
                                city: cityId,
                                cityName: selectedCity,
                                phase: null,
                                phaseName: null,
                                block: blockId,
                                blockName: null, //selectedBlock,
                              )
                            : selectPropertyPurpose(
                                province: currentId,
                                scheme: schemeId,
                                city: cityId,
                                phase: null,
                                block: null,
                                subBlock: subblockIds,
                                subBlockName: null,
                                adress: null,
                                propertyType: propertyType,
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
                      ),
                    ),
                    Step(
                      isActive: true,
                      title: boolSelectScheme
                          ? Text("Select Proper Type")
                          : Text('Select Area'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: boolSelectScheme
                            ? selectPropertyType(
                                // recently commented code
                                province: currentId,
                                provinceName: selectedProvince,
                                schemeName: selectScheme,
                                scheme: schemeId,
                                city: cityId,
                                cityName: selectedCity,
                                phaseName: null,
                                phase: null,
                                block: null,
                                blockName: null,
                                subBlock: subblockIds,

                                subBlockName: null,
                                // subBlockName ?? null,
                                //adress: adress.value.text,
                              )
                            : selectArea(
                                province: currentId,
                                scheme: schemeId,
                                city: cityId,
                                phase: null,
                                block: null,
                                subBlock: subblockIds,
                                subBlockName: null,
                                adress: null,
                                propertyType: propertyType,
                                propertySubType: propertySubType,
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
                      ),
                    ),
                    Step(
                      isActive: true,
                      title: boolSelectScheme
                          ? Text("Select Property Sub Type")
                          : Text('Select Adress'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        child: boolSelectScheme
                            ? selectPropertySubType(
                                province: currentId,
                                provinceName: selectedProvince,
                                schemeName: selectScheme,
                                scheme: schemeId,
                                city: cityId,
                                cityName: selectedCity,
                                phaseName: null,
                                phase: null,
                                block: null,
                                blockName: null,
                                subBlock: subblockIds,
                                subBlockName: null,
                                adress: null,
                                // widget.adress,
                                propertyType: propertyType,
                              )
                            : selectAddress(
                                showPlotToUser: isShowPlotInfoToUser!,
                                plotNumber: plotNumber,
                                province: currentId,
                                scheme: schemeId,
                                provinceName: selectProvince,
                                cityName: selectCity,
                                schemeName: schemeName,
                                phaseName: phaseName,
                                blockName: blockName,
                                subBlockName: subBlockName,
                                city: cityId,
                                phase: null,
                                block: block,
                                subBlock: subBlock,
                                propertyType: propertyType,
                                propertySubType: propertySubType,
                                area: area?.value.text,
                                areaUnit: unit,
                                demand: demand?.value.text,
                                description: details?.value.text,
                                //marker_x: null, // lat.value.text,
                                //marker_y: null, // long.value.text,
                                // -- finish here
                              ),
                      ),
                    ),
                    if (boolSelectScheme)
                      Step(
                        isActive: true,
                        title: Text("Proper Purpose"),
                        content: Container(
                            alignment: Alignment.centerLeft,
                            child: selectPropertyPurpose(
                              province: currentId,
                              scheme: schemeId,
                              city: cityId,
                              phase: null,
                              block: null,
                              subBlock: subblockIds,
                              subBlockName: null,
                              adress: null,
                              propertyType: propertyType,
                              propertySubType: propertySubType,
                            )),
                      ),

                    if (boolSelectScheme)
                      Step(
                        isActive: true,
                        title: Text("Select Area"),
                        content: Container(
                            alignment: Alignment.centerLeft,
                            child: selectArea(
                              province: currentId,
                              scheme: schemeId,
                              city: cityId,
                              phase: null,
                              block: null,
                              subBlock: subblockIds,
                              subBlockName: null,
                              adress: null,
                              propertyType: propertyType,
                              propertySubType: propertySubType,
                              // sent by floor--which we want to replace
                              washrooms: washrooms,
                              kitchens: kitchens,
                              basements: basements,
                              floors: floors,
                              parkings: parkings,
                              rooms: rooms,
                              // ---------------------------
                              purpose: purpose,
                            )),
                      ),

                    if (boolSelectScheme)
                      Step(
                        isActive: true,
                        title: Text('Select Adress'),
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: selectAddress(
                            showPlotToUser: isShowPlotInfoToUser!,
                            plotNumber: plotNumber,
                            province: currentId,
                            scheme: schemeId,
                            provinceName: selectProvince,
                            cityName: selectCity,
                            schemeName: schemeName,
                            phaseName: phaseName,
                            blockName: blockName,
                            subBlockName: subBlockName,
                            city: cityId,
                            phase: null,
                            block: block,
                            subBlock: subBlock,
                            propertyType: propertyType,
                            propertySubType: propertySubType,
                            area: area?.value.text,
                            areaUnit: unit,
                            demand: demand?.value.text,
                            description: details?.value.text,
                            //marker_x: null, // lat.value.text,
                            //marker_y: null, // long.value.text,
                            // -- finish here
                          ),
                        ),
                      )
                  ],
                ),
              )));
  }
}
