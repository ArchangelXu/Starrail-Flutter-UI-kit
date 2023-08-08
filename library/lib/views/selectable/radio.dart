import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';

class SRRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final Color backgroundSelectedColor;
  final Color backgroundUnselectedColor;
  final ValueChanged<T?>? onChanged;

  factory SRRadio.auto({
    Key? key,
    required BuildContext context,
    required T value,
    T? groupValue,
    required ValueChanged<T?>? onChanged,
  }) {
    return Theme.of(context).brightness == Brightness.dark
        ? SRRadio<T>.dark(
            key: key,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          )
        : SRRadio<T>.light(
            key: key,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          );
  }

  factory SRRadio.light({
    Key? key,
    required T value,
    T? groupValue,
    required ValueChanged<T?>? onChanged,
  }) {
    return SRRadio<T>._internal(
      key: key,
      value: value,
      groupValue: groupValue,
      backgroundSelectedColor: srCheckboxBackgroundSelected,
      backgroundUnselectedColor: srCheckboxBorderLight,
      onChanged: onChanged,
    );
  }

  factory SRRadio.dark({
    Key? key,
    required T value,
    T? groupValue,
    required ValueChanged<T?>? onChanged,
  }) {
    return SRRadio<T>._internal(
      key: key,
      value: value,
      groupValue: groupValue,
      backgroundSelectedColor: srCheckboxBackgroundSelected,
      backgroundUnselectedColor: srCheckboxBorderDark,
      onChanged: onChanged,
    );
  }

  const SRRadio._internal({
    super.key,
    required this.value,
    required this.backgroundSelectedColor,
    required this.backgroundUnselectedColor,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return srCheckboxDisabled;
        }
        return states.intersection({
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.selected,
        }).isNotEmpty
            ? backgroundSelectedColor
            : backgroundUnselectedColor;
      }),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
