import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:reale/chat.dart';

// import 'package:location/location.dart';
import 'package:reale/model/userFormModel.dart';
import 'package:reale/policy.dart';
import 'package:reale/widgets/stylishCustomButton.dart';

import 'mainPage.dart';

class UserFormAfterOTP extends StatefulWidget {
  static const String routeID = '/UserForm';
  bool isFromLoginRoute;

  UserFormAfterOTP({Key? key, required this.isFromLoginRoute})
      : super(key: key);

  @override
  _UserFormAfterOTPState createState() => _UserFormAfterOTPState();
}

class _UserFormAfterOTPState extends State<UserFormAfterOTP> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserForm? _userModel;
  File? _profileImage;
  File? _idCardFrontImage;
  File? _idCardBackImage;
  File? _registerationDocFrontImage;
  File? _registerationDocBackImage;
  bool pageLoading = false;
  bool profileImageExist = true;
  bool enableOfficeAddress = false;
  bool isCameraSelected = false;
  bool isTextFieldSelected = false;

  bool isFrontImageSelected = false;
  bool isBackImageSelected = false;
  bool isDocumentFrontImageSelected = false;
  bool isDocumentBackImageSelected = false;

  bool showCircleAvatarPic = true;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance.ref();

  bool _isSubmitting = false;

  // bool viewFromProfileSide = false;

  final TextStyle _lableStyle = TextStyle(fontSize: 12);
  bool isLoading = false;
  bool loadProfileImage = false;

  //profile image picker
  Future pickImageFromGallery() async {
    final pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      _profileImage = File(pickedImage!.path);
      loadProfileImage = true;
      showCircleAvatarPic = false;
      profileImageExist = false;
      isCameraSelected = true;
    });
  }
  Future pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker.platform.getImage(source: ImageSource.camera);

    if (pickedImage == null) return;

    setState(() {
      _profileImage = File(pickedImage.path);
      loadProfileImage = true;
      showCircleAvatarPic = false;
      profileImageExist = false;
    });
  }

  // id card front image picker
  Future pickIdCardFrontImageFromGallery() async {
    final pickedImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      _idCardFrontImage = File(pickedImage!.path);
      isFrontImageSelected = true;
    });
  }
  Future pickIdCardFrontImageFromCamera() async{
    final pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (pickedImage == null) return;
    setState(() {
      _idCardFrontImage = File(pickedImage!.path);
      isFrontImageSelected = true;
    });
  }

  // id card back imag picker
  Future pickIdCardBackImageFromGallery() async {
    final pickedImage =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      _idCardBackImage = File(pickedImage!.path);
      isBackImageSelected = true;
    });
  }
  Future pickIdCardBackImageFromCamera() async{
    final pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (pickedImage == null) return;
    setState(() {
      _idCardBackImage = File(pickedImage!.path);
      isBackImageSelected = true;
    });
  }

  // registeration doc front image picker
  Future pickRegisterationDocFrontImageFromGallery() async {
    final pickedImage =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      _registerationDocFrontImage = File(pickedImage!.path);
      isDocumentFrontImageSelected = true;
    });
  }
  Future pickRegisterationDocFrontImageFromCamera() async {
    final pickedImage =
    await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (pickedImage == null) return;
    setState(() {
      _registerationDocFrontImage = File(pickedImage!.path);
      isDocumentFrontImageSelected = true;
    });
  }

  // registeration doc back image picker
  Future pickRegisterationDocBackImageFromGallery() async {
    final pickedImage =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      _registerationDocBackImage = File(pickedImage!.path);
      isDocumentBackImageSelected = true;
    });
  }
  Future pickRegisterationDocBackImageFromCamera() async {
    final pickedImage =
    await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (pickedImage == null) return;
    setState(() {
      _registerationDocBackImage = File(pickedImage!.path);
      isDocumentBackImageSelected = true;
    });
  }

  String updatedName = "";
  String updatedPhone = "";
  String updatedProfileImage = "";
  String updatedBusinessName = "";
  String updatedBusinessOwnerName = "";
  String updatedCity = "";
  String updatedOfficeAddress = "";
  String updatedIdCardNumber = "";
  String updatedRegisterationNumber = "";


  Future getUserProfileData()async
  {
    final result = await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get();
    setState(() {
      updatedProfileImage = result['profile'];
      updatedName = result['name'];
      updatedPhone = result['phone'];
      updatedBusinessName = result['businessName'];
      updatedBusinessOwnerName = result['businessOwner'];
      updatedCity = result['city'];
      updatedOfficeAddress = result['officeAddress'];
      updatedIdCardNumber = result['idCard'];
      updatedRegisterationNumber = result['registrationNumber'];
    });
    print(updatedName);
  }

  void showToastMessages(String msg)
  {
    Fluttertoast.showToast(
        msg: msg.toString(),
      fontSize: 18.0,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.white,
      backgroundColor: Colors.black,
    );
  }

  Future updateDataToFirestore()async
  {
    FocusScope.of(context).unfocus();
    setState((){
      pageLoading = true;
    });

    if(isCameraSelected & isTextFieldSelected)
      {
        final profileRef = await storage.child("user_profile_image").child("${updatedName.toString()}").child(updatedName.toString() + " profile pic");
        await profileRef.putFile(_profileImage!.absolute);
        String imgUrl =await profileRef.getDownloadURL();

        db.collection('users').doc(auth.currentUser!.uid).update({
          'officeAddress' :officeAddressController.text.toString(),
          'profile' : imgUrl.toString(),
        }).then((value){
          setState(() {
            pageLoading = false;
            enableOfficeAddress = false;
            getUserProfileData();
          });
          showToastMessages('Updated');
        }).onError((error, stackTrace){
          setState(() {
            pageLoading = false;
            enableOfficeAddress = false;
          });
          showToastMessages(error.toString());
        });
        officeAddressController.clear();
        setState(() {
          pageLoading = false;
          enableOfficeAddress = false;
        });
      }
    else if(isCameraSelected)
      {
        FocusScope.of(context).unfocus();

        setState((){
          pageLoading = true;
        });

        final profileRef = await storage.child("user_profile_image").child("${updatedName.toString()}").child(updatedName.toString() + " profile pic");
        await profileRef.putFile(_profileImage!.absolute);
        String imgUrl =await profileRef.getDownloadURL();

        db.collection('users').doc(auth.currentUser!.uid).update({
          'profile' : imgUrl.toString(),
        }).then((value){
          setState(() {
            pageLoading = false;
            getUserProfileData();
          });
          showToastMessages('Updated');
        }).onError((error, stackTrace){
          setState(() {
            pageLoading = false;
          });
          showToastMessages(error.toString());
        });
        officeAddressController.clear();
        setState(() {
          pageLoading = false;
        });
      }
    else if(isTextFieldSelected)
      {
        db.collection('users').doc(auth.currentUser!.uid).update({
          'officeAddress' :officeAddressController.text.toString(),
        }).then((value){
          setState(() {
            pageLoading = false;
            enableOfficeAddress = false;
            getUserProfileData();
          });
          showToastMessages('Updated');
        }).onError((error, stackTrace){
          setState(() {
            pageLoading = false;
            enableOfficeAddress = false;
          });
          showToastMessages(error.toString());
        });
        officeAddressController.clear();
        setState(() {
          pageLoading = false;
          enableOfficeAddress = false;
        });
      }
    else
      {
        setState(() {
          pageLoading = false;
          enableOfficeAddress = false;
          isCameraSelected = false;
          isTextFieldSelected = false;
        });
        showToastMessages("Nothing updated");
      }
  }

  Future saveData() async {
    FocusScope.of(context).unfocus();
    setState(() {
      pageLoading = true;
    });

    final profileRef = await storage.child("user_profile_image").child("${nameController.text}").child(nameController.text + " profile pic");
    final cardFrontImg = await storage.child("user_profile_image").child("${nameController.text}").child(nameController.text + " id card front img");
    final cardBackImg = await storage.child("user_profile_image").child("${nameController.text}").child(nameController.text + " id card back img");
    final regDocFrontImg = await storage.child("user_profile_image").child("${nameController.text}").child(nameController.text + " reg front img");
    final regDocBackImg = await storage.child("user_profile_image").child("${nameController.text}").child(nameController.text + " reg back img");

    // Downloading links
    await profileRef.putFile(_profileImage!.absolute);
    await cardFrontImg.putFile(_idCardFrontImage!.absolute);
    await cardBackImg.putFile(_idCardBackImage!.absolute);
    await regDocFrontImg.putFile(_registerationDocFrontImage!.absolute);
    await regDocBackImg.putFile(_registerationDocBackImage!.absolute);

    // Urls
    String imgUrl = await profileRef.getDownloadURL();
    String idCardFrontImgUrl = await cardFrontImg.getDownloadURL();
    String idCardbackImgUrl = await cardBackImg.getDownloadURL();
    String regDocFrontImgUrl = await regDocFrontImg.getDownloadURL();
    String regDocBackImgUrl = await regDocBackImg.getDownloadURL();

    await db.collection("users").doc(auth.currentUser!.uid).set({
      'name': nameController.text,
      'approved': true,
      'businessName': businessNameController.text.toString(),
      'businessOwner': businessOwnerController.text.toString(),
      'email': "",
      'city' : cityController.text.toString() ,
      'id': auth.currentUser!.uid.toString(),
      'idCard': idCardNumberController.text.toString(),
      'idCardBackPic': idCardbackImgUrl.toString(),
      'idCardFrontPic': idCardFrontImgUrl.toString(),
      'phone': phoneController.text.toString(),
      'profile': imgUrl.toString(),
      'registrationDocumentBackPic': regDocBackImgUrl.toString(),
      'registrationDocumentFrontPic': regDocFrontImgUrl.toString(),
      'registrationNumber': registerationNumberController.text.toString(),
      'officeAddress': officeAddressController.text.toString(),
    }).then((value) {
      print('data send successfully');
      setState(() {
        pageLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => mainPage()));
    }).onError((error, stackTrace) {
      print('Error occured while sending data');
      setState(() {
        pageLoading = false;
      });
    });

    setState(() {
      pageLoading = false;
    });
  }

  void dialogue(context, int opt) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            height: 120.0,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    if(opt == 1)
                      {
                        pickImageFromCamera();
                        Navigator.pop(context);
                      }
                    else if(opt == 2)
                      {
                        pickIdCardFrontImageFromCamera();
                        Navigator.pop(context);
                      }
                    else if(opt == 3)
                      {
                        pickIdCardBackImageFromCamera();
                        Navigator.pop(context);
                      }
                    else if(opt == 4)
                      {
                        pickRegisterationDocFrontImageFromCamera();
                        Navigator.pop(context);
                      }
                    else
                      {
                        pickRegisterationDocBackImageFromCamera();
                        Navigator.pop(context);
                      }
                  },
                  leading:const Icon(Icons.camera_alt_rounded),
                  title:const Text("Camera"),
                ),
                ListTile(
                  onTap: (){
                    if(opt == 1)
                      {
                        pickImageFromGallery();
                        Navigator.pop(context);
                      }
                    else if(opt == 2)
                      {
                        pickIdCardFrontImageFromGallery();
                        Navigator.pop(context);
                      }
                    else if(opt == 3)
                      {
                        pickIdCardBackImageFromGallery();
                        Navigator.pop(context);
                      }
                    else if(opt == 4)
                      {
                        pickRegisterationDocFrontImageFromGallery();
                        Navigator.pop(context);
                      }
                    else
                      {
                        pickRegisterationDocBackImageFromGallery();
                        Navigator.pop(context);
                      }
                  },
                  leading:const Icon(Icons.photo_library),
                  title:const Text("Gallery"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // text editing controller
  // TextEditingController? nameTextEditingController;
  // TextEditingController? phoneNumberTextEditingController;
  // TextEditingController? businessNameTextEditingController;
  // TextEditingController? businessOwnerTextEditingController;
  // TextEditingController? officeAddressTextEditingController;
  // TextEditingController? idCardNumberTextEditingController;
  // TextEditingController? registrationNumberTextEditingController;
  // TextEditingController? provinceTextEditingController;
  // TextEditingController? cityTextEditingController;
  // TextEditingController? locationTextEditingController;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessOwnerController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController idCardNumberController = TextEditingController();
  TextEditingController registerationNumberController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController locationController = TextEditingController();



  // variables for update operation (if user is comes from profile page)
  // String updatedCardFrontImage;
  // String updatedCardBackImage;
  // String updatedDocumentFrontImage;
  // String updatedDocumentBackImage;

  DocumentSnapshot? _userDocumentForUpdateOperation;
  bool isServiceEnable = false;

  // me ***********************************
  // PermissionStatus permissionGranted;
  // LocationData _userLocationData;
  // Location userLocation = Location();
  // bool isLocationExist = false; // be default
  // Future<void> getLocation() async {
  //   print('get location method invoked');
  //   DocumentSnapshot _tempUserDoc = await Firestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .get();
  //
  //   isLocationExist =
  //       _tempUserDoc?.data()['lat'] != 0 && _tempUserDoc?.data()['long'] != 0
  //           ? true
  //           : false;
  //   print('Is User data exist: $isLocationExist');
  //   if (!isLocationExist) {
  //     // checking for the service
  //     print('inside the if:  get location method invoked');
  //     isServiceEnable = await userLocation.serviceEnabled();
  //     if (!isServiceEnable) {
  //       print('inside the first service if block');
  //       isServiceEnable = await userLocation.requestService();
  //       if (!isServiceEnable) {
  //         return;
  //       }
  //     }
  //
  //     // checking for the location permission
  //     if (permissionGranted == PermissionStatus.denied) {
  //       print('inside the first permissions if block');
  //       permissionGranted = await Location.instance.requestPermission();
  //       if (permissionGranted != PermissionStatus.granted) {
  //         return;
  //       }
  //     }
  //     print('below all if block');
  //     _userLocationData = await userLocation.getLocation();
  //     locationTextEditingController.text =
  //         "Lat: ${_userLocationData.latitude}, Long: ${_userLocationData.longitude}";
  //     print('User location controller: ${locationTextEditingController.text}');
  //     print('inside the location method: user location: $_userLocationData');
  //     // storing location infor to firestore
  //     DocumentSnapshot user = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .get();
  //
  //     var _userData = user.data();
  //     _userData.addAll({
  //       "lat": _userLocationData.latitude,
  //       "long": _userLocationData.longitude,
  //     });
  //     print(
  //         '********Current location: ${_userLocationData.latitude}: ${_userLocationData.longitude}.......................');
  //     // get data from firestore and add more data and then store it back into firestore
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .update(_userData);
  //   } else {
  //     return null;
  //   }
  // }

  @override
  void initState() {
    //locationTextEditingController = TextEditingController();
   // _userModel = UserForm.defaultValue(); // with no values as its login path
    getUserProfileData();
    super.initState();
    //provinceTextEditingController = TextEditingController();
    //cityTextEditingController = TextEditingController();

    // locationTextEditingController =
    //     TextEditingController(text: 'Loading Location Information');

    print('init state...user information from after OTP');

    if (FirebaseAuth.instance.currentUser != null) {
      // phoneNumberTextEditingController = TextEditingController(
      //     text: FirebaseAuth.instance.currentUser!.phoneNumber.toString());
      phoneController = TextEditingController(
          text: FirebaseAuth.instance.currentUser!.phoneNumber.toString());
      // phoneNumberTextEditingController.text =
      //     FirebaseAuth.instance.currentUser.phoneNumber.toString();
      // flow from login page
      if (widget.isFromLoginRoute) {
        // me ********************************************
        // getLocation().whenComplete(() async {
        //   print('getLocation executed...................................');
        //   // if (isLocationExist == false) {
        //   //   print('User current location: $_userLocationData');
        //   //   // set the location in firestore
        //   //   DocumentSnapshot user = await FirebaseFirestore.instance
        //   //       .collection("users")
        //   //       .doc(FirebaseAuth.instance.currentUser.uid)
        //   //       .get();
        //   //
        //   //   var _userData = user.data();
        //   //   _userData.addAll({
        //   //     "lat": _userLocationData.latitude,
        //   //     "long": _userLocationData.longitude,
        //   //   });
        //   //   // get data from firestore and add more data and then store it back into firestore
        //   //   await FirebaseFirestore.instance
        //   //       .collection("users")
        //   //       .doc(FirebaseAuth.instance.currentUser.uid)
        //   //       .update(_userData);
        //   //   print('User current location saved to firestore');
        //   // }
        // });
        _userModel =
            UserForm.defaultValue(); // with no values as its login path

        print('path from login page');
        // flow from login side
        isLoading = true;
        isUserDataExist().then((value) {
          print('Data found: $value');
          setState(() {
            isLoading = false;
          });
          if (value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              // me**********************************
              // return mainPage();
              return policy(); // replace with above when set
            }));
          }
        });
      }
    } else {
      // phoneNumberTextEditingController =
      //     TextEditingController(text: 'number loading....');
      phoneController = TextEditingController(text: 'number loading....');
    }

    isUserDataExist().then((bool isUserExist) {
      if (isUserExist) {
        _getProfileImage().then((value) => print('get user profile image'));
        // flow from login page
        if (widget.isFromLoginRoute) {
          // me *************************************************
          // getLocation().whenComplete(() async {
          //   print('User current location: $_userLocationData');
          //   // locationTextEditingController.text =
          //   //     "Lat: ${_userLocationData.latitude}, Long: ${_userLocationData.longitude}";
          //   //setState(() {});
          //   // set the location in firestore
          //   DocumentSnapshot user = await FirebaseFirestore.instance
          //       .collection("users")
          //       .doc(FirebaseAuth.instance.currentUser.uid)
          //       .get();
          //
          //   var _userData = user.data();
          //   _userData.addAll({
          //     "lat": _userLocationData.latitude,
          //     "long": _userLocationData.longitude,
          //   });
          //   // get data from firestore and add more data and then store it back into firestore
          //   await FirebaseFirestore.instance
          //       .collection("users")
          //       .doc(FirebaseAuth.instance.currentUser.uid)
          //       .set(_userData);
          //   print('User current location saved to firestore');
          // });
          // _userModel =
          //     UserForm.defaultValue(); // with no values as its login path

          print('path from login page');
          // flow from login side
          isLoading = true;
          isUserDataExist().then((value) {
            print('Data found: $value');
            setState(() {
              isLoading = false;
            });
            if (value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                // return mainPage();
                //me***************
                //replace with above
                return policy();
              }));
            }
          });
        }
        // flow from profile page
        else {
          print('path from profile page');
          // flow from profile side
          setState(() {
            isLoading = true;
          });
          // get the data from user profile and till loading show the circular progress
          getUserData().then((value) {
            setState(() {
              isLoading = false;
            });
          });

          // TODO: assign the field value to the user model in case if user does not updates something

          // TODO: push the updated values to the firebase firestore
        }
      }
    });
    // print('User location controller: ${locationTextEditingController.text}');
  }

  @override
  void dispose() {
    if (widget.isFromLoginRoute == false) {
      // if user come from profile route then perform following actions
      // nameTextEditingController?.dispose();
      // phoneNumberTextEditingController?.dispose();
      // businessNameTextEditingController?.dispose();
      // businessOwnerTextEditingController?.dispose();
      // officeAddressTextEditingController?.dispose();
      // idCardNumberTextEditingController?.dispose();
      // registrationNumberTextEditingController?.dispose();
      // locationTextEditingController?.dispose();
    }
    super.dispose();
  }

  bool _isProfileImageUploading = false;
  String profileImagePath = '';

  Future<void> _getProfileImage() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      _isProfileImageUploading = true;
    });
    // get the user document data
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();
    if (user != null) {
      print('user exist on firebase');
      var userData = user;
      setState(() {
        print('user profile image url: ${userData["profile"]}');

        profileImagePath = userData["profile"];
        _isProfileImageUploading = false;
      });
    } else {
      setState(() {
        _isProfileImageUploading = false;
      });
    }
  }

  List<String> _provinceNames = const [
    'Khyber Pakhtunkhwa',
    'Punjab',
    'Sindh',
    'Balochistan',
  ];

  String province = 'Khyber Pakhtunkhwa';
  String city = '';


  @override
  Widget build(BuildContext context) {
    print(
        'current phone number: ${FirebaseAuth.instance.currentUser!.phoneNumber}');
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return widget.isFromLoginRoute
              ? Future.value(false)
              : Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            title: Text(
              widget.isFromLoginRoute
                  ? 'Enter User Information'
                  : 'Update User Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: _isSubmitting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //avatar for circle
                          GestureDetector(
                            onTap: (){
                              dialogue(context, 1);
                            },
                            child: Center(
                              child: ClipOval(
                                child: Container(
                                  color: Colors.lightBlue[300],
                                  width: 160,
                                  height: 160,
                                  child:profileImageExist ? CircleAvatar(
                                    backgroundImage:updatedProfileImage == "" ? NetworkImage("No Image") : NetworkImage(updatedProfileImage),
                                  ) : CircleAvatar(backgroundImage: FileImage(_profileImage!.absolute),),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          // name
                          !widget.isFromLoginRoute ? Text("Name : " + updatedName) : TextFormField(
                            //enabled: widget.isFromLoginRoute ? true : false,
                            //readOnly: widget.isFromLoginRoute ? true : false,
                            controller: nameController,
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.name,
                            validator: (val){
                              if(val!.isEmpty)
                                {
                                  return "* required";
                                }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              //border: InputBorder.none,
                              hintText: 'Name *',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'Name *',
                              labelStyle: _lableStyle,
                            ),
                            // onChanged: (String name) {
                            //   _userModel!.name = name.trim();
                            // },
                          ),

                          SizedBox(height: 20),
                          // phone number
                          !widget.isFromLoginRoute ? Text("Phone Number : " +updatedPhone) : TextFormField(
                            //enabled: widget.isFromLoginRoute ? true : false,
                            //readOnly: true,
                            controller: phoneController,
                            validator: (val){
                              if(val!.isEmpty)
                                {
                                  return '* required';
                                }
                            },
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              //border: InputBorder.none,
                              hintText: 'Phone Number *',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'Phone Number',
                              labelStyle: _lableStyle,
                            ),
                            onChanged: (String phoneNumber) {
                              _userModel!.phone = phoneNumber.trim();
                            },
                          ),

                          SizedBox(height: 20),

                          // business name
                          !widget.isFromLoginRoute ? Text("Business Name : " +updatedBusinessName) :TextFormField(
                            //enabled: widget.isFromLoginRoute ? true : false,
                            controller: businessNameController,
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.name,
                            validator: (val){
                              if(val!.isEmpty)
                                {
                                  return '* required';
                                }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              //border: InputBorder.none,
                              hintText: 'Business Name *',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'Business Name',
                              labelStyle: _lableStyle,
                            ),
                            onChanged: (String businessName) {
                              _userModel!.businessName = businessName.trim();
                            },
                          ),

                          SizedBox(height: 20),

                          // business owner
                          !widget.isFromLoginRoute ? Text("Business Owner : " +updatedBusinessOwnerName) : TextFormField(
                            //enabled: widget.isFromLoginRoute ? true : false,
                            controller: businessOwnerController,
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.name,
                            validator: (val){
                              if(val!.isEmpty)
                              {
                                return '* required';
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              //border: InputBorder.none,
                              hintText: 'Business Owner *',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'Business Owner',
                              labelStyle: _lableStyle,
                            ),
                            onChanged: (String businessOwner) {
                              _userModel!.businessOwner = businessOwner;
                            },
                          ),
                          /*-----*/
                          // province
                          //me ********************************************
                          // Container(
                          //   width: double.infinity,
                          //   child: DropdownButton<String>(
                          //     value: province,
                          //     items: _provinceNames
                          //         .map(
                          //           (String provinceName) =>
                          //               DropdownMenuItem<String>(
                          //             child: Text('$provinceName'),
                          //             value: provinceName,
                          //           ),
                          //         )
                          //         .toList(),
                          //     // me *********************************
                          //     // onChanged: widget.isFromLoginRoute
                          //     //     ? (String selectedProvince) {
                          //     //         print(
                          //     //             'Selected Province: $selectedProvince');
                          //     //         setState(() {
                          //     //           province = selectedProvince;
                          //     //           print('selected province: $province');
                          //     //         });
                          //     //       }
                          //     //     : null,
                          //   ),
                          // ),

                          SizedBox(height: 20),

                          // city
                          !widget.isFromLoginRoute ? Text("City : " +updatedCity) : TextFormField(
                            //enabled: widget.isFromLoginRoute ? true : false,
                            controller: cityController,
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.name,
                            validator: (val){
                              if(val!.isEmpty)
                              {
                                return '* required';
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              //border: InputBorder.none,
                              hintText: 'city',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'city',
                              labelStyle: _lableStyle,
                            ),
                            onChanged: (String city) {
                              this.city = city;
                              print('selected city: ${this.city}');
                            },
                          ),



                          // location
                          // TextFormField(
                          //   enabled: widget.isFromLoginRoute ? true : false,
                          //   controller: locationController,
                          //   style: TextStyle(fontSize: 16),
                          //   keyboardType: TextInputType.name,
                          //   decoration: InputDecoration(
                          //     isDense: true,
                          //     contentPadding: EdgeInsets.symmetric(
                          //         horizontal: 15, vertical: 8),
                          //     border: OutlineInputBorder(
                          //       borderSide:
                          //           BorderSide(color: Colors.black, width: 2),
                          //     ),
                          //     //border: InputBorder.none,
                          //     // hintText: 'city',
                          //     // hintStyle: TextStyle(fontSize: 16),
                          //     labelText: 'Location Added',
                          //     labelStyle: _lableStyle,
                          //   ),
                          //   // onChanged: (String city) {
                          //   //   this.city = city;
                          //   //   print('selected city: ${this.city}');
                          //   // },
                          // ),
                          /*----*/

                          // if (widget.isFromLoginRoute == true)
                          //   SizedBox(height: 20),
                          // if (widget.isFromLoginRoute == true)
                          //   // location
                          //   TextFormField(
                          //     enabled: false,
                          //     readOnly: true,
                          //     controller: locationTextEditingController,
                          //     style: TextStyle(fontSize: 16),
                          //     keyboardType: TextInputType.name,
                          //     decoration: InputDecoration(
                          //       isDense: true,
                          //       contentPadding: EdgeInsets.symmetric(
                          //           horizontal: 15, vertical: 8),
                          //       border: OutlineInputBorder(
                          //         borderSide:
                          //             BorderSide(color: Colors.black, width: 2),
                          //       ),
                          //       //border: InputBorder.none,
                          //       // hintText: 'Business Owner *',
                          //       // hintStyle: TextStyle(fontSize: 16),
                          //       labelText: 'Location',
                          //       labelStyle: _lableStyle,
                          //     ),
                          //     onChanged: (String businessOwner) {
                          //       _userModel.businessOwner = businessOwner;
                          //     },
                          //   ),

                          //office address
                          !widget.isFromLoginRoute & !enableOfficeAddress ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Office Address : " +updatedOfficeAddress),
                              IconButton(onPressed: (){
                                setState(() {
                                  enableOfficeAddress = !enableOfficeAddress;
                                  isTextFieldSelected = true;
                                });
                              }, icon:const Icon(Icons.edit))
                            ],) : Padding(
                            padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                              controller: officeAddressController,
                              style: TextStyle(fontSize: 16),
                              keyboardType: TextInputType.name,
                              validator: (val){
                                if(val!.isEmpty)
                                {
                                  return '* required';
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                                //border: InputBorder.none,
                                hintText: 'Office Address *',
                                hintStyle: TextStyle(fontSize: 16),
                                labelText: 'Office Address',
                                labelStyle: _lableStyle,
                              ),
                              onChanged: (String officeAddress) {
                                _userModel!.officeAddress = officeAddress;
                              },
                          ),
                            ),


                          // id card number
                          !widget.isFromLoginRoute ? Text("ID Card : " +updatedIdCardNumber) : TextFormField(
                            //enabled: widget.isFromLoginRoute ? true : false,
                            controller: idCardNumberController,
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.name,
                            validator: (val){
                              if(val!.isEmpty)
                              {
                                return '* required';
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              //border: InputBorder.none,
                              hintText: 'ID Card Number *',
                              hintStyle: const TextStyle(fontSize: 16),
                              labelText: 'ID Card Number',
                              labelStyle: _lableStyle,
                            ),
                            onChanged: (String idCardNumber) {
                              _userModel?.idCardNumber = idCardNumber;
                            },
                          ),

                          if (widget.isFromLoginRoute == true)
                            SizedBox(height: 20),
                          if (widget.isFromLoginRoute == true)
                            const Text(
                              'Choose ID card front image ',
                              style: TextStyle(fontSize: 18),
                            ),
                          if (widget.isFromLoginRoute == true)
                            SizedBox(height: 15),
                          if (widget.isFromLoginRoute == true)
                            // for cardFrontImage
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              height: 80,
                              child: Row(
                                children: [
                                  StylishCustomButton(
                                    icon: Icons.add,
                                    onPressed: () async {
                                      dialogue(context, 2);
                                      // functionality to choose image

                                      // _userModel!.cardFrontImage =
                                      //     await getImage(
                                      //   whenImageSelect: () {
                                      //     setState(() {
                                      //       isFrontImageSelected = true;
                                      //     });
                                      //     print(
                                      //         'is image selected: $isFrontImageSelected}');
                                      //   },
                                      // );

                                      // updatedCardFrontImage =
                                      //     _userModel.cardFrontImage;
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Text(
                                        isFrontImageSelected
                                            ? 'Image has Selected'
                                            : 'Nothing is Selected',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  //SizedBox(width: 10),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value: isFrontImageSelected,
                                    onChanged: (value) {},
                                  ),
                                  //SizedBox(width: 10),
                                ],
                              ),
                            ),
                          // ------------------------
                          if (widget.isFromLoginRoute == true)
                            SizedBox(height: 20),
                          if (widget.isFromLoginRoute == true)
                            Text(
                              'Choose ID card back image ',
                              style: TextStyle(fontSize: 18),
                            ),
                          if (widget.isFromLoginRoute == true)
                            SizedBox(height: 15),
                          if (widget.isFromLoginRoute == true)
                            // cardBackImage
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              height: 80,
                              child: Row(
                                children: [
                                  StylishCustomButton(
                                    icon: Icons.add,
                                    onPressed: () async {
                                      dialogue(context, 3);
                                      // functionality to choose image
                                      // _userModel!.cardBackImage =
                                      //     await getImage(
                                      //   whenImageSelect: () {
                                      //     setState(() {
                                      //       isBackImageSelected = true;
                                      //     });
                                      //   },
                                      // );

                                      // updatedCardBackImage =
                                      //     _userModel.cardBackImage;
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Text(
                                        isBackImageSelected
                                            ? 'Image has Selected'
                                            : 'Nothing is Selected',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value: isBackImageSelected,
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ),

                          SizedBox(height: 15),

                          // textfield for registration number
                          !widget.isFromLoginRoute ? Text("Registeration Number : " +updatedRegisterationNumber) : TextFormField(
                            //enabled: widget.isFromLoginRoute ? true : false,
                            //enabled: false,
                            controller: registerationNumberController,
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.name,
                            validator: (val){
                              if(val!.isEmpty)
                              {
                                return '* required';
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              //border: InputBorder.none,
                              hintText:
                                  'Registration Number(Excise and Taxation number)',
                              hintStyle: TextStyle(fontSize: 16),
                              labelText: 'Registration Number',
                              labelStyle: _lableStyle,
                            ),
                            onChanged: (String registrationNumber) {
                              _userModel!.registrationNumber =
                                  registrationNumber;
                            },
                          ),

                          if (widget.isFromLoginRoute == true)
                            // register document
                            SizedBox(height: 30),
                          if (widget.isFromLoginRoute == true)
                            Text(
                              'Choose an Registration document front image ',
                              style: TextStyle(fontSize: 18),
                            ),
                          if (widget.isFromLoginRoute == true)
                            SizedBox(height: 15),
                          if (widget.isFromLoginRoute == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              height: 80,
                              child: Row(
                                children: [
                                  // documentFrontImage
                                  StylishCustomButton(
                                    icon: Icons.add,
                                    onPressed: () async {
                                      dialogue(context, 4);
                                      // functionality to choose image
                                      // _userModel!.documentFrontImage =
                                      //     await getImage(
                                      //   whenImageSelect: () {
                                      //     setState(() {
                                      //       isDocumentFrontImageSelected = true;
                                      //     });
                                      //   },
                                      // );

                                      // updatedDocumentFrontImage =
                                      //     _userModel.documentFrontImage;
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Text(
                                        isDocumentFrontImageSelected
                                            ? 'Image has Selected'
                                            : 'Nothing is Selected',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value: isDocumentFrontImageSelected,
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ),
                          // ------------------------
                          SizedBox(height: 20),

                          if (widget.isFromLoginRoute == true)
                            Text(
                              'Choose an Registration document back image ',
                              style: TextStyle(fontSize: 18),
                            ),
                          if (widget.isFromLoginRoute == true)
                            SizedBox(height: 15),
                          if (widget.isFromLoginRoute == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              height: 80,
                              child: Row(
                                children: [
                                  // documentBackImage
                                  StylishCustomButton(
                                    icon: Icons.add,
                                    onPressed: () async {
                                      dialogue(context, 5);
                                      // functionality to choose image
                                      // getImage(
                                      //   whenImageSelect: () {
                                      //     setState(() {
                                      //       isDocumentBackImageSelected = true;
                                      //     });
                                      //   },
                                      // ).then((String image_url) async {
                                      //   _userModel!.documentBackImage =
                                      //       image_url;
                                      // });
                                      // _userModel.documentBackImage = await getImage();
                                      // await saveInfoToFirestore();
                                    },
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Text(
                                        isDocumentBackImageSelected
                                            ? 'Image has Selected'
                                            : 'Nothing is Selected',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    value: isDocumentBackImageSelected,
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ),
                          // show update button if update operation
                          widget.isFromLoginRoute
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child:pageLoading ? const CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.black,
                                  ) : StylishCustomButton(
                                    text: 'submit',
                                    onPressed: () {
                                      if(_formKey.currentState!.validate())
                                        {
                                          saveData();
                                        }

                                      // _userModel!.province = province;
                                      // _userModel!.city = this.city;
                                      //
                                      // if (_userModel!.isProvidedAllFields() &&
                                      //     (isFrontImageSelected &&
                                      //         // (profileImagePath.length > 0) &&
                                      //         isBackImageSelected &&
                                      //         isDocumentFrontImageSelected &&
                                      //         isDocumentBackImageSelected)) {
                                      //   print('all fields are provided');
                                      //   setState(() {
                                      //     _isSubmitting = true;
                                      //     print(
                                      //         'isSubmitting: $_isSubmitting}');
                                      //   });
                                      //   await saveInfoToFirestore();
                                      //   print(
                                      //       'successfully entered the data into firebase firestore');
                                      // } else {
                                      //   print('all fields are not provided');
                                      //   // show pop to the user
                                      //   await showDialog<bool>(
                                      //     context: context,
                                      //     builder: (context) {
                                      //       return AlertDialog(
                                      //         title: Text('Field Missing'),
                                      //         content: Text(
                                      //             'Some fields are missing'),
                                      //         actions: [
                                      //           TextButton(
                                      //             onPressed: () {
                                      //               print('ok');
                                      //               Navigator.of(context).pop();
                                      //             },
                                      //             child: Text('ok'),
                                      //           ),
                                      //         ],
                                      //       );
                                      //     },
                                      //   );
                                      //   print(
                                      //       'UserModel all values: ${_userModel.toString()}');
                                      //   return;
                                      // }
                                    },
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: pageLoading ? CircularProgressIndicator() : StylishCustomButton(
                                    text: 'Update',
                                    icon: Icons.update_rounded,
                                    onPressed: (){
                                      if(enableOfficeAddress)
                                        {
                                          if(_formKey.currentState!.validate())
                                          {
                                            updateDataToFirestore();
                                          }
                                        }
                                      else
                                        {
                                          updateDataToFirestore();
                                        }
                                      // setState(() {
                                      //   _isSubmitting = true;
                                      //   print('isSubmitting: $_isSubmitting}');
                                      // });
                                      //await saveInfoToFirestore();

                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _sendImage(imageURL) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // get the user document data

    //me **************************************
    // DocumentSnapshot user = await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(auth.currentUser!.uid)
    //     .get();
    // var userData = user;
    // // user["profile"] = imageURL.toString();
    //
    // // updating the user profile data
    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(auth.currentUser!.uid)
    //     .set(userData);
    // also updating the profile of firebase current user
    auth.currentUser!.updateDisplayName(auth.currentUser!.displayName);
    auth.currentUser!.updatePhotoURL(
      imageURL.toString(),
    );
  }

  Future<String> getImage(
      {void Function()? whenImageSelect,
      String bucketName = "uploads",
      void Function({required String imagePath})? selectedImagePath}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      print('File path: ${pickedFile.path}');
      //selectedImagePath(imagePath: pickedFile.path.toString());
      // here image is selected

      whenImageSelect!();

      // storing image to the firebase storage
      // FirebaseStorage _storage = FirebaseStorage.instance;
      String fileName = _profileImage!.path;

      //me ****************************
      // StorageReference firebaseStorageRef =
      //     FirebaseStorage.instance.ref().child('$bucketName/$fileName');
      // StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      // String imageURL = await taskSnapshot.ref.getDownloadURL();
      // return imageURL; // its the uploaded image url
    } else {
      print('No image selected.');
    }
    return '';
  }

  Future<bool> isUserDataExist() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    //  retrieving the user  document from the firestore
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();
    if (user == null || (!user.exists)) {
      return false;
    }

    if (user['registrationNumber'].toString().length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();

    if (userDocument.exists) {
      prepareTextFieldController(userDocument);
      // save the snapshot
      _userDocumentForUpdateOperation = userDocument;
      return true;
    } else {
      return false;
    }
  }

  // data from firestore to textFields
  // for profile flow
  void prepareTextFieldController(DocumentSnapshot document) {
    Map<String, dynamic>? userDocument =
        document.data() as Map<String, dynamic>?;
    print('User Firestore data: \n$userDocument');
    // assign value to the province dropdown
    // ----------------------------------------
    province = userDocument!['province'];
    // ----------------------------------------

    // get data from document<firestore> and assign to the fields

    // initialize the controller
    // locationTextEditingController!.text =
    //     "Lat: ${userDocument['lat']}, Long: ${userDocument['long']}";
    // provinceTextEditingController =
    //     TextEditingController(text: userDocument['province']);
    // cityTextEditingController =
    //     TextEditingController(text: userDocument['city']);
    //
    // nameTextEditingController =
    //     TextEditingController(text: userDocument['name']);
    //
    // businessNameTextEditingController =
    //     TextEditingController(text: userDocument['businessName']);
    // businessOwnerTextEditingController =
    //     TextEditingController(text: userDocument['businessOwner']);
    // officeAddressTextEditingController =
    //     TextEditingController(text: userDocument['officeAddress']);
    // idCardNumberTextEditingController =
    //     TextEditingController(text: userDocument['idCardNumber']);
    // registrationNumberTextEditingController =
    //     TextEditingController(text: userDocument['registrationNumber']);

    // _userModel = UserForm.defaultValue(
    //   name: userDocument['name'],
    //   phone: userDocument['phoneNumber'],
    //   businessName: userDocument['businessName'],
    //   businessOwner: userDocument['businessOwner'],
    //   officeAddress: userDocument['officeAddress'],
    //   idCardNumber: userDocument['idCardNumber'],
    //   registrationNumber: userDocument['registrationNumber'],
    //   cardFrontImage: userDocument['idCardFrontPic'],
    //   cardBackImage: userDocument['idCardBackPic'],
    //   documentFrontImage: userDocument['registrationDocumentFrontPic'],
    //   documentBackImage: userDocument['registrationDocumentBackPic'],
    //   province: userDocument['province'],
    //   city: userDocument['city'],
    //   lat: userDocument['lat'],
    //   long: userDocument['long'],
    // ); // create with already stored values inside the firestore
    // // nameTextEditingController.text = userDocument['name'];
    // // phoneNumberTextEditingController.text = userDocument['phoneNumber'];
    // // businessNameTextEditingController.text = userDocument['businessName'];
    // // businessOwnerTextEditingController.text = userDocument['businessOwner'];
    // // officeAddressTextEditingController.text = userDocument['officeAddress'];
    // // idCardNumberTextEditingController.text = userDocument['idCardNumber'];
    // // registrationNumberTextEditingController.text =
    // //     userDocument['registrationNumber'];
    //
    // // update the user data if come from profile page
  }

  // save data in both flows <login flow and updating flow>
  // while updating, only update the office address
  // while login, update everything
  Future<void> saveInfoToFirestore() async {
    setState(() {
      _isSubmitting = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;

    // retriving the document from the firestore
    if (widget.isFromLoginRoute) {
      // if user is from login flow
      DocumentSnapshot user = await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get();
      // adding data to user model
      if (widget.isFromLoginRoute == true) {
        _userModel!.city = this.city;
        _userModel!.province = province;
        // me *************************************
        // _userModel.lat = _userLocationData.latitude.toString();
        // _userModel.long = _userLocationData.longitude.toString();
      }

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      //   // here "push" method is replace with "pushReplacement" method
      //   // me**********************************
      //   return mainPage();
      //   // return policy(); // replace with above when set
      // }));
    } else {
      // for update operation
      // passing the document to the use form model
      FirebaseFirestore.instance
          .collection("users")
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .update({'officeAddress': officeAddressController!.text.toString()});

      setState(() {
        _isSubmitting = false;
      });
    }
  }
}

// Stack(
// children: [
// if (_isProfileImageUploading == false)
// Positioned(
// bottom: 0,
// child: GestureDetector(
// onTap: widget.isFromLoginRoute
// ? () async {
// // print('camera is open');
// // String uploadedImageURL =
// //     await getImage(
// //         whenImageSelect:
// //             () {
// //           setState(() {
// //             _isProfileImageUploading =
// //                 true;
// //           });
// //         },
// //         selectedImagePath: (
// //             {required imagePath}) {},
// //         bucketName:
// //             'profile_image');
// // print(
// //     'profile uploaded image path: $uploadedImageURL');
// // if (uploadedImageURL !=
// //     null) {
// //   setState(() {
// //     profileImagePath =
// //         uploadedImageURL;
// //   });
// //   await _sendImage(
// //       uploadedImageURL);
// //   setState(() {
// //     _isProfileImageUploading =
// //         false;
// //   });
// // }
// print("camera is open");
// pickImageFromGallery();
// }
// : null,
// child: widget.isFromLoginRoute
// ? Container(
// padding:
// const EdgeInsets.only(
// right: 37),
// color: Colors.black26,
// width: 200,
// height: 47,
// child: Icon(
// Icons
//     .camera_alt_rounded,
// size: 36,
// color: Colors.white),
// )
// : Container(),
// ),
// ),
// profileImagePath.length == 0 ||
// profileImagePath == null
// ? Positioned(
// child: Padding(
// padding: const EdgeInsets.only(
// bottom: 40),
// child: Align(
// alignment: Alignment.center,
// child: Icon(
// Icons.person,
// size: 110,
// ),
// ),
// ),
// )
//     : Positioned(
// top: 0,
// width: 0,
// height: 0,
// child: Container(
// width: 0,
// height: 0,
// ),
// ),
// if (_isProfileImageUploading)
// Align(
// alignment: Alignment.center,
// child: Center(
// child: Container(
// child: CircularProgressIndicator(
// //value: 60,
// valueColor:
// AlwaysStoppedAnimation<
//     Color>(
// Colors.green,
// ),
// ),
// ),
// ),
// ),
// ],
// )
