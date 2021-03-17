import 'dart:ui';

import 'package:flutter/material.dart';

hexColor(String colorhexcode) {
  String colornew = "0xff" + colorhexcode;
  colornew = colornew.replaceAll("#", "");
  int colorint = int.parse(colornew);
  return colorint;
}

var bgColor1 = Color(hexColor('#9CA9E1')); //blue one
var bgColor2 = Color(hexColor('#D49CE1'));
// var bgColor1 = Color(hexColor('#9077E5'));
// var bgColor2 = Color(hexColor('#B97DCE'));
var bgText = Colors.white;
var primaryButtonColor = Color(hexColor('#77E5C7'));
var primaryButtonColor2 = Color(hexColor('#9CCBE1'));
var primaryRed = Color(hexColor('#E57795'));
var primaryRed2 = Color(hexColor('#F2A2DC'));
var primaryGreen = Color(hexColor('#CCE577'));
var primaryGreen2 = Color(hexColor('#A9E19C'));
var primarySalmon = Color(hexColor('#E59077'));

class DefaultTextUI extends TextStyle {
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final String fontFamily;

  const DefaultTextUI({
    @required this.color,
    @required this.fontWeight,
    @required this.size,
    this.fontFamily = 'Futura',
  })  : assert(color != null && fontWeight != null && size != null),
        super(
            color: color,
            fontWeight: fontWeight,
            fontSize: size,
            fontFamily: fontFamily);
}
