import 'package:flutter/material.dart';
import 'package:reale/constant.dart';

class CustomTextWidget extends StatelessWidget {
  final String? text1;
  final String? text2;
  const CustomTextWidget({
    this.text1,
    this.text2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: text1,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: GreyColorWriting,
              fontFamily: "Times New Roman",
              fontSize: 17),
          children: [
            TextSpan(
              text: text2,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: "Times New Roman",
                  fontSize: 16),
            ),
          ]),
    );
  }
}
