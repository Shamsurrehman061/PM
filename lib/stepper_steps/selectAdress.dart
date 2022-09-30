import 'dart:io';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:reale/main.dart';
import 'package:reale/resources/constant.dart';
import 'package:reale/stepper_steps/selectArea.dart';
import 'package:reale/widgets/stylishCustomButton.dart';
import 'package:simple_database/simple_database.dart';



TextEditingController adress = TextEditingController();
File? _image;
List<File> _allUserSelectedImages = [];
final picker = ImagePicker();

class selectAddress extends StatefulWidget {
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
  final propertyType;
  final propertySubType;
  final floors;
  final rooms;
  final kitchens;
  final basements;
  final washrooms;
  final parkings;
  final purpose;
  // incoporate from select area page
  final area;
  final areaUnit;
  final demand;
  final description;
  // final marker_x;
  // final marker_y;
  String? plotNumber;
  bool? showPlotToUser;

  selectAddress({
    this.scheme,
    this.province,
    this.city,
    this.phase,
    this.block,
    this.subBlock,
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
    this.purpose,
    this.area,
    this.areaUnit,
    this.demand,
    this.description,
    // this.marker_x,
    // this.marker_y,
    this.plotNumber,
    this.showPlotToUser,
  });

  @override
  _selectAddressState createState() => _selectAddressState();
}

class _selectAddressState extends State<selectAddress> {

  bool _isImageSaving = false;
  bool isImagesUploadingSelected = false;
  String? schemeImageURL;
  Map<String, String> _allFirebaseStorageImagesLink = {};
  Future<void> getImageURFromStorage({String? imageName}) async {
    print('image get from storage: $imageName');
    print('image path: ${'location_images/$imageName.jpg'}');
    FirebaseStorage _storage = FirebaseStorage.instance;

    //me *****************************************
    // StorageReference firebaseStorageRef =
    //     FirebaseStorage.instance.ref().child('location_images/$imageName.jpg');
    // schemeImageURL = await firebaseStorageRef.getDownloadURL();
    houseModel.schemeImageURL = schemeImageURL!;
    print('image url is: $schemeImageURL');

    // save it into firestore
  }

  @override
  void initState() {
    _allFirebaseStorageImagesLink = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            onChanged: (value) {
              houseModel.address = value;
            },
            maxLines: 3,
            controller: adress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              hintText: "Select Address",
              labelText: "Select Address",
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            child: MaterialButton(
              color: Colors.green,
              child: Text(
                'Add Images',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                // image related function
                print('adding images button pressed...');
                print('House model info showing on the console');
                print(houseModel.toJson());
                print(houseModel.toJson().length);
                await saveImageToStorageAndFirestore(
                    uploadImages: false, documentId: '');
                //isImagesUploadingSelected = true;
              },
            ),
          ),
          StylishCustomButton(
            text: "Submit",
            icon: Icons.check_circle,
            onPressed: () async {
              if (selectArea.isstartSubmittingData == false) {
                // show popup
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Missing Mandatory Fields'),
                    content: Text('Provide the value for mandatory fields'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          print('Ok');
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }

              //should move all this task in address page
              SimpleDatabase _province = SimpleDatabase(name: 'province');
              SimpleDatabase _city = SimpleDatabase(name: 'city');
              SimpleDatabase _phase = SimpleDatabase(name: 'phase');
              SimpleDatabase _block = SimpleDatabase(name: 'block');
              SimpleDatabase _subBlock = SimpleDatabase(name: 'subBlock');
              SimpleDatabase _scheme = SimpleDatabase(name: 'scheme');

              print('House model content: \n${houseModel.toJson()}');
              FirebaseAuth auth = FirebaseAuth.instance;

              CollectionReference plotCollection =
                  FirebaseFirestore.instance.collection('plot_info');

              CollectionReference listings =
                  FirebaseFirestore.instance.collection('listings');
              // get scheme image url from firestorage
              // check city and store its corresponding image url

              switch (houseModel.schemeName) {
                case "bahria":
                  // do operation
                  setState(() {
                    _isImageSaving = true;
                  });
                  await getImageURFromStorage(imageName: houseModel.schemeName);
                  setState(() {
                    _isImageSaving = false;
                  });
                  break;
                case "regi model town":
                  // do operation
                  setState(() {
                    _isImageSaving = true;
                  });
                  await getImageURFromStorage(imageName: houseModel.schemeName);
                  setState(() {
                    _isImageSaving = false;
                  });
                  break;
                case "karachi dha":
                  // do operation
                  setState(() {
                    _isImageSaving = true;
                  });
                  await getImageURFromStorage(imageName: houseModel.schemeName);
                  setState(() {
                    _isImageSaving = false;
                  });
                  break;
                case "charsada town":
                  // do operation
                  setState(() {
                    _isImageSaving = true;
                  });
                  await getImageURFromStorage(imageName: houseModel.schemeName);
                  setState(() {
                    _isImageSaving = false;
                  });
                  break;
                case "bannu town":
                  // do operation
                  setState(() {
                    _isImageSaving = true;
                  });
                  await getImageURFromStorage(imageName: houseModel.schemeName);
                  setState(() {
                    _isImageSaving = false;
                  });
                  break;
                default:
                  print('wrong scheme was encountered');
              }
              listings.add({
                "province": widget.province ?? houseModel.province,
                "scheme": widget.scheme ?? houseModel.scheme,
                "provinceName": widget.provinceName ?? houseModel.provinceName,
                "cityName": widget.cityName ?? houseModel.cityName,
                "schemeName": widget.schemeName ?? houseModel.schemeName,
                "phaseName": widget.phaseName ?? houseModel.phaseName,
                "blockName": widget.blockName ?? houseModel.blockName,
                "subBlockName": widget.subBlockName ?? houseModel.subBlockName,
                "district": widget.city ?? houseModel.city,
                "phase": widget.phase ?? houseModel.phase,
                "block": widget.block ?? houseModel.block,
                "subblock": widget.subBlock ?? houseModel.subBlock,
                "adress": adress.text ?? houseModel.address,
                "type": widget.propertyType ?? houseModel.propertyType,
                "subType": widget.propertySubType ?? houseModel.propertySubType,
                // "washroom": widget.washrooms,
                // "kitchens": widget.kitchens,
                // "basements": widget.basements,
                // "floors": widget.floors,
                // "parkings": widget.parkings,
                // "rooms": widget.rooms,
                "sale": widget.purpose ?? houseModel.purpose,
                "sold": "no", // static value used for time being
                "area": houseModel.area ?? widget.area,
                "areaUnit": widget.areaUnit ?? houseModel.areaUnit,
                "demand": houseModel.demand ?? widget.demand,
                "description": widget.description ?? houseModel.description,
                "marker_x": null, //widget.marker_x ?? houseModel.marker_x,
                "marker_y": null, //widget.marker_y ?? houseModel.marker_y,
                "seller": "${auth.currentUser?.uid}",
                "name": auth.currentUser?.displayName,
                "time": DateTime.now(),
                "schemeImageURL": schemeImageURL,
                "isShowPlotInfoToUser": widget.showPlotToUser,
                "plotInfo":
                    houseModel.plotNumber, //widget.plotNumber.toString(),
              }).then((value) async {
                print('Collection Ref ID: ${value.id}');
                plotCollectionID = value.id;
                // call images store functionalities here
                // ========================================
                saveImageToStorageAndFirestore(
                    uploadImages: true, documentId: value.id.toString());
                //---
                CollectionReference updates =
                    FirebaseFirestore.instance.collection('updates');

                // adding data into plot_info collection
                await plotCollection.add({
                  "user": "${auth.currentUser?.displayName}",
                  "plotInfo": widget.plotNumber.toString(),
                  "createdAt": Timestamp.now(),
                  "listingCollectionID": value.id,
                });
                await updates.add({
                  "user": "${auth.currentUser?.displayName}",
                  "action": "created",
                  "createdAt": Timestamp.now(),
                  "id": value.id
                });
                //--
                await Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return SafeArea(
                    child: Scaffold(
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Your Listing was Succesfully Posted",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: StylishCustomButton.icon(
                              icon: Icons.check_circle,
                              text: "DONE",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          // RaisedButton(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(18.0),
                          //       side: BorderSide(color: Colors.white)),
                          //   color: Colors.blueAccent,
                          //   elevation: 10,
                          //   padding: EdgeInsets.all(15),
                          //   onPressed: () {
                          //     // new code
                          //
                          //     // old code
                          //     // for (var i = 0; i <= 12; i++) {
                          //     //   Navigator.pop(context);
                          //     // }
                          //   },
                          //   child: Text(
                          //     "DONE",
                          //     style: TextStyle(
                          //         color: Colors.white,
                          //         fontFamily: "Times New Roman",
                          //         fontWeight: FontWeight.w700,
                          //         fontSize: 20),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                }));
              });
              //.then((DocumentReference value) async {
              //   print('inside the raised button');
              //   print('collection ref id: ${value.id}');
              //   CollectionReference updates =
              //       FirebaseFirestore.instance.collection('updates');
              //   await updates.add({
              //     "user": "${auth.currentUser.displayName}",
              //     "action": "created",
              //     "createdAt": Timestamp.now(),
              //     "id": value.id
              //   });
              // });
            },
            // child: Icon(
            //   Icons.navigate_next,
            //   color: Colors.white,
            // ),
          )
        ],
      ),
    );
  }

  Future<void> saveImageToStorageAndFirestore(
      {@required bool? uploadImages, @required String? documentId}) async {
    print(
        "saveImageToStorageAndFirestore: uploadImages: $uploadImages, documentId: $documentId");
    // store plot specific images to specific plot_images collection and based on address of document listing
    // get
    /*only store image address in list*/
    if (uploadImages == false) {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // setState(() {
        //   _isImageSaving = true; // show loading the image
        // });

        // soring images in list and then finaly push all images to the firebase storage
        _allUserSelectedImages.add(File(pickedFile.path));
        //_image = File(pickedFile.path);

        print('images path List: $_allUserSelectedImages');
      } else {
        print('No image selected.');
      }
    }
    // uploading of images will happen in the end
    if (uploadImages!) {
      FirebaseStorage _storage = FirebaseStorage.instance;
      for (var _imageFile in _allUserSelectedImages) {

        //me **************************************
        // if (_imageFile != null) {
        //   StorageReference firebaseStorageRef = FirebaseStorage.instance
        //       .ref()
        //       .child('uploads/plot_images/${_imageFile.path}');
        //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        //   taskSnapshot.ref.getDownloadURL().then((imageURL) async {
        //     _allFirebaseStorageImagesLink[
        //             'imageID_${DateTime.now().millisecondsSinceEpoch}'] =
        //         imageURL.toString();
        //     print('Map storing images url: $_allFirebaseStorageImagesLink');
        //   });
        //   print('All Images Map: $_allFirebaseStorageImagesLink');
        //   // store all images address from storage into firestore
        //   // get the firestore data
        //   DocumentSnapshot plotCollectionData = await FirebaseFirestore.instance
        //       .collection("plots_images")
        //       .doc(documentId)
        //       .get();
        //   // under dev
        //
        //   if (plotCollectionData.exists) {
        //     Map<String, dynamic> temp = plotCollectionData.data();
        //     // // adding new map entry
        //     // temp['imageID_${DateTime.now().millisecondsSinceEpoch}'] = imageURL;
        //     // // give the url of image being save to firebase storage to the sendImage function
        //
        //     temp.addAll(_allFirebaseStorageImagesLink);
        //
        //     await FirebaseFirestore.instance
        //         .collection("plots_images")
        //         .doc(documentId)
        //         .set(temp);
        //   } else {
        //     // doc is empty means no data existed
        //     await FirebaseFirestore.instance
        //         .collection("plots_images")
        //         .doc(documentId)
        //         .set(_allFirebaseStorageImagesLink);
        //   }
        // }
      }
      // setState(() {
      //   _isImageSaving = false;
      // });
    }
  }
}
