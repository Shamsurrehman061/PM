import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectProvinceDetails.dart';
import 'package:reale/EntryDetails/selectSchemeDetails.dart';
import 'package:reale/stepper_steps/selectCity.dart';

class SelectCityDetails extends StatefulWidget {
  const SelectCityDetails({Key? key, required this.provinceId, }) : super(key: key);

  final String provinceId;

  @override
  _SelectCityDetailsState createState() => _SelectCityDetailsState();
}

class _SelectCityDetailsState extends State<SelectCityDetails> {

  var city = [];
  var cityId = [];
  Box box = Hive.box<dynamic>('userData');

  String selectCity = "";
  String selectCityId = "";


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
              stream: FirebaseFirestore.instance.collection('cities').orderBy('name', descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot)
              {
                if(snapshot.hasData)
                {
                  var el = snapshot.data.docs;
                  city = [];
                  cityId = [];
                  for(var e in el)
                  {
                    if(e.data() != null)
                    {
                      if(e.data()['provinceID'] == widget.provinceId)
                      {
                        cityId.add(e.data()['id']);
                        city.add(e.data()['name']);
                      }
                    }
                  }

                  return DropDown<dynamic>(
                    hint: Text('select city'),
                    items: city,
                    onChanged: (val){
                      setState(() {
                        selectCity = val;
                        selectCityId = cityId[city.indexOf(val)];
                      });
                    },
                  );
                }
                else
                {
                  return CircularProgressIndicator();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.delete('city');
                    box.delete('cityId');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectProvinceDetails()));
                  }, child: Text("Back"),),
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('city', selectCity);
                    box.put('cityId', selectCityId);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectSchemeDetails(
                      provinceId: widget.provinceId,
                      cityId: selectCityId,
                    )));
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectProvinceDetails()));
                  }, child: Text("Continue"),),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
