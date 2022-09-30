import 'dart:developer' as dev;

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import "package:reale/stepper_steps/selectCity.dart";
import 'package:reale/widgets/TextContainer.dart';
import 'package:reale/widgets/setting_stepper.dart';
import "package:simple_database/simple_database.dart";

var selectedProvince;
var provinces = [];
var provinceIds = [];
var currentId;

class selectProvince extends StatefulWidget {
  //void Function({bool isShowLoader}) refresh;
  //selectProvince({this.refresh});
  @override
  _selectProvinceState createState() => _selectProvinceState();
}

class _selectProvinceState extends State<selectProvince> {
  // static bool _isProvinceDropDownEnable = true;
  //
  // //_selectProvinceState(): _isProvinceDropDownEnable = true;

  @override
  void initState() {
    print('province init()');
    super.initState();
  }

  @override
  void dispose() {
    print('province dispose()');
    //_isProvinceDropDownEnable = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(selectedProvince);
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("province")
              .orderBy("name", descending: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.hasData) {
              var el = snapshot.data.docs;
              provinces = [];
              provinceIds = [];
              for (var e in el) {
                if (e.data() != null) {
                  provinces.add(e.data()["name"]);
                  provinceIds.add(e.data()["id"]);
                }
              }
              print(provinces);
              dev.log(
                  'province outside the onChange: content: $provinces \nProvince id: $provinceIds');

              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IgnorePointer(
                          ignoring: !stepperStateModel.isProvinceDropDownEnable,
                          child: DropDown<dynamic>(
                            items: provinces,
                            hint: Text("select province"),
                            initialValue: houseModel.provinceName.length > 0
                                ? houseModel.provinceName
                                : null,
                            //initialValue: houseModel.provinceName ?? provinces[0],
                            onChanged: (val) async {





                              dev.log(
                                  'province inside the onChange: content: $provinces \nProvince id: $provinceIds');
                              SimpleDatabase province =
                                  SimpleDatabase(name: 'province');
                              await province.clear();
                              await province.add('${val}');
                              // storing the province into house model
                              houseModel.provinceName = val.toString();

                              setState(() {
                                // imp note
                                // =========
                                // logic to save previous tree and clean forward tree
                                // whenever user will select any dropdown then
                                // all previous drop down should maintain their state
                                // while the drop downs from where user choose
                                // something will be cleared from screen
                                var previousStep =
                                    InformationStepper.allSteps[0];
                                print(
                                    'before list length: ${InformationStepper.allSteps.length}');
                                InformationStepper.allSteps.clear();
                                print(
                                    'after list length: ${InformationStepper.allSteps.length}');
                                InformationStepper.refresh();
                                InformationStepper.allSteps = [previousStep];
                                selectedProvince = val;
                                print(selectedProvince);
                                currentId = provinceIds[
                                    provinces.indexOf(selectedProvince)];
                                houseModel.province = currentId;
                                print('Current id: ' + currentId);
                                stepperStateModel.isProvinceDropDownEnable =
                                    false;
                                index+=1;
                                selectCity(
                                    province: currentId,
                                    provinceName: selectedProvince);
                              });
                              InformationStepper.refresh(isShowLoader: true);
                              InformationStepper.allSteps.add({
                                'color': Colors.white,
                                'background': Colors.green,
                                'label': '2',
                                'content': Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Select District',
                                      style: TextStyle(fontSize: 18.0),
                                    ),

                                    selectCity(
                                        province: currentId,
                                        provinceName: selectedProvince)
                                  ],
                                ),
                              });
                              InformationStepper.refresh(isShowLoader: false);
                            },
                          ),
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.delete),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                    /*
                    * selectCity(
                              province: currentId,
                              provinceName: selectedProvince);
                     */
                    // RaisedButton(
                    //   onPressed: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) {
                    //       return selectCity(
                    //           province: currentId,
                    //           provinceName: selectedProvince);
                    //     }));
                    //   },
                    //   child: Icon(Icons.navigate_next),
                    // )
                  ],
                ),
              );
            } else {
              return TextContainer();
            }
          }),
    );
  }
}
