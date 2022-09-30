

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/stylishCustomButton.dart';



class SelectArea extends StatefulWidget {
  const SelectArea({Key? key, required this.isScheme}) : super(key: key);

  final bool isScheme;
  @override
  _SelectAreaState createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea> {

  Box box = Hive.box<dynamic>('userData');

  final db = FirebaseFirestore.instance.collection('listings');
  final upd = FirebaseFirestore.instance.collection('updates');
  final plotInfo = FirebaseFirestore.instance.collection('plot_info');
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance.ref();
  
  bool isShownPlotInfo = false;
  bool isLoading = false;

  final TextEditingController areaController = TextEditingController();
  final TextEditingController demandController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController plotFlatKharsaraController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String provinceName = "";
  String provinceId = "";
  String city = "";
  String cityId = "";
  String scheme = "";
  String type = "";
  String typeId = "";
  String phase = "";
  String phaseId = "";
  String block = "";
  String blockId = "";
  String subBlock = "";
  String subBlockId = "";
  String propertyType = "";
  String subPropertyType = "";
  String purpose = "";

  void getData()
  {
    provinceName = box.get('provinceName');
    provinceId = box.get('provinceId');
    city = box.get('city');
    cityId = box.get('cityId');
    scheme = box.get('schemeData');
    type = box.get('type');
    typeId = box.get('typeId');
    propertyType = box.get('propertyType');
    subPropertyType = box.get('propertySubType');
    purpose = box.get('purpose');
  }

  void getAllData()
  {
    provinceName = box.get('provinceName');
    provinceId = box.get('provinceId');
    city = box.get('city');
    cityId = box.get('cityId');
    scheme = box.get('schemeData');
    type = box.get('type');
    typeId = box.get('typeId');
    phase = box.get('phase');
    phaseId = box.get('phaseId');
    block = box.get('block');
    blockId = box.get('blockId');
    subBlock = box.get('subBlock');
    subBlockId = box.get('subBlockId');
    propertyType = box.get('propertyType');
    subPropertyType = box.get('propertySubType');
    purpose = box.get('purpose');
  }

  File? image;


  void showMsg(String msg)
  {
    Fluttertoast.showToast(
      gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
        msg: msg
    );
  }

  void getImage()async{
        final pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
        setState(() {
          image = File(pickedImage!.path);
        });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isScheme ? getAllData() : getData();
  }


  String _verticalGroupValue = "Show";
  String selectedUnit = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Entry Details"),
        centerTitle: true,

      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Area*",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                controller: areaController,
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: DropDown<dynamic>(
                  items: ['Squareft', 'Marla'],
                  hint: Text('units'),
                  onChanged: (val)
                  {
                    setState((){
                      selectedUnit = val;
                    });
                  },
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Demand*",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                controller: demandController,
              ),

              SizedBox(
                height: 10.0,
              ),
              
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter Details*",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                controller: detailsController,
              ),

              const SizedBox(
                height: 10.0,
              ),


              TextFormField(
                decoration: InputDecoration(
                  hintText: "Plot/ Flat/ Khasra*",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                controller: plotFlatKharsaraController,
              ),

              RadioGroup<String>.builder
                (
                  direction: Axis.horizontal,
                  groupValue: _verticalGroupValue,
                  textStyle: TextStyle(fontSize: 25),
                  horizontalAlignment: MainAxisAlignment.spaceAround,
                  onChanged: (val)
                  {
                    if(val == 'Show')
                      {
                        setState(() {
                          _verticalGroupValue = val!;
                          isShownPlotInfo = true;
                        });
                      }
                    else
                      {
                        setState(() {
                          _verticalGroupValue = val!;
                          isShownPlotInfo = false;
                        });
                      }
                    
                  },
                  items: ['Show', 'Hide'],
                  itemBuilder: (item){
                    return RadioButtonBuilder(item);
                  }
              ),


              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Address*",
                  labelText: 'Address',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                controller: addressController,
              ),

              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    getImage();
                  },
                  child:const Text(
                    'Add Images',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 2,) : StylishCustomButton(
                text: "Submit",
                icon: Icons.check_circle,
                onPressed: () async {

                  FocusScope.of(context).unfocus();
                  setState(() {
                    isLoading = true;
                  });
                  
                  final result =await storage.child("location_images").child(city);
                  await result.putFile(image!.absolute);
                  String imgpath = await result.getDownloadURL();



                 await db.add({
                    "province": provinceId.toString()?? "",
                    "scheme": typeId.toString() ?? "",
                    "provinceName": provinceName.toString() ?? "",
                    "cityName": city.toString() ?? "",
                    "schemeName": type.toString() ?? "",
                    "phaseName": phase.toString() ?? "",
                    "blockName": block.toString() ?? "",
                    "subBlockName": subBlock.toString() ?? "",
                    "district": cityId.toString() ?? "",
                    "phase": phaseId.toString() ?? "",
                    "block": blockId.toString() ?? "",
                    "subblock": subBlockId.toString() ?? "",
                    "adress": addressController.text.toString() ?? "",
                    "type": propertyType.toString() ?? "",
                    "subType": subPropertyType.toString() ?? "",
                    // "washroom": widget.washrooms,
                    // "kitchens": widget.kitchens,
                    // "basements": widget.basements,
                    // "floors": widget.floors,
                    // "parkings": widget.parkings,
                    // "rooms": widget.rooms,
                    "sale": purpose.toString() ?? "",
                    "sold": "no", // static value used for time being
                    "area": areaController.text.toString() ?? "",
                    "areaUnit": selectedUnit.toString() ?? "",
                    "demand": demandController.text.toString() ?? "",
                    "description": detailsController.text.toString() ?? "",
                    "marker_x": null, //widget.marker_x ?? houseModel.marker_x,
                    "marker_y": null, //widget.marker_y ?? houseModel.marker_y,
                    "seller": "${auth.currentUser?.uid}",
                    "name": auth.currentUser?.displayName ?? "",
                    "time": DateTime.now(),
                    "schemeImageURL": imgpath.toString() ?? "",
                    "isShowPlotInfoToUser": isShownPlotInfo ?? "",
                    "plotInfo": plotFlatKharsaraController.text.toString() ?? "", //widget.plotNumber.toString(),
                  }).then((value)async{

                    await plotInfo.add({
                      "user": "${auth.currentUser?.displayName}",
                      "plotInfo": plotFlatKharsaraController.text.toString(),
                      "createdAt": Timestamp.now(),
                      "listingCollectionID": value.id,
                    });

                    await upd.add({
                      "user": "${auth.currentUser?.displayName}",
                      "action": "created",
                      "createdAt": Timestamp.now(),
                      "id": value.id,
                    });

                    setState(() {
                      isLoading = false;
                    });
                    showMsg('Successful');
                  }).onError((error, stackTrace){
                   setState(() {
                     isLoading = false;
                   });
                   showMsg('Failed');
                  });

                  setState(() {
                    isLoading = false;
                  });
                  },
              )
            ],
          ),
        ),
      ),
    );
  }
}
