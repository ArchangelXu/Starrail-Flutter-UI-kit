import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';
import 'package:starrail_ui/util/canvas.dart';
import 'package:starrail_ui/views/base/listener.dart';
import 'package:starrail_ui/views/misc/icon.dart';

enum SRButtonHighlightType {
  none(0),
  highlighted(1),
  highlightedPlus(2);

  final int value;

  const SRButtonHighlightType(this.value);
}

class SRButton extends StatelessWidget {
  static const double _minHeight = 32;
  static const double _circularMinSize = 26;
  static const double _iconSize = 14;
  static const _constraints = BoxConstraints(
    minWidth: _minHeight * 3,
    minHeight: _minHeight,
  );
  final Widget child;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final bool expanded;
  final bool circular;
  final Size? circleSize;

  final SRButtonHighlightType highlightType;
  final Color backgroundColor;

  bool get _hasTouchCallback => onPress != null || onLongPress != null;

  factory SRButton.circular({
    Key? key,
    Widget? child,

    /// supports assets path/url/file path
    String? iconPath,
    IconData? iconData,
    Size? size,
    SRButtonHighlightType? highlightType,
    Color? backgroundColor,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
  }) {
    assert(
      highlightType != SRButtonHighlightType.highlightedPlus,
      "Cannot use SRButtonHighlightType.highlightedPlus for circular buttons!",
    );
    assert(
      !(child == null && iconPath == null && iconData == null),
      "Child or iconPath of iconData must be set!",
    );
    assert(
      [child, iconPath, iconData].whereNotNull().length == 1,
      "Only one of child, iconPath and iconData should be set!",
    );
    bool disabled = onPress == null && onLongPress == null;
    SRButton button = SRButton.custom(
      key: key,
      expanded: false,
      circular: true,
      backgroundColor: backgroundColor,
      highlightType: highlightType,
      circleSize: size,
      onPress: onPress,
      onLongPress: onLongPress,
      child: FittedBox(
        child: _buildIcon(
          iconData: iconData,
          iconPath: iconPath,
          disabled: disabled,
          child: child,
        ),
      ),
    );
    return button;
  }

  factory SRButton.text({
    Key? key,
    required String text,
    bool expanded = false,
    SRButtonHighlightType? highlightType,
    Color? backgroundColor,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
  }) {
    Widget child = Text(
      text,
      style: TextStyle(
        fontSize: srButtonTextSize,
        fontWeight: FontWeight.bold,
        color: onPress != null ? null : srButtonDisabled,
        shadows: onPress != null ? null : srTextShadow,
      ),
    );
    SRButton button = SRButton.custom(
      expanded: expanded,
      backgroundColor: backgroundColor,
      highlightType: highlightType,
      key: key,
      onPress: onPress,
      onLongPress: onLongPress,
      child: child,
    );
    return button;
  }

  factory SRButton.custom({
    Key? key,
    required Widget child,
    bool expanded = false,
    bool circular = false,
    Size? circleSize,
    SRButtonHighlightType? highlightType,
    Color? backgroundColor,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
  }) {
    assert(
        !(highlightType != null &&
            highlightType != SRButtonHighlightType.none &&
            backgroundColor != null),
        "Use either backgroundColor or SRButtonHighlightType.highlighted(or "
        "SRButtonHighlightType.highlightedPlus)! Now highlightType= $highlightType, "
        "backgroundColor= $backgroundColor");
    return SRButton._internal(
      key: key,
      expanded: expanded,
      circular: circular,
      circleSize: circleSize,
      backgroundColor: backgroundColor ?? srButtonBackground,
      highlightType: highlightType ?? SRButtonHighlightType.none,
      onPress: onPress,
      onLongPress: onLongPress,
      child: child,
    );
  }

  const SRButton._internal({
    super.key,
    required this.child,
    required this.expanded,
    required this.circular,
    this.circleSize,
    required this.highlightType,
    required this.backgroundColor,
    this.onPress,
    this.onLongPress,
  });

  static Widget _buildIcon({
    String? iconPath,
    IconData? iconData,
    bool disabled = false,
    Widget? child,
  }) {
    return SRIcon(
      color: disabled ? srButtonDisabled : null,
      iconData: iconData,
      iconPath: iconPath,
      child: child,
    );
    // if (child == null) {
    //   Color? color = disabled ? srButtonDisabled : null;
    //   if (iconData != null) {
    //     child = Icon(
    //       iconData,
    //       size: _iconSize,
    //       color: color,
    //     );
    //   } else if ((iconPath != null)) {
    //     bool svg = iconPath.toLowerCase().contains(".svg");
    //     if (iconPath.startsWith("/")) {
    //       //file
    //       File file = File(iconPath);
    //       child = svg
    //           ? SvgPicture.file(
    //               file,
    //               width: _iconSize,
    //               height: _iconSize,
    //               fit: BoxFit.contain,
    //               colorFilter: color == null
    //                   ? null
    //                   : ColorFilter.mode(color, BlendMode.srcIn),
    //             )
    //           : Image.file(
    //               file,
    //               width: _iconSize,
    //               height: _iconSize,
    //               fit: BoxFit.contain,
    //               color: color,
    //             );
    //     } else if (iconPath.startsWith("http")) {
    //       //network
    //       child = svg
    //           ? SvgPicture.network(
    //               iconPath,
    //               width: _iconSize,
    //               height: _iconSize,
    //               fit: BoxFit.contain,
    //               colorFilter: color == null
    //                   ? null
    //                   : ColorFilter.mode(color, BlendMode.srcIn),
    //             )
    //           : Image.network(
    //               iconPath,
    //               width: _iconSize,
    //               height: _iconSize,
    //               fit: BoxFit.contain,
    //               color: color,
    //             );
    //     } else {
    //       //asset
    //       child = svg
    //           ? SvgPicture.asset(
    //               iconPath,
    //               width: _iconSize,
    //               height: _iconSize,
    //               fit: BoxFit.contain,
    //               colorFilter: color == null
    //                   ? null
    //                   : ColorFilter.mode(color, BlendMode.srcIn),
    //             )
    //           : Image.asset(
    //               iconPath,
    //               width: _iconSize,
    //               height: _iconSize,
    //               fit: BoxFit.contain,
    //               color: color,
    //             );
    //     }
    //   }
    // }
    // return child!;
  }

  LinearGradient? _getFrameGradient() {
    if (highlightType == SRButtonHighlightType.highlightedPlus) {
      return srButtonBackgroundHighlightedGradient;
    }
    return null;
  }

  Color? _getFrameBackgroundColor() {
    if (highlightType == SRButtonHighlightType.highlighted) {
      return srButtonBackgroundHighlighted;
    } else if (highlightType == SRButtonHighlightType.none) {
      return backgroundColor;
    }
    return null;
  }

  Widget _buildFrame({required Widget child}) {
    BoxDecoration decoration;
    BoxConstraints? constraints;
    EdgeInsets padding;
    double? width;
    double? height;
    if (circular) {
      decoration = _hasTouchCallback
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: _getFrameBackgroundColor(),
              border: _SRBorder.all(color: srButtonBorder),
              boxShadow: srBoxShadow,
            )
          : BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: srButtonDisabled, width: 1),
            );
      padding = EdgeInsets.zero;
      Size size = circleSize ?? const Size(_circularMinSize, _circularMinSize);
      width = size.width;
      height = size.height;
    } else {
      decoration = _hasTouchCallback
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: _getFrameBackgroundColor(),
              gradient: _getFrameGradient(),
              border: _SRBorder.all(color: srButtonBorder),
              boxShadow: srBoxShadow,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: srButtonDisabled, width: 1),
            );
      constraints = _constraints;
      padding = const EdgeInsets.symmetric(horizontal: _minHeight / 2);
    }
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      constraints: constraints,
      padding: padding,
      child: expanded
          ? Row(
              children: [
                Expanded(child: Center(child: child)),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                child,
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.5),
          child: _buildFrame(child: child),
        ),
        Positioned.fill(
          child: _TouchOverlay(onPress: onPress, onLongPress: onLongPress),
        ),
      ],
    );
  }
}

class _TouchOverlay extends StatefulWidget {
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;

  const _TouchOverlay({required this.onPress, this.onLongPress});

  @override
  State<_TouchOverlay> createState() => _TouchOverlayState();
}

class _TouchOverlayState extends State<_TouchOverlay> with ClickableStateMixin {
  @override
  VoidCallback? get onPress => widget.onPress;

  @override
  VoidCallback? get onLongPress => widget.onLongPress;

  @override
  Widget build(BuildContext context) {
    return SRInteractiveBuilder(
      hoverEnabled: hasCallback,
      touchEnabled: hasCallback,
      builder: (context, hoverProgress, touchProgress) => Container(
        decoration: BoxDecoration(
          color: Color.lerp(
            const Color(0x00000000),
            const Color(0x33000000),
            touchProgress,
          ),
          border: Border.all(
            color: Color.lerp(
              const Color(0x00FFFFFF),
              Colors.white,
              max(touchProgress, hoverProgress),
            )!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: buildGestureDetector(),
      ),
    );
  }
}

class _SRBorder extends Border {
  final double padding = 2.5;

  factory _SRBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1,
    BorderStyle style = BorderStyle.solid,
    double strokeAlign = BorderSide.strokeAlignInside,
  }) {
    final BorderSide side = BorderSide(
      color: color,
      width: width,
      style: style,
      strokeAlign: strokeAlign,
    );
    return _SRBorder.fromBorderSide(side);
  }

  const _SRBorder.fromBorderSide(BorderSide side) : super.fromBorderSide(side);

  static void _paintUniformBorderWithRadius(
    Canvas canvas,
    Rect rect,
    BorderSide side,
    BorderRadius borderRadius,
    double padding,
  ) {
    assert(side.style != BorderStyle.none);
    double dotX = rect.width / 5;
    final Paint paint = Paint()..color = side.color;
    final double width = side.width;
    if (width == 0.0) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.0;
      canvas.drawRRect(borderRadius.toRRect(rect), paint);
    } else {
      final RRect borderRect = borderRadius.toRRect(rect).deflate(padding);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = width;
      paint.strokeCap = StrokeCap.round;

      var radius = borderRect.height / 2;
      canvas.drawPath(
        Path()
          ..moveTo(borderRect.left + radius, borderRect.top)
          ..lineTo(
            borderRect.left + dotX - srButtonBorderNotchSize / 2,
            borderRect.top,
          )
          ..relativeMoveTo(srButtonBorderNotchSize, 0)
          ..lineTo(borderRect.right - radius, borderRect.top)
          ..arcTo(
            Rect.fromLTRB(
              borderRect.right - 2 * radius,
              borderRect.top,
              borderRect.right,
              borderRect.bottom,
            ),
            -pi / 2,
            pi,
            false,
          )
          ..lineTo(borderRect.left + radius, borderRect.bottom)
          ..arcTo(
            Rect.fromLTRB(
              borderRect.left,
              borderRect.top,
              borderRect.left + 2 * radius,
              borderRect.bottom,
            ),
            pi / 2,
            pi,
            false,
          ),
        paint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(borderRect.left + dotX, borderRect.top),
          width: srButtonBorderDotRadius,
          height: srButtonBorderDotRadius,
        ),
        paint,
      );
    }
  }

  static void _paintUniformBorderWithCircle(
    Canvas canvas,
    Rect rect,
    BorderSide side,
    double padding,
  ) {
    assert(side.style != BorderStyle.none);
    final double radius = (rect.shortestSide + side.strokeOffset) / 2 - padding;
    var paint = side.toPaint()..strokeCap = StrokeCap.round;
    // canvas.drawCircle(rect.center, radius, paint);
    var angleBase = 5 * pi / 4;
    var halfAngle = asin((srButtonBorderNotchSize / 2) / radius);
    final Rect borderRect = rect.deflate(padding);
    canvas.centerPivot(rect);
    canvas.rotate(-halfAngle * 3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, -borderRect.height / 2 + srButtonBorderDotRadius),
        width: srButtonBorderDotRadius,
        height: srButtonBorderDotRadius,
      ),
      paint,
    );
    canvas.rotate(halfAngle);
    canvas.drawPath(
      Path()
        ..moveTo(0, -borderRect.height / 2 + srButtonBorderDotRadius)
        ..arcTo(
          Rect.fromCenter(
            center: const Offset(0, 0),
            width: radius * 2,
            height: radius * 2,
          ),
          -pi / 2,
          2 * pi - halfAngle * 2,
          false,
        ),
      paint,
    );
    canvas.rotate(halfAngle - (2 * pi - angleBase));
    canvas.resetPivot(rect);
  }

  static void _paintUniformBorderWithRectangle(
    Canvas canvas,
    Rect rect,
    BorderSide side,
  ) {
    assert(side.style != BorderStyle.none);
    canvas.drawRect(rect.inflate(side.strokeOffset / 2), side.toPaint());
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(
                borderRadius == null,
                'A borderRadius cannot be given when shape is a BoxShape.circle.',
              );
              _paintUniformBorderWithCircle(
                canvas,
                rect,
                top,
                padding,
              );
            case BoxShape.rectangle:
              if (borderRadius != null && borderRadius != BorderRadius.zero) {
                _paintUniformBorderWithRadius(
                  canvas,
                  rect,
                  top,
                  borderRadius,
                  padding,
                );
                return;
              }
              _paintUniformBorderWithRectangle(canvas, rect, top);
          }
          return;
      }
    }
  }
}
