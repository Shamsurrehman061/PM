import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  CircularLoader({Key? key,  this.showLoader}) : super(key: key);
  final bool? showLoader;

  @override
  Widget build(BuildContext context) {
    return showLoader!
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container();
  }
}
