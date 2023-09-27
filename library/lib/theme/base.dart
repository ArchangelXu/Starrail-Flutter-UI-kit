import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/views/progress/slider.dart';

const srAnimationDuration = Duration(milliseconds: 200);
const srAnimationCurve = Curves.easeInOutQuad;

const List<Shadow> srTextShadow = [
  Shadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(1, 1)),
];
const List<BoxShadow> srBoxShadow = [
  BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
];
TextSelectionThemeData srTextSelectionThemeData = TextSelectionThemeData(
  cursorColor: srHighlighted,
  selectionColor: srHighlighted.withOpacity(0.5),
  selectionHandleColor: srHighlighted,
);
final SliderThemeData srSliderThemeData = SliderThemeData(
  thumbShape: SRSliderValueIndicatorShape(),
  thumbColor: srHighlighted,
  disabledThumbColor: srSliderDisabled,
  trackShape: const RectangularSliderTrackShape(),
  trackHeight: 4,
  activeTrackColor: srHighlighted,
  inactiveTrackColor: srSliderNotFilled,
  disabledActiveTrackColor: srSliderDisabled,
  disabledInactiveTrackColor: srSliderNotFilled,
  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
  overlayColor: Colors.transparent,
  activeTickMarkColor: Colors.transparent,
  inactiveTickMarkColor: Colors.transparent,
);
