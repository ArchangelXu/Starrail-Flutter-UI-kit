import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';

class SRTextField extends StatefulWidget {
  final TextEditingController controller;
  final int? maxLines;
  final int? maxLength;
  final bool? enabled;
  final bool showClearButton;
  final ValueChanged<String>? onChanged;

  const SRTextField({
    super.key,
    required this.controller,
    this.enabled,
    this.maxLines,
    this.maxLength,
    this.showClearButton = true,
    this.onChanged,
  });

  @override
  State<SRTextField> createState() => _SRTextFieldState();
}

class _SRTextFieldState extends State<SRTextField> {
  static const _radius = 16.0;

  bool get enabled => widget.enabled ?? true;

  bool showClearButton = false;

  @override
  void initState() {
    super.initState();
    _updateShowClearButton();
  }

  void _updateShowClearButton() {
    setState(() {
      showClearButton = widget.showClearButton &&
          enabled &&
          ((widget.maxLines ?? 1) == 1) &&
          widget.controller.text.isNotEmpty;
    });
  }

  Widget _buildFrame({required Widget child}) {
    var borderRadius = BorderRadius.circular(_radius);
    InputDecorationTheme _theme = InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: enabled,
      fillColor: srTextFieldBackground,
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: srTextFieldBorder,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: borderRadius,
      ),
      focusColor: srCardBackground,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.white,
          strokeAlign: BorderSide.strokeAlignOutside,
          width: 2,
        ),
        borderRadius: borderRadius,
      ),
      hoverColor: srCardBackground,
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: srButtonDisabled,
          strokeAlign: BorderSide.strokeAlignOutside,
          width: 1,
        ),
        borderRadius: borderRadius,
      ),
    );
    return Theme(
      data: ThemeData(inputDecorationTheme: _theme),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFrame(
      child: TextField(
        enabled: enabled,
        controller: widget.controller,
        onChanged: (value) {
          _updateShowClearButton();
          widget.onChanged?.call(value);
        },
        cursorHeight: srTextFieldFontSize,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        style: TextStyle(
          fontSize: srTextFieldFontSize,
          color: enabled ? null : srButtonDisabled,
        ),
        decoration: InputDecoration(
          suffixIconConstraints:
              const BoxConstraints(maxWidth: 30, maxHeight: 30),
          suffixIcon: showClearButton
              ? GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                    _updateShowClearButton();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.cancel,
                      color: srButtonDisabled,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
