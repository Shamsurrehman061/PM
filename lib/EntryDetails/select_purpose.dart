import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectPhaseDetails.dart';
import 'package:reale/EntryDetails/select_area.dart';
import 'package:reale/EntryDetails/select_property_sub_type.dart';


class SelectPurpose extends StatefulWidget {
  const SelectPurpose({Key? key, required this.propertyType, required this.provinceId, required this.cityId, required this.typeId, required this.isScheme}) : super(key: key);

  final String propertyType;
  final String provinceId;
  final String cityId;
  final String typeId;
  final bool isScheme;

  @override
  _SelectPurposeState createState() => _SelectPurposeState();
}

class _SelectPurposeState extends State<SelectPurpose> {

  Box box = Hive.box<dynamic>('userData');
  String selectedPurpose = "";

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

            DropDown<dynamic>(
              hint: Text("select purpose"),
              items: [
                "Lease",
                "Rent",
                "Sale",
              ],
              onChanged: (val)
              {
                setState((){
                  selectedPurpose = val;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.delete('purpose');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        SelectPropertySubType(
                          provinceId: widget.provinceId,
                          cityId: widget.cityId,
                          typeId: widget.typeId,
                          isScheme: widget.isScheme,
                          propertyType: widget.propertyType,
                        )));
                  },
                  child:const Text("Back"),),
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('purpose', selectedPurpose);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => widget.isScheme ? SelectPhaseDetails(cityId: widget.cityId, provinceId: widget.provinceId, typeId: widget.typeId, isScheme: widget.isScheme, propertyType: widget.propertyType,) :  SelectArea(isScheme: widget.isScheme,),
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
