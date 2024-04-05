import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE8FAEF),
  100: Color(0xFFC7F2D6),
  200: Color(0xFFA1EABB),
  300: Color(0xFF7BE1A0),
  400: Color(0xFF5FDA8B),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF3DCF6F),
  700: Color(0xFF34C964),
  800: Color(0xFF2CC35A),
  900: Color(0xFF1EB947),
});
const int _primaryPrimaryValue = 0xFF43D477;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFF1FFF4),
  200: Color(_primaryAccentValue),
  400: Color(0xFF8BFFA6),
  700: Color(0xFF71FF93),
});
const int _primaryAccentValue = 0xFFBEFFCD;
