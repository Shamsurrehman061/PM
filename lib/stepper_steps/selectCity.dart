import "dart:developer" as dev;

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import 'package:reale/stepper_steps/select_scheme_route.dart';
import "package:reale/widgets/TextContainer.dart";
import 'package:reale/widgets/setting_stepper.dart';
import "package:simple_database/simple_database.dart";

var cities = [];
var cityIds = [];
var selectedCity = "";
var cityId;

class selectCity extends StatefulWidget{

  final province;
  final provinceName;

  selectCity({this.province, this.provinceName});

  @override
  _selectCityState createState() => _selectCityState();
}

class _selectCityState extends State<selectCity> {
  // bool _isCityDropDownEnable;
  //
  // _selectCityState(): _isCityDropDownEnable = true;

  @override
  void initState() {
    super.initState();
    print('city init()');
  }

  @override
  void dispose() {
    print('city dispose()');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("cities")
              .orderBy("name", descending: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              //InformationStepper.refresh(isShowLoader: false);
              var el = snapshot.data.docs;
              cities = [];
              cityIds = [];
              for (var e in el) {
                if (e.data() != null) {
                  if (e.data()["provinceID"] == widget.province) {
                    cities.add(e.data()["name"]);
                    cityIds.add(e.data()["id"]);
                  }
                }
              }
              //print(cities);
              //print(cityIds);
              dev.log(
                  'city outside the onChange: content: $cities \ncities id: $cityIds');
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: !stepperStateModel.isCityDropDownEnable,
                      child: DropDown<dynamic>(
                        items: cities,
                        // items: houseModel.cityName.length > 0
                        //     ? [houseModel.cityName]
                        //     : cities,
                        initialValue: houseModel.cityName.isNotEmpty
                            ? houseModel.cityName
                            : null,
                        hint: Text("select city"),
                        onChanged: (val) async {
                          dev.log(
                              'city outside the onChange: content: $cities \ncities id: $cityIds');
                          var previousStep1 =
                              InformationStepper.allSteps[0]; // for province
                          var previousStep2 =
                              InformationStepper.allSteps[1]; // for city
                          InformationStepper.allSteps.clear();
                          InformationStepper.allSteps = [
                            previousStep1,
                            previousStep2
                          ];

                          SimpleDatabase city = SimpleDatabase(name: 'city');
                          await city.clear();
                          await city.add('${val}');

                          setState(() {
                            selectedCity = val.toString();

                            print(selectedCity);
                            // cityID is the index of city in city list
                            cityId = cityIds[cities.indexOf(selectedCity)];
                            houseModel.cityName = selectedCity;
                            houseModel.city = cityId;
                            print(cityId);
                            stepperStateModel.isCityDropDownEnable = false;
                          });

                          InformationStepper.refresh(isShowLoader: true);
                          InformationStepper.allSteps.add({
                            'color': Colors.white,
                            'background': Colors.green,
                            'label': '3',
                            'content': Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Select Scheme/ Non-Scheme',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                // new code
                                SchemeType(
                                  province: widget.province,
                                  provinceName: widget.provinceName,
                                  city: cityId,
                                  cityName: selectedCity,
                                ),
                              ],
                            ),
                          });
                          InformationStepper.refresh(isShowLoader: false);
                        },
                      ),
                    ),
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
