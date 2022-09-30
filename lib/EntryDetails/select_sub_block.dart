import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectBlockDetails.dart';
import 'package:reale/EntryDetails/select_area.dart';
import 'package:reale/EntryDetails/select_property_type.dart';


import '../newCode/data.dart';

class SubBlockDetails extends StatefulWidget {
  const SubBlockDetails({Key? key, required this.cityId, required this.provinceId, required this.phaseId, required this.blockId, required this.schemeId, required this.isScheme, required this.propertyType}) : super(key: key);

  final String cityId;
  final String provinceId;
  final String phaseId;
  final String blockId;
  final String schemeId;
  final bool isScheme;
  final String propertyType;


  @override
  _SubBlockDetailsState createState() => _SubBlockDetailsState();
}

class _SubBlockDetailsState extends State<SubBlockDetails> {

  var subBlock = [];
  var subBlockId = [];
  String selectedSubBlock = "";
  String selectedSubBlockId = "";

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
                stream: FirebaseFirestore.instance.collection('subblock').orderBy('name', descending: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData)
                  {
                    var el = snapshot.data.docs;
                    subBlock = [];
                    subBlockId = [];
                    for(var e in el)
                    {
                      if(e.data() != null)
                      {
                        if(e.data()['cityID'] == widget.cityId && e.data()['provinceID'] == widget.provinceId && e.data()['schemeID'] == widget.schemeId && e.data()['phaseID'] == widget.phaseId && e.data()['blockID'] == widget.blockId)
                        {

                          subBlock.add(e.data()['name']);
                          subBlockId.add(e.data()['id']);
                        }
                        else
                        {
                          print('error');
                        }
                      }
                      else
                      {
                        print('error');
                      }
                    }


                    return  DropDown<dynamic>(
                      hint: Text("select sub block"),
                      items: subBlock,
                      onChanged: (val)
                      {
                        setState((){
                          selectedSubBlock = val;
                          selectedSubBlockId = subBlockId[subBlock.indexOf(val)];
                        });
                      },
                    );
                  }
                  else
                  {
                    return CircularProgressIndicator();
                  }
                }),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.delete('subBlock');
                    box.delete('subBlockId');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    SelectBlockDetails(
                      provinceId: widget.provinceId,
                      cityId: widget.cityId,
                      schemeId: widget.schemeId,
                      isScheme: widget.isScheme,
                      propertyType: widget.propertyType,
                      phaseId: widget.phaseId,
                   )));
    }, child: Text("Back"),),
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('subBlock', selectedSubBlock);
                    box.put('subBlockId', selectedSubBlockId);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SelectArea(isScheme: widget.isScheme,),
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
