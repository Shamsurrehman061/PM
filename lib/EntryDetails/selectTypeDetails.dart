import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:reale/EntryDetails/selectPhaseDetails.dart';
import 'package:reale/EntryDetails/selectSchemeDetails.dart';
import 'package:reale/EntryDetails/select_property_type.dart';

class SelectTypeDetails extends StatefulWidget {
  const SelectTypeDetails({Key? key, required this.provinceId,  required this.cityId, required this.isScheme}) : super(key: key);


  final String provinceId;
  final String cityId;
  final bool isScheme;
  
  @override
  _SelectTypeDetailsState createState() => _SelectTypeDetailsState();
}

class _SelectTypeDetailsState extends State<SelectTypeDetails> {

  Box box = Hive.box<dynamic>('userData');

  var type = [];
  var typeId = [];
  String typeSelected = "";
  String typeIdSelected = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.isScheme);
  }

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
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection(widget.isScheme ? 'Scheme' : 'Non Scheme').orderBy('name', descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot)
              {
                if(snapshot.hasData)
                  {
                    var myData = snapshot.data.docs;
                    type = [];
                    typeId = [];

                    for(var el in myData)
                      {
                        if(el.data() != null)
                          {
                            if(widget.provinceId == el.data()['provinceID'] && widget.cityId == el.data()['cityID'])
                              {
                                type.add(el.data()['name']);
                                typeId.add(el.data()['id']);
                              }
                          }
                      }

                    return DropDown<dynamic>(
                      hint: Text("select type"),
                      items: type,
                      onChanged: (val)
                      {
                        setState((){
                          typeSelected = val;
                          typeIdSelected = typeId[type.indexOf(val)];
                        });
                      },
                    );
                  }
                else
                  {
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
                    box.delete('type');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectSchemeDetails(provinceId: widget.provinceId, cityId: widget.cityId,)));
                  },
                  child: Text("Back"),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                    box.put('type', typeSelected);
                    box.put('typeId', typeIdSelected);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                         SelectPropertyType(isScheme: widget.isScheme, provinceId: widget.provinceId, cityId: widget.cityId, typeId: typeIdSelected,),
                        ));
                  }, child:const Text("Continue"),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
