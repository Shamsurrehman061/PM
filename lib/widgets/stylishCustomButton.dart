import 'package:flutter/material.dart';

class StylishCustomButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final IconData? icon;
  final bool? isSmallerSize;
  final bool? isCenter;
  final Color? buttonColor;

  const StylishCustomButton({
    Key? key,
    this.text,
    this.onPressed,
    this.icon,
    this.isSmallerSize,
    this.isCenter = false,
    this.buttonColor,
  })  : //assert(text != null),
        assert(onPressed != null),
        super(key: key);

  // text is optional
  const StylishCustomButton.icon({
    Key? key,
    this.text,
    this.onPressed,
    this.icon,
    this.isSmallerSize,
    this.isCenter = false,
    this.buttonColor,
  })  : assert(icon != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: MaterialButton(
        padding: EdgeInsets.all(isSmallerSize == true ? 5 : 10),
        elevation: 20,
        color: this.buttonColor ?? Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide.none,
        ),
        onPressed: onPressed,
        child: icon == null
            ? Text(
                text!,
                textAlign: isCenter! ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: isSmallerSize == true ? 17 : 20,
                ),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    text == null
                        ? Container()
                        : Text(
                            text!,
                            style: TextStyle(
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: isSmallerSize == true ? 17 : 20,
                            ),
                          ),
                    text == null
                        ? SizedBox(width: 0)
                        : SizedBox(
                            width: isSmallerSize == true
                                ? 5
                                : 25), // before value is 25
                    Icon(
                      icon,
                      size: isSmallerSize == true ? 20 : 25,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
