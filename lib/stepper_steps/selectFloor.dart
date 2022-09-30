import "package:flutter/material.dart";
import "package:reale/stepper_steps/selectPropertyPurpose.dart";
import 'package:reale/widgets/setting_stepper.dart';

TextEditingController floors = TextEditingController();
TextEditingController rooms = TextEditingController();
TextEditingController kitchens = TextEditingController();
TextEditingController basements = TextEditingController();
TextEditingController washrooms = TextEditingController();
TextEditingController parkings = TextEditingController();

class selectFloor extends StatefulWidget {
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

  selectFloor(
      {this.scheme,
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
      this.propertySubType});

  @override
  _selectFloorState createState() => _selectFloorState();
}

class _selectFloorState extends State<selectFloor> {
  @override
  void initState() {
    floors.value = TextEditingValue(text: "0");
    rooms.value = TextEditingValue(text: "0");
    kitchens.value = TextEditingValue(text: "0");
    parkings.value = TextEditingValue(text: "0");
    basements.value = TextEditingValue(text: "0");
    washrooms.value = TextEditingValue(text: "0");
    //parkings.value = TextEditingValue(text: "0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Text(
          //   "Screen 10/12",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // should move to their new position
          TextField(
            keyboardType: TextInputType.phone,
            controller: floors,
            decoration: InputDecoration(labelText: "Number of Floors"),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            controller: rooms,
            decoration: InputDecoration(labelText: "Number of Rooms"),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            controller: kitchens,
            decoration: InputDecoration(labelText: "Number of Kitchens"),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            controller: basements,
            decoration: InputDecoration(labelText: "Number of Basement"),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            controller: washrooms,
            decoration: InputDecoration(labelText: "Number of Washrooms"),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            controller: parkings,
            decoration: InputDecoration(labelText: "Number of Car Parking"),
          ),
          MaterialButton(
            onPressed: () {
              InformationStepper.refresh(isShowLoader: true);
              InformationStepper.allSteps.add({
                'color': Colors.white,
                'background': Colors.lightBlue.shade200,
                'label': '11',
                'content': Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Select More Information',
                      style: TextStyle(fontSize: 18.0),
                    ),
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
                      propertySubType: widget.propertySubType,
                      // sent by this class 6 parameters
                      // want to replace it position in hierarchy
                      // washrooms: washrooms.value.text,
                      // kitchens: kitchens.value.text,
                      // basements: basements.value.text,
                      // floors: floors.value.text,
                      // parkings: parkings.value.text,
                      // rooms: rooms.value.text,
                    ),
                  ],
                ),
              });
              InformationStepper.refresh(isShowLoader: false);
              // ----------------------------------------------------------
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   //Proceed from here
              //   return selectPropertyPurpose(
              //     province: widget.province,
              //     scheme: widget.scheme,
              //     city: widget.city,
              //     phase: widget.phase,
              //     block: widget.block,
              //     subBlock: widget.subBlock,
              //     subBlockName: widget.subBlockName,
              //     adress: widget.adress,
              //     propertyType: widget.propertyType,
              //     propertySubType: widget.propertySubType,
              //     washrooms: washrooms.value.text,
              //     kitchens: kitchens.value.text,
              //     basements: basements.value.text,
              //     floors: floors.value.text,
              //     parkings: parkings.value.text,
              //     rooms: rooms.value.text,
              //   );
              // }));
            },
            child: Icon(Icons.navigate_next),
          )
        ],
      ),
    );
  }
}
