import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';
import 'package:starrail_ui/views/base/squircle.dart';
import 'package:universal_io/io.dart';

class SRTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLines;
  final int? maxLength;
  final bool? enabled;
  final String? hint;
  final Color? selectionColor;
  final bool showClearButton;
  final ValueChanged<String>? onChanged;

  SRTextField({
    super.key,
    required this.controller,
    FocusNode? focusNode,
    this.enabled,
    this.maxLines,
    this.maxLength,
    this.hint,
    this.selectionColor,
    this.showClearButton = true,
    this.onChanged,
  }) : focusNode = focusNode ?? FocusNode();

  @override
  State<SRTextField> createState() => _SRTextFieldState();
}

class _SRTextFieldState extends State<SRTextField> {
  static const _radius = 16.0;
  static const _fillColor = srTextFieldBackground;
  static final _fillColorFocused = Color.alphaBlend(
    Colors.black.withOpacity(0.05),
    srTextFieldBackground,
  );

  final _focused = BehaviorSubject<bool>.seeded(false);

  bool get enabled => widget.enabled ?? true;

  bool showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
    _updateShowClearButton();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    _focused.add(widget.focusNode.hasFocus);
  }

  void _updateShowClearButton() {
    setState(() {
      showClearButton = widget.showClearButton &&
          enabled &&
          ((widget.maxLines ?? 1) == 1) &&
          widget.controller.text.isNotEmpty;
    });
  }

  BorderRadius get _borderRadius {
    var borderRadius = (widget.maxLines ?? 1) > 1
        ? BorderRadius.zero
        : SmoothCornerBorderRadius.circular(_radius);
    return borderRadius;
  }

  OutlineInputBorder get _normalBorder {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: srTextFieldBorder,
        strokeAlign: BorderSide.strokeAlignOutside,
        width: 1,
      ),
      borderRadius: _borderRadius,
    );
  }

  OutlineInputBorder get _focusedBorder {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: srHighlighted,
        strokeAlign: BorderSide.strokeAlignOutside,
        width: 2,
      ),
      borderRadius: _borderRadius,
    );
  }

  OutlineInputBorder get _disabledBorder {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: srButtonDisabled,
        strokeAlign: BorderSide.strokeAlignOutside,
        width: 1,
      ),
      borderRadius: _borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(textSelectionTheme: srTextSelectionThemeData),
      child: StreamBuilder(
        stream: _focused,
        builder: (context, snapshot) {
          var focused = _focused.value;
          return TextField(
            enabled: enabled,
            controller: widget.controller,
            focusNode: widget.focusNode,
            selectionControls: _CustomColorSelectionHandle(
                widget.selectionColor ?? srHighlighted),
            onChanged: (value) {
              _updateShowClearButton();
              widget.onChanged?.call(value);
            },
            cursorColor: srHighlighted,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            style: TextStyle(
              fontSize: srTextFieldFontSize,
              color: enabled ? srTextFieldText : srButtonDisabled,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: enabled,
              fillColor: focused ? _fillColorFocused : _fillColor,
              border: _normalBorder,
              focusedBorder: _focusedBorder,
              hoverColor: Colors.black.withOpacity(0.05),
              disabledBorder: _disabledBorder,
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: srTextFieldFontSize,
                color: (enabled ? srTextFieldText : srButtonDisabled)
                    .withOpacity(0.25),
              ),
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
          );
        },
      ),
    );
  }
}

/// workaround until this is fixed: https://github.com/flutter/flutter/issues/74890
class _CustomColorSelectionHandle extends TextSelectionControls {
  _CustomColorSelectionHandle(this.handleColor)
      : _controls = Platform.isIOS
            ? cupertinoTextSelectionControls
            : materialTextSelectionControls;

  final Color handleColor;
  final TextSelectionControls _controls;

  /// Wrap the given handle builder with the needed theme data for
  /// each platform to modify the color.
  Widget _wrapWithThemeData(Widget Function(BuildContext) builder) =>
      Platform.isIOS
          // ios handle uses the CupertinoTheme primary color, so override that.
          ? CupertinoTheme(
              data: CupertinoThemeData(primaryColor: handleColor),
              child: Builder(builder: builder))
          // material handle uses the selection handle color, so override that.
          : TextSelectionTheme(
              data: TextSelectionThemeData(selectionHandleColor: handleColor),
              child: Builder(builder: builder));

  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap]) {
    return _wrapWithThemeData((BuildContext context) =>
        _controls.buildHandle(context, type, textLineHeight, onTap));
  }

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ValueListenable<ClipboardStatus>? clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    return _controls.buildToolbar(
      context,
      globalEditableRegion,
      textLineHeight,
      selectionMidpoint,
      endpoints,
      delegate,
      clipboardStatus,
      lastSecondaryTapDownPosition,
    );
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return _controls.getHandleAnchor(type, textLineHeight);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return _controls.getHandleSize(textLineHeight);
  }
}
