import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/select_property_type.dart';
import 'package:reale/EntryDetails/select_purpose.dart';
import 'package:reale/stepper_steps/selectPropertyType.dart';

class SelectPropertySubType extends StatefulWidget {
  const SelectPropertySubType({Key? key, required this.propertyType, required this.provinceId, required this.cityId, required this.typeId, required this.isScheme}) : super(key: key);

  final String propertyType;
  final String provinceId;
  final String cityId;
  final String typeId;
  final bool isScheme;

  @override
  _SelectPropertySubTypeState createState() => _SelectPropertySubTypeState();
}

class _SelectPropertySubTypeState extends State<SelectPropertySubType>{

  Box box = Hive.box<dynamic>('userData');
  var dynamicItems = [];

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

  String propertySubType = "";


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Entry Details"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropDown<dynamic>(
              hint: Text("select sub type"),
              items: dynamicItems,
              onChanged: (val)
              {
                setState((){
                  propertySubType = val;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.delete('propertySubType');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectPropertyType(
                      provinceId: widget.provinceId,
                      cityId: widget.cityId,
                      typeId: widget.typeId,
                      isScheme: widget.isScheme,
                    )));
                  }, child: Text("Back"),),

                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('propertySubType', propertySubType);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SelectPurpose(
                            propertyType: widget.propertyType,
                            provinceId: widget.provinceId,
                            cityId: widget.cityId,
                            typeId: widget.typeId,
                            isScheme: widget.isScheme,
                          ),
                        ));
                  },
                  child: Text("Continue"),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
