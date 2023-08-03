import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';

class SRCheckbox extends StatelessWidget {
  static const double _borderWidth = 1;
  final bool checked;
  final Color tickColor;
  final Color borderColor;
  final Color backgroundSelectedColor;
  final Color backgroundUnselectedColor;
  final ValueChanged<bool?>? onChanged;

  factory SRCheckbox.auto({
    Key? key,
    required BuildContext context,
    required bool checked,
    ValueChanged<bool?>? onChanged,
  }) {
    return Theme.of(context).brightness == Brightness.dark
        ? SRCheckbox.dark(
            key: key,
            checked: checked,
            onChanged: onChanged,
          )
        : SRCheckbox.light(
            key: key,
            checked: checked,
            onChanged: onChanged,
          );
  }

  factory SRCheckbox.light({
    Key? key,
    required bool checked,
    ValueChanged<bool?>? onChanged,
  }) {
    return SRCheckbox._internal(
      key: key,
      checked: checked,
      tickColor: srCheckboxTick,
      borderColor: srCheckboxBorderLight,
      backgroundSelectedColor: srCheckboxBackgroundSelected,
      backgroundUnselectedColor: srCheckboxBackgroundUnselectedLight,
      onChanged: onChanged,
    );
  }

  factory SRCheckbox.dark({
    Key? key,
    required bool checked,
    ValueChanged<bool?>? onChanged,
  }) {
    return SRCheckbox._internal(
      key: key,
      checked: checked,
      tickColor: srCheckboxTick,
      borderColor: srCheckboxBorderDark,
      backgroundSelectedColor: srCheckboxBackgroundSelected,
      backgroundUnselectedColor: srCheckboxBackgroundUnselectedDark,
      onChanged: onChanged,
    );
  }

  const SRCheckbox._internal({
    super.key,
    required this.checked,
    required this.tickColor,
    required this.borderColor,
    required this.backgroundSelectedColor,
    required this.backgroundUnselectedColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
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
      checkColor: tickColor,
      side: MaterialStateBorderSide.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return const BorderSide(
            color: srCheckboxDisabled,
            width: _borderWidth,
          );
        }
        return states.contains(MaterialState.hovered) &&
                !states.contains(MaterialState.selected)
            ? const BorderSide(color: srHighlighted, width: _borderWidth)
            : BorderSide(color: borderColor, width: _borderWidth);
      }),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      value: checked,
      onChanged: onChanged,
    );
  }
}
