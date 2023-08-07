import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(message),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true, bool hasAlpha = false}) =>
      '${leadingHashSign ? '#' : ''}'
      '${hasAlpha ? alpha.toRadixString(16).padLeft(2, '0') : ""}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
