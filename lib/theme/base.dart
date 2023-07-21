import 'package:flutter/material.dart';

const defaultAnimationDuration = Duration(milliseconds: 200);
const defaultAnimationCurve = Curves.easeInOutQuad;

ThemeData srTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

const List<Shadow> defaultTextShadow = [
  Shadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(1, 1))
];
const List<BoxShadow> defaultBoxShadow = [
  BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))
];
