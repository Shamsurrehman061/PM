import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectPhaseDetails.dart';
import 'package:reale/EntryDetails/select_sub_block.dart';

class SelectBlockDetails extends StatefulWidget {
  const SelectBlockDetails({Key? key, required this.provinceId, required this.cityId, required this.schemeId, required this.phaseId, required this.isScheme, required this.propertyType}) : super(key: key);

  final String provinceId;
  final String cityId;
  final String schemeId;
  final String phaseId;
  final bool isScheme;
  final String propertyType;

  @override
  _SelectBlockDetailsState createState() => _SelectBlockDetailsState();
}

class _SelectBlockDetailsState extends State<SelectBlockDetails> {

  var block= [];
  var blockId = [];
  String selectedBlock = "";
  String selectedBlockId = "";

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
                stream: FirebaseFirestore.instance.collection('block').orderBy('name', descending: false).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData)
                  {
                    var el = snapshot.data.docs;
                    block = [];
                    blockId = [];
                    for(var e in el)
                    {
                      if(e.data() != null)
                      {
                        if(e.data()['cityID'] == widget.cityId && e.data()['provinceID'] == widget.provinceId && e.data()['schemeID'] == widget.schemeId && e.data()['phaseID'] == widget.phaseId)
                        {
                          block.add(e.data()['name']);
                          blockId.add(e.data()['id']);
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
                      hint: Text("select block"),
                      items: block,
                      onChanged: (val)
                      {
                        setState((){
                          selectedBlock = val;
                          selectedBlockId = blockId[block.indexOf(val)];
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
                    box.delete('block');
                    box.delete('blockId');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SelectPhaseDetails(provinceId: widget.provinceId, cityId: widget.cityId, typeId: widget.schemeId, isScheme: widget.isScheme, propertyType: widget.propertyType,)));
                  }, child: Text("Back"),),
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('block', selectedBlock);
                    box.put('blockId', selectedBlockId);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SubBlockDetails(
                              provinceId: widget.provinceId,
                              cityId: widget.cityId,
                              schemeId: widget.schemeId,
                              phaseId: widget.phaseId,
                              blockId: selectedBlockId,
                              isScheme: widget.isScheme,
                              propertyType: widget.propertyType,
                            )
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
