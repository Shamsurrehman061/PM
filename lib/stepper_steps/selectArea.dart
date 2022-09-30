import "package:flutter/material.dart";
import "package:flutter_dropdown/flutter_dropdown.dart";
import 'package:reale/main.dart';
import "package:simple_database/simple_database.dart";

import 'package:reale/widgets/custom_text_widget.dart';
import 'selectAdress.dart';

TextEditingController? area;
TextEditingController? demand;
TextEditingController? details;
// TextEditingController lat = TextEditingController();
// TextEditingController long = TextEditingController();
var unit;

bool? isShowPlotInfoToUser = false;
String? plotNumber="1";
String? schemeName;
String? phaseName;
String? blockName;
String? subBlockName;
var block;
var subBlock;

class selectArea extends StatefulWidget {
  static bool isstartSubmittingData = false;
  final scheme;
  final province;
  final city;
  final phase;

  final blockName;
  final provinceName;
  final cityName;
  final phaseName;
  final schemeName;

  final subBlockName;
  final adress;
  final propertyType;
  final propertySubType;
  final floors;
  final rooms;
  final kitchens;
  final basements;
  final washrooms;
  final parkings;
  final purpose;

  selectArea(
      {this.scheme,
      this.province,
      this.city,
      this.phase,
      block,
      subBlock,
      this.adress,
      this.propertyType,
      this.propertySubType,
      this.floors,
      this.rooms,
      this.basements,
      this.kitchens,
      this.washrooms,
      this.parkings,
      this.subBlockName,
      this.blockName,
      this.phaseName,
      this.cityName,
      this.schemeName,
      this.provinceName,
      this.purpose});

  @override
  _selectAreaState createState() => _selectAreaState();
}

class _selectAreaState extends State<selectArea> {
  // bool _isAreaDropDownEnable;
  //
  // _selectAreaState(): _isAreaDropDownEnable = true;

  // TextEditingController floors; // = TextEditingController();
  // TextEditingController rooms; // = TextEditingController();
  // TextEditingController kitchens; // = TextEditingController();
  // TextEditingController basements; // = TextEditingController();
  // TextEditingController washrooms; // = TextEditingController();
  // TextEditingController parkings; // = TextEditingController();


  SimpleDatabase? _province;
  SimpleDatabase? _city;
  SimpleDatabase? _phase;
  SimpleDatabase? _block;
  SimpleDatabase? _subBlock;
  SimpleDatabase? _scheme;

  String? provinceName;
  String? cityName;



  void isFieldEmpty() {
    // TextEditingController area = TextEditingController();
    // TextEditingController demand = TextEditingController();
    // TextEditingController details = TextEditingController();
    if ((area?.text.trim().length == 0) ||
        (demand?.text.trim().length == 0) ||
        (details?.text.trim().length == 0)) {
      print('isFieldEmpty() -> false');
      selectArea.isstartSubmittingData = false;
    } else {
      // do nothing
      print('isFieldEmpty() -> true');
      selectArea.isstartSubmittingData = true;
    }
  }

  Future<void> getValueFromDatabase() async {
    _province = SimpleDatabase(name: 'province');
    _city = SimpleDatabase(name: 'city');
    _phase = SimpleDatabase(name: 'phase');
    _block = SimpleDatabase(name: 'block');
    _subBlock = SimpleDatabase(name: 'subBlock');
    _scheme = SimpleDatabase(name: 'scheme');

    provinceName = await _province?.getAt(0) as String;
    cityName = await _city?.getAt(0) as String;
    schemeName = await _scheme?.getAt(0) as String;
    phaseName = await _phase?.getAt(0) as String;
    blockName = await _block?.getAt(0) as String;
    subBlockName = await _subBlock?.getAt(0) as String;
  }

  @override
  void initState() {
    area = TextEditingController(text: '');
    demand = TextEditingController(text: '');
    details = TextEditingController(text: '');
    // floors = TextEditingController(text: "0");
    // rooms = TextEditingController(text: "0");
    // kitchens = TextEditingController(text: "0");
    // parkings = TextEditingController(text: "0");
    // basements = TextEditingController(text: "0");
    // washrooms = TextEditingController(text: "0");
    // ----

    getValueFromDatabase();
    super.initState();
  }

  @override
  void dispose() {
    print('select Area dispose method called');
    // floors.dispose();
    // rooms.dispose();
    // kitchens.dispose();
    // parkings.dispose();
    // basements.dispose();
    // washrooms.dispose();
    // area.dispose();
    // demand.dispose();
    // details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 15),
        TextField(
          onChanged: (value) {
            houseModel.area = value;
            isFieldEmpty();
          },
          keyboardType: TextInputType.phone,
          controller: area,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            isDense: true,
            labelText: "Enter Area*",
          ),
        ),
        DropDown(
          items: ["Squareft", "Marla"],
          hint: Text("Units"),
          initialValue:
              houseModel.areaUnit.length > 0 ? houseModel.areaUnit : null,
          onChanged: (val) {
            setState(() {
              unit = val;
              houseModel.areaUnit = val.toString();
              //_isAreaDropDownEnable = false;
            });
          },
        ),
        // demand
        // ======
        // =====
        // SizedBox(height: 15),
        // TextField(
        //   keyboardType: TextInputType.phone,
        //   controller: Demand,
        //   decoration: InputDecoration(
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       isDense: true,
        //       labelText: "Enter Demand"),
        // ),
        // details here
        // removed this and place 6 textfields here
        // start here
        // TextField(
        //   keyboardType: TextInputType.phone,
        //   controller: floors,
        //   decoration: InputDecoration(labelText: "Number of Floors"),
        // ),
        // TextField(
        //   keyboardType: TextInputType.phone,
        //   controller: rooms,
        //   decoration: InputDecoration(labelText: "Number of Rooms"),
        // ),
        // TextField(
        //   keyboardType: TextInputType.phone,
        //   controller: kitchens,
        //   decoration: InputDecoration(labelText: "Number of Kitchens"),
        // ),
        // TextField(
        //   keyboardType: TextInputType.phone,
        //   controller: basements,
        //   decoration: InputDecoration(labelText: "Number of Basement"),
        // ),
        // TextField(
        //   keyboardType: TextInputType.phone,
        //   controller: washrooms,
        //   decoration: InputDecoration(labelText: "Number of Washrooms"),
        // ),
        // TextField(
        //   keyboardType: TextInputType.phone,
        //   controller: parkings,
        //   decoration: InputDecoration(labelText: "Number of Car Parking"),
        // ),
        // end here
        // SizedBox(height: 15),
        // detail
        // =======
        // =======

        TextField(
          onChanged: (value) {
            houseModel.demand = value;
            isFieldEmpty();
          },
          keyboardType: TextInputType.phone,
          maxLines: 1,
          controller: demand,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              labelText: "Enter Demand*"),
        ),
        SizedBox(height: 15),
        TextField(
          onChanged: (value) {
            houseModel.description = value;
          },
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          controller: details,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              labelText: "Enter Details",
              hintText:
                  "No of Rooms/ Basement/ Car Parking/ Washroom/ Kitchen/ No of Floors"),
        ),
        SizedBox(height: 15),
        TextField(
          onChanged: (String value) {
            plotNumber = value;
            houseModel.plotNumber = value;
            isFieldEmpty();
          },
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              labelText: "Plot / Flat / Khasra*"),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            CustomTextWidget(text1: 'Show'),
            Radio<bool>(
              value: true,
              groupValue: isShowPlotInfoToUser,
              onChanged: (value) {
                setState(() {
                  isShowPlotInfoToUser = value;
                });
              },
            ),
            CustomTextWidget(text1: 'Hide'),
            Radio<bool>(
              value: false,
              groupValue: isShowPlotInfoToUser,
              onChanged: (value) {
                setState(() {
                  isShowPlotInfoToUser = value;
                });
              },
            )
          ],
        ),
        SizedBox(height: 15),
        // TextField(
        //   onChanged: (String value) {
        //     Lat.text = value;
        //   },
        //   keyboardType: TextInputType.phone,
        //   controller: Lat,
        //   decoration: InputDecoration(
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       isDense: true,
        //       labelText: "Enter Location latitude"),
        // ),
        // SizedBox(height: 15),
        // TextField(
        //   onChanged: (String value) {
        //     Long.text = value;
        //   },
        //   keyboardType: TextInputType.phone,
        //   controller: Long,
        //   decoration: InputDecoration(
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       isDense: true,
        //       labelText: "Enter Location longitude"),
        //),
        // address widget
        SizedBox(height: 15),
        selectAddress(
          showPlotToUser: isShowPlotInfoToUser!,

          plotNumber: plotNumber!,
          province: widget.province,
          scheme: widget.scheme,
          provinceName: provinceName,
          cityName: cityName,
          schemeName: schemeName,
          phaseName: phaseName,
          blockName: blockName,
          subBlockName: subBlockName,
          city: widget.city,
          phase: widget.phase,
          block: block,
          subBlock: subBlock,
          propertyType: widget.propertyType,
          propertySubType: widget.propertySubType,
          // ---
          // washrooms: washrooms.value.text,
          // kitchens: kitchens.value.text,
          // basements: basements.value.text,
          // floors: floors.value.text,
          // parkings: parkings.value.text,
          // rooms: rooms.value.text,
          // old code
          // washrooms: widget.washrooms,
          // kitchens: widget.kitchens,
          // basements: widget.basements,
          // floors: widget.floors,
          // parkings: widget.parkings,
          // rooms: widget.rooms,
          // ---
          area: area?.value.text,
          areaUnit: unit,
          demand: demand?.value.text,
          description: details?.value.text,
          //marker_x: null, // lat.value.text,
          //marker_y: null, // long.value.text,
          // -- finish here
        ),
        // Center(
        //   child: RaisedButton(
        //     color: Colors.green,
        //     onPressed: () async {
        //       print(
        //           'Firebase Auth ID: ${FirebaseAuth.instance.currentUser.uid}'); // EYacB6GVdIPv1CKwZxf5JpiGJNA3
        //       // all db are used here
        //       SimpleDatabase _province = SimpleDatabase(name: 'province');
        //       SimpleDatabase _city = SimpleDatabase(name: 'city');
        //       SimpleDatabase _phase = SimpleDatabase(name: 'phase');
        //       SimpleDatabase _block = SimpleDatabase(name: 'block');
        //       SimpleDatabase _subBlock = SimpleDatabase(name: 'subBlock');
        //       SimpleDatabase _scheme = SimpleDatabase(name: 'scheme');
        //       // notice this
        //       InformationStepper.refresh(isShowLoader: true);
        //       InformationStepper.allSteps.add({
        //         'color': Colors.white,
        //         'background': Colors.green,
        //
        //         // should update it
        //         'label': '123',
        //         'content': Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Text(
        //               'Select Address',
        //               style: TextStyle(fontSize: 18.0),
        //             ),
        //             selectAdress(
        //               province: widget.province,
        //               scheme: widget.scheme,
        //               provinceName: await _province.getAt(0) as String,
        //               cityName: await _city.getAt(0) as String,
        //               schemeName: await _scheme.getAt(0) as String,
        //               phaseName: await _phase.getAt(0) as String,
        //               blockName: await _block.getAt(0) as String,
        //               subBlockName: await _subBlock.getAt(0) as String,
        //               city: widget.city,
        //               phase: widget.phase,
        //               block: widget.block,
        //               subBlock: widget.subBlock,
        //               propertyType: widget.propertyType,
        //               propertySubType: widget.propertySubType,
        //               // ---
        //               // washrooms: washrooms.value.text,
        //               // kitchens: kitchens.value.text,
        //               // basements: basements.value.text,
        //               // floors: floors.value.text,
        //               // parkings: parkings.value.text,
        //               // rooms: rooms.value.text,
        //               // old code
        //               // washrooms: widget.washrooms,
        //               // kitchens: widget.kitchens,
        //               // basements: widget.basements,
        //               // floors: widget.floors,
        //               // parkings: widget.parkings,
        //               // rooms: widget.rooms,
        //               // ---
        //               area: Area.value.text,
        //               areaUnit: unit,
        //               demand: Demand.value.text,
        //               description: Details.value.text,
        //               marker_x: Lat.value.text,
        //               marker_y: Long.value.text,
        //               // -- finish here
        //             ),
        //           ],
        //         ),
        //       });
        //       InformationStepper.refresh(isShowLoader: false);
        //
        //       /*
        //       // should move all this task in address page
        //       SimpleDatabase province = SimpleDatabase(name: 'province');
        //       SimpleDatabase city = SimpleDatabase(name: 'city');
        //       SimpleDatabase phase = SimpleDatabase(name: 'phase');
        //       SimpleDatabase block = SimpleDatabase(name: 'block');
        //       SimpleDatabase subBlock = SimpleDatabase(name: 'subBlock');
        //       SimpleDatabase scheme = SimpleDatabase(name: 'scheme');
        //
        //       FirebaseAuth auth = FirebaseAuth.instance;
        //       CollectionReference listings =
        //           FirebaseFirestore.instance.collection('listings');
        //
        //       await listings.add({
        //         "province": widget.province,
        //         "scheme": widget.scheme,
        //         "provinceName": await province.getAt(0),
        //         "cityName": await city.getAt(0),
        //         "schemeName": await scheme.getAt(0),
        //         "phaseName": await phase.getAt(0),
        //         "blockName": await block.getAt(0),
        //         "subBlockName": await subBlock.getAt(0),
        //         "district": widget.city,
        //         "phase": widget.phase,
        //         "block": widget.block,
        //         "subblock": widget.subBlock,
        //         "adress": widget.adress,
        //         "type": widget.propertyType,
        //         "subType": widget.propertySubType,
        //         // sent by floor--which we want to replace
        //         "washroom": widget.washrooms,
        //         "kitchens": widget.kitchens,
        //         "basements": widget.basements,
        //         "floors": widget.floors,
        //         "parkings": widget.parkings,
        //         "rooms": widget.rooms,
        //         // ---------------------------
        //         "sale": widget.purpose,
        //         "sold": "no",
        //         // should move to new page
        //         // --- content of selectArea--
        //         "area": Area.value.text,
        //         "areaUnit": unit,
        //         "demand": Demand.value.text,
        //         "description": Details.value.text,
        //         "marker_x": Lat.value.text,
        //         "marker_y": Long.value.text,
        //         // -- finish here
        //         "seller": "${await auth.currentUser.uid}",
        //         "name": await auth.currentUser.displayName,
        //         "time": DateTime.now(),
        //       }).then((value) async {
        //         CollectionReference updates =
        //             FirebaseFirestore.instance.collection('updates');
        //         updates.add({
        //           "user": "${await auth.currentUser.displayName}",
        //           "action": "created",
        //           "createdAt": Timestamp.now(),
        //           "id": value.id
        //         });
        //       });
        //
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (context) {
        //         return Scaffold(
        //           body: ListView(
        //             children: [
        //               Center(
        //                 child: Text(
        //                   "Your Listing was Succesfully Posted",
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     fontSize: 25,
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 30,
        //               ),
        //               RaisedButton(
        //                 shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(18.0),
        //                     side: BorderSide(color: Colors.white)),
        //                 color: Colors.blueAccent,
        //                 elevation: 10,
        //                 padding: EdgeInsets.all(15),
        //                 onPressed: () {
        //                   for (var i = 0; i <= 12; i++) {
        //                     Navigator.pop(context);
        //                   }
        //                 },
        //                 child: Text(
        //                   "DONE",
        //                   style: TextStyle(
        //                       color: Colors.white,
        //                       fontFamily: "Times New Roman",
        //                       fontWeight: FontWeight.w700,
        //                       fontSize: 20),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       }));
        //       */
        //     },
        //     child: Icon(
        //       Icons.navigate_next,
        //       color: Colors.white,
        //     ),
        //   ),
        // )
      ],
    );
  }
}
