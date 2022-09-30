import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reale/EntryDetails/selectCityDetails.dart';
import 'package:reale/EntryDetails/selectProvinceDetails.dart';
import 'package:reale/EntryDetails/selectTypeDetails.dart';


class SelectSchemeDetails extends StatefulWidget {
  const SelectSchemeDetails({Key? key, required this.provinceId, required this.cityId}) : super(key: key);

  final String provinceId;
  final String cityId;

  @override
  State<SelectSchemeDetails> createState() => _SelectSchemeDetailsState();
}

class _SelectSchemeDetailsState extends State<SelectSchemeDetails> {

  var SchemesData = ['Scheme', 'Non-Scheme'];
  bool isScheme = false;
  bool isNonScheme = false;

  Box<dynamic> box = Hive.box<dynamic>('userData');
  String selectScheme = "";

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
              hint:const Text('select scheme'),
              items: SchemesData,
              onChanged: (val)
              {
                setState(() {
                  selectScheme = val;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.delete('schemeData');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectCityDetails(provinceId: widget.provinceId)));
                  }, child: Text("Back"),),

                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('schemeData', selectScheme);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SelectTypeDetails(provinceId: widget.provinceId, cityId: widget.cityId, isScheme: selectScheme == "Scheme" ? true : false,)
                        ));
                  }, child: Text("Continue"),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
