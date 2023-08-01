import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';

class SRCheckbox extends StatelessWidget {
  final bool checked;
  final Color backgroundSelectedColor;
  final Color tickColor;
  final Color borderColor;

  final Color backgroundUnselectedColor;
  final ValueChanged<bool?>? onChanged;

  factory SRCheckbox.light({
    Key? key,
    required bool checked,
    required ValueChanged<bool?>? onChanged,
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
    required ValueChanged<bool?>? onChanged,
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
    var checkbox = Checkbox(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      // fillColor: MaterialStateProperty.all(backgroundSelectedColor),
      fillColor: MaterialStateProperty.resolveWith((states) {
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
        return states.intersection({
          MaterialState.hovered,
        }).isNotEmpty
            ? const BorderSide(color: srHighlighted, width: 0.5)
            : BorderSide(color: borderColor, width: 0.5);
      }),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      value: checked,
      onChanged: (value) {
        onChanged?.call(value);
      },
    );
    return checkbox;
  }
}
