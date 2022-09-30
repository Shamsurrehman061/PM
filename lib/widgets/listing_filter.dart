// class FilterDialog extends StatefulWidget {
//   Function refresh;
//   Function addToStream;
//   Function showNoneDataToUser;
//   FilterDialog({this.refresh, this.addToStream, this.showNoneDataToUser});
//   @override
//   _RangePropertyDialogState createState() => _RangePropertyDialogState();
// }
//
// class _RangePropertyDialogState extends State<FilterDialog> {
//   // should have
//   Future<void> getAllCitiesFromFirebase() async {
//     print('invoked.....getAllCitiesFromFirebase()');
//     QuerySnapshot _snapshot = await FirebaseFirestore.instance
//         .collection("cities")
//         .orderBy("name", descending: false)
//         .get();
//
//     _allCityFromFirebase = [];
//     _allCityIDFromFirebase = [];
//
//     print('city snapshot length: ${_snapshot.docs.length}');
//     //var el = _snapshot.docs;
//     for (var e in _snapshot.docs) {
//       if (e.data() != null) {
//         print('current province id: $currentProvinceID');
//         if (e.data()["provinceID"] == currentProvinceID) {
//           _allCityFromFirebase.add(e.data()["name"]);
//           _allCityIDFromFirebase.add(e.data()["id"]);
//         }
//       }
//     }
//     print('all cities names from firebase: $_allCityFromFirebase');
//     setState(() {});
//   }
//
//   List<String> _allProvinceFromFirebase = [];
//   List<String> _allProvinceIDFromFirebase = [];
//   String currentProvinceID = '';
//
//   List<String> _allCityFromFirebase = [];
//   List<String> _allCityIDFromFirebase = [];
//   String currentCityID;
//
//   bool _isProvinceSelected = false;
//   bool _isCitySelected = false;
//
//   bool _isSubTypeSelected = false;
//   bool _isRangeSelected = false;
//
//   String selectedProvince = 'Khyber Pakhtunkhwa';
//   String selectedCity = '';
//   String propertySubType = '';
//   int minRange = 0;
//   int maxRange = 0;
//   String areaUnit = '';
//
//   List<String> subtypes = [
//     'Food Court',
//     "Factory",
//     "Gym",
//     "Hall",
//     "Office",
//     "Shop",
//     "Theatre",
//     "Warehouse",
//     'Farm House',
//     'Guest House',
//     'Hostel',
//     'House',
//     'Penthouse',
//     "Room",
//     'Villas',
//     'Commercial Land',
//     'Residential Land',
//     'Plot File',
//   ];
//
//   SimpleDatabase propertySelectedBasedOnRange =
//   SimpleDatabase(name: 'propertySearchDialog');
//   int _totalRecord = 0;
//
//   SimpleDatabase propertyDialogData;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//
//     propertySelectedBasedOnRange.count().then((value) => _totalRecord = value);
//     setState(() {
//       isLoading = true;
//     });
//     super.initState();
//     print('init state...range dialog');
//     FirebaseFirestore.instance
//         .collection("province")
//         .orderBy("name", descending: false)
//         .get()
//         .then((QuerySnapshot _snapshot) {
//       var el = _snapshot.docs;
//       _allProvinceFromFirebase = [];
//       for (var e in el) {
//         if (e.data() != null) {
//           _allProvinceFromFirebase.add(e.data()["name"]);
//           _allProvinceIDFromFirebase.add(e.data()["id"]);
//         }
//       }
//       print('All provinces: $_allProvinceFromFirebase');
//       print('All provinces ID: $_allProvinceIDFromFirebase');
//       setState(() {});
//
//       // get all data from database and show it to the dialog
//       propertyDialogData =
//           SimpleDatabase(name: 'propertySearchDialog');
//       propertyDialogData.getAll().then((List<dynamic> userData) {
//         isLoading = false;
//         print('User All data: $userData');
//         if(userData.length > 0){
//           selectedProvince = userData[0]['selectedProvince'];
//           selectedCity = userData[0]['selectedCity'];
//           propertySubType = userData[0]['selectPropertySubType'];
//           minRange = userData[0]['minRange'];
//           maxRange = userData[0]['maxRange'];
//           areaUnit = userData[0]['areaUnit'];
//         } else {
//           print('no user stored filter data found');
//         }
//         setState(() {
//
//         });
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: isLoading ? Container(child: Center(child: CircularProgressIndicator())) : Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         //width: 200,
//         height: 355,
//         child: ListView(
//           //mainAxisAlignment: MainAxisAlignment.start,
//           //crossAxisAlignment: CrossAxisAlignment.start,
//           // mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Filter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
//             // province
//             DropDown(
//               items: _allProvinceFromFirebase,
//               hint: selectedProvince.length > 0 ? Text(selectedProvince) : Text("select province"),
//               //initialValue: _allProvinceFromFirebase.length == 0 ? selectedProvince : null,
//               onChanged: (val) async {
//                 print('onChanged callback');
//                 selectedProvince = val;
//                 print('selected province: $val');
//                 int provinceIndex = _allProvinceFromFirebase.indexOf(val);
//                 print('province index: $provinceIndex');
//                 if (provinceIndex != -1 && provinceIndex != null) {
//                   currentProvinceID =
//                       _allProvinceIDFromFirebase[provinceIndex].toString();
//                   print('current province ID: $currentProvinceID');
//                   print('province selected: $_isProvinceSelected');
//                   setState(() {});
//                   await getAllCitiesFromFirebase();
//                 }
//               },
//             ),
//             SizedBox(height: 5),
//             // city
//             DropDown(
//               items: _allCityFromFirebase,
//               hint:  selectedCity.length > 0 ? Text(selectedCity) : Text("select city"),
//               onChanged: _allCityFromFirebase.length > 0
//                   ? (val) async {
//                 print('onChanged callback');
//                 selectedCity = val;
//                 currentCityID = _allCityIDFromFirebase[
//                 _allCityFromFirebase.indexOf(val)]
//                     .toString();
//                 print('selected city ID: $currentCityID');
//
//                 // setState(() {
//                 //   _isCitySelected = true;
//                 // });
//               }
//                   : null,
//             ),
//             SizedBox(height: 5),
//             //sub type
//
//             DropDown(
//                 items: subtypes,
//                 hint: propertySubType.length > 0 ? Text(propertySubType) : Text("select sub type"),
//
//                 onChanged: (val) async {
//                   _isSubTypeSelected = true;
//                   propertySubType = val;
//                   print('onChanged callback');
//                   // setState(() {
//                   //   _isSubTypeSelected = true;
//                   // });
//                 }
//             ),
//             SizedBox(height: 5),
//             // range
//             // SliderTheme(
//             //   data: SliderThemeData(
//             //     //activeTickMarkColor: Colors.blue.withOpacity(0.4),
//             //     //overlayColor: Colors.black45,
//             //     /// overlappingShapeStrokeColor: Colors.teal[300],
//             //     showValueIndicator: ShowValueIndicator.always,
//             //     disabledThumbColor: Colors.grey,
//             //   ),
//             //   child: Row(
//             //     //mainAxisAlignment: MainAxisAlignment.start,
//             //     children: [
//             //       Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
//             //       //SizedBox(width: 10),
//             //       Expanded(
//             //         child: RangeDialog(
//             //           populateMinMaxRange: (double _minRange, double _maxRange) {
//             //             minRange = _minRange;
//             //             maxRange = _maxRange;
//             //             _isRangeSelected = true;
//             //             // setState(() {
//             //             //   _isRangeSelected = true;
//             //             // });
//             //           },
//             //         ),
//             //       ),
//             //       //SizedBox(width: 10),
//             //       Text('1000', style: TextStyle(fontWeight: FontWeight.bold)),
//             //     ],
//             //   ),
//             // ),
//             /*Row for min and max drop down*/
//             Row(
//               children: [
//                 DropDown(
//                     items: [5, 10, 20, 50, 100],
//                     hint: Text(minRange.toString()),
//                     onChanged: (val) async {
//                       print('min range: $val');
//                       minRange = val;
//                     }
//                 ),
//                 Spacer(),
//                 DropDown(
//                     items: [300, 500, 1000, 2000, 4000, 5000],
//                     hint: Text(maxRange.toString()),
//
//                     onChanged: (val) async {
//
//                       print('max range: $val');
//                       maxRange = val;
//                     }
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             // drop down for area unit
//             DropDown(
//                 items: ["Squareft", "Marla", "Canal", "Acre", "Hectare"],
//                 hint: areaUnit.length > 0 ? Text(areaUnit) : Text("Select Unit"),
//
//                 onChanged: (val) async {
//
//                   areaUnit = val;
//                 }
//             ),
//             SizedBox(height: 5),
//             Row(
//               children: [
//                 // search button
//                 TextButton(
//                   onPressed: () async {
//                     setState(() {
//                       print('Selected province: $selectedProvince');
//                       print('Selected province ID: $currentProvinceID');
//                       print('Selected city: $selectedCity');
//                       print('Selected city ID: $currentCityID');
//                       print('property sub type: $propertySubType');
//                       print('Min Range: $minRange');
//                       print('Max Range: $maxRange');
//
//                       print('setState() selected....');
//                       // setting up the database
//                     });
//                     SimpleDatabase propertySelectedBasedOnRange =
//                     SimpleDatabase(name: 'propertySearchDialog');
//                     await propertySelectedBasedOnRange.clear();
//                     Map<String, dynamic> propertySearchDialog =
//                     Map<String, dynamic>();
//
//                     propertySearchDialog['selectedProvince'] = selectedProvince;
//                     propertySearchDialog['selectedProvinceID'] =
//                         currentProvinceID;
//                     propertySearchDialog['selectedCity'] = selectedCity;
//                     propertySearchDialog['selectedCityID'] = currentCityID;
//                     propertySearchDialog['selectPropertySubType'] =
//                         propertySubType;
//                     propertySearchDialog['minRange'] = minRange;
//                     propertySearchDialog['maxRange'] = maxRange;
//                     propertySearchDialog['areaUnit'] = areaUnit;
//
//
//                     await propertySelectedBasedOnRange.add(propertySearchDialog);
//
//                     print('Range Based Property Selection attribute: ');
//                     Future<QuerySnapshot> querySnap;
//                     for (var item
//                     in await propertySelectedBasedOnRange.getAll()) {
//                       print('item: $item');
//                     }
//                     if(_isRangeSelected && _isSubTypeSelected){
//                       querySnap = FirebaseFirestore.instance.collection('listings').
//                       where('provinceName', isEqualTo: selectedProvince.toLowerCase(), ).
//                       where('cityName', isEqualTo: selectedCity.toLowerCase()).
//                       where('subType', isEqualTo: propertySubType).
//                       where('area', isGreaterThanOrEqualTo: minRange.toString()).
//                       where('area', isLessThanOrEqualTo: maxRange.toString()).
//                       get();
//                     } else if (_isSubTypeSelected && _isRangeSelected == false){
//                       querySnap = FirebaseFirestore.instance.collection('listings').
//                       where('provinceName', isEqualTo: selectedProvince.toLowerCase(), ).
//                       where('cityName', isEqualTo: selectedCity.toLowerCase()).
//                       where('subType', isEqualTo: propertySubType).
//                       //where('area', isGreaterThanOrEqualTo: minRange.toString()).
//                       //where('area', isLessThanOrEqualTo: maxRange.toString()).
//                       get();
//                     } else if (_isRangeSelected && _isSubTypeSelected == false){
//                       print('_isRangeSelected && _isSubTypeSelected == false');
//                       querySnap = FirebaseFirestore.instance.collection('listings').
//                       where('provinceName', isEqualTo: selectedProvince.toLowerCase(), ).
//                       where('cityName', isEqualTo: selectedCity.toLowerCase()).
//                       where('area', isGreaterThanOrEqualTo: minRange.toString()).
//                       where('area', isLessThanOrEqualTo: maxRange.toString()).
//                       get();
//                     } else {
//                       // rand sub type both are not selected
//                       querySnap = FirebaseFirestore.instance.collection('listings').
//                       where('provinceName', isEqualTo: selectedProvince.toLowerCase(), ).
//                       where('cityName', isEqualTo: selectedCity.toLowerCase()).
//                       // where('subType', isEqualTo: propertySubType).
//                       //where('area', isGreaterThanOrEqualTo: minRange.toString()).
//                       //where('area', isLessThanOrEqualTo: maxRange.toString()).
//                       get();
//                     }
//                     // // firebase searching start
//                     // querySnap = FirebaseFirestore.instance.collection('listings').
//                     // where('provinceName', isEqualTo: selectedProvince.toLowerCase(), ).
//                     // where('cityName', isEqualTo: selectedCity.toLowerCase()).
//                     // where('subType', isEqualTo: propertySubType).
//                     // where('area', isGreaterThanOrEqualTo: minRange.toString()).
//                     // where('area', isLessThanOrEqualTo: maxRange.toString()).
//                     // get();
//                     //querySnap.listen((event) {print('Total Document: ${event.docs.length}');});
//                     //where('cityName', isEqualTo: selectedCity).
//                     //where('subType', isEqualTo: propertySubType).
//                     //where('area', isGreaterThan: minRange).
//                     //where('area', isLessThanOrEqualTo: maxRange).
//                     //orderBy('cityName', descending: false);
//                     print('pre loading');
//                     //int totalLength = await querySnap.length;
//                     //print('total query Lenght: $totalLength');
//
//                     querySnap.then((QuerySnapshot _snap) async {
//                       if(_snap.docs.length == 0){
//                         // no data found
//                         print('if- Total Docs: ${_snap.docs.length}');
//                         //widget.addToStream(QuerySnapshot);
//                         // TODO: show no data to user on the screen
//
//                         await showDialog(context: context, builder: (context) => AlertErrorWidget(),);
//                         widget.showNoneDataToUser(true);
//                         //return;
//                         //AlertErrorWidget();
//                       }
//                       else {
//                         // data found
//                         print('else- Total Docs: ${_snap.docs.length}');
//                         widget.addToStream(_snap);
//                         Navigator.of(context).pop();
//                         //Navigator.of(context).pop(Stream.fromFuture(Future.value(_snap)));
//                       }
//                     });
//
//                     print('post loading');
//                     int totalDocuments = -1;
//                     // querySnap.listen((QuerySnapshot snap) {
//                     //   print('Total Documents: ${snap.docs.length}');
//                     //   totalDocuments = snap.docs.length;
//                     //
//                     // });
//
//
//                     // if(totalDocuments == 0){
//                     //   print('if Total Document: $totalDocuments');
//                     //   // show dialog and return
//                     //   showDialog(
//                     //     context: context,
//                     //     builder: (context) {
//                     //       return AlertErrorWidget();
//                     //     },
//                     //   );
//                     //
//                     //   //Navigator.of(context).pop();
//                     // }
//                     // else if (totalDocuments == -1){
//                     //   setState(() {
//                     //
//                     //   });
//                     //   print('else-if Total Document: $totalDocuments');
//                     //   return ProgressWidget();
//                     // }
//                     // else{
//                     //   print('else Total Document: $totalDocuments');
//                     //   Navigator.of(context).pop(querySnap);
//                     // }
//                     //Navigator.of(context).pop(querySnap);
//                   } ,
//                   child: Text('search'),
//                 ),
//                 // exit button
//                 TextButton(onPressed: ()async{
//                   Navigator.of(context).pop();
//                 }, child: Text('Exit'),),
//                 Spacer(),
//                 TextButton(
//                   onPressed: _totalRecord > 0 ? () async {
//
//                     await propertySelectedBasedOnRange.clear();
//                     widget.refresh();
//                     Navigator.of(context).pop();
//                   } : null, child: Text('clear Filter'),),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }