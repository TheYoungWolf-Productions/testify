import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles{
static Color appBg=Color(0XFFF8F9FB);
static Color darkPurple=Color(0xFF3F2668);
static Color lightPurple=Color(0xFF6D5A8D);
static Color darkGrey=Color(0xFF3F3F3F);
static Gradient purpleGradient=LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      lightPurple,
      darkPurple
    ]);
static BoxShadow boxShad= BoxShadow(
    color: Colors.black12,//Color(0xff00000029),
    spreadRadius: 2,
    blurRadius: 4,
    offset: Offset(0, 0),
  );

}