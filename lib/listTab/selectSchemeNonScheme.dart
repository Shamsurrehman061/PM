import 'package:flutter/Material.dart';
import 'package:reale/listTab/nonScheme.dart';
import 'package:reale/listTab/viewScheme.dart';

import '../widgets/stylishCustomButton.dart';

class SelectSchemeNonScheme extends StatelessWidget {
  String city;
  SelectSchemeNonScheme({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const  EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.green,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text("Select Catagory",style: TextStyle(color: Colors.white,fontSize: 15),),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              margin:
              const EdgeInsets.only(top: 15, bottom: 5, left: 20),
              child: StylishCustomButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return viewSceme(
                            city: city);
                      }));
                },
                text: "Scheme",
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              margin:
              const EdgeInsets.only(top: 15, bottom: 5, left: 20),
              child: StylishCustomButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return NonSceme(
                            city: city);
                      }));
                },
                text: "Non Scheme",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
