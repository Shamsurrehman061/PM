import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectBlockDetails.dart';
import 'package:reale/EntryDetails/selectTypeDetails.dart';
import 'package:reale/EntryDetails/select_purpose.dart';


class SelectPhaseDetails extends StatefulWidget {
  const SelectPhaseDetails({Key? key, required this.cityId, required this.provinceId, required this.isScheme, required this.propertyType, required this.typeId,}) : super(key: key);

  final String propertyType;
  final String provinceId;
  final String cityId;
  final String typeId;
  final bool isScheme;
  @override
  _SelectPhaseDetailsState createState() => _SelectPhaseDetailsState();
}

class _SelectPhaseDetailsState extends State<SelectPhaseDetails> {

  var phase = [];
  var phaseId = [];
  String selectedPhase = "";
  String selectedPhaseId = "";

  Box box = Hive.box<dynamic>('userData');

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
                  .collection('Phase')
                  .orderBy("name", descending: false)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.hasData) {
                  var el = snapshot.data.docs;
                  phase = [];
                  phaseId = [];
                  for (var i in el) {
                    if (i.data() != null) {
                      if(i.data()['cityID'] == widget.cityId && i.data()['provinceID'] == widget.provinceId && i.data()['schemeID'] == widget.typeId)
                        {
                          phase.add(i.data()['name']);
                          phaseId.add(i.data()['id']);
                        }
                    }
                  }

                  return DropDown<dynamic>(
                    hint: Text("select phase"),
                    items: phase,
                    onChanged: (val){
                      setState(() {
                        selectedPhase = val;
                        selectedPhaseId = phaseId[phase.indexOf(val)];
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
                    box.delete('phase');
                    box.delete('phaseId');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectPurpose(provinceId: widget.provinceId, cityId: widget.cityId, isScheme: true, propertyType: widget.propertyType, typeId: widget.typeId,)));
                  }, child: Text("Back"),),
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('phase', selectedPhase);
                    box.put('phaseId', selectedPhaseId);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SelectBlockDetails(provinceId: widget.provinceId, cityId: widget.cityId, schemeId: widget.typeId, phaseId: selectedPhaseId, isScheme: widget.isScheme, propertyType: widget.propertyType,)
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
