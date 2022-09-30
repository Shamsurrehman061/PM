import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectCityDetails.dart';

class SelectProvinceDetails extends StatefulWidget {
  const SelectProvinceDetails({Key? key}) : super(key: key);

  @override
  _SelectProvinceDetailsState createState() => _SelectProvinceDetailsState();
}

class _SelectProvinceDetailsState extends State<SelectProvinceDetails> {


  var provinces = [];
  var provinceId = [];
  Box box = Hive.box<dynamic>('userData');

  String selectProvince = "";
  String selectProvinceId = "";
  @override
  Widget build(BuildContext context) {
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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('province')
                  .orderBy("name", descending: false)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var el = snapshot.data.docs;
                  provinces = [];
                  provinceId = [];
                  for (var i in el) {
                    if (i.data() != null) {
                      provinces.add(i.data()['name']);
                      provinceId.add(i.data()['id']);
                    }
                  }
                  print(provinceId);
                  return DropDown<dynamic>(
                    hint: Text("select province"),
                    items: provinces,
                    onChanged: (val){
                      setState(() {
                        selectProvince = val;
                        selectProvinceId = provinceId[provinces.indexOf(val)];
                      });
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.delete('provinceName');
                    box.delete('provinceId');
                  },
                  child: Text("Back"),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('provinceName', selectProvince);
                    box.put('provinceId', selectProvinceId);
                    Navigator.of(context).push(

                        MaterialPageRoute(
                            builder: (context) => SelectCityDetails(
                              provinceId: selectProvinceId,
                            )));

                  }, child:const Text("Continue"),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
