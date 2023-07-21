import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';

enum SRButtonHighlightType {
  none(0),
  highlighted(1),
  highlightedPlus(2);

  final int value;

  const SRButtonHighlightType(this.value);
}

class SRButton extends StatelessWidget {
  static const double _minHeight = 48;
  static const double _circularMinSize = 40;
  static const _constraints = BoxConstraints(
    minWidth: _minHeight * 3,
    minHeight: _minHeight,
  );
  final Widget child;
  final VoidCallback? onTap;
  final bool expanded;
  final bool circular;
  final Size? circleSize;

  final SRButtonHighlightType highlightType;
  final Color backgroundColor;

  // SRButton.text({
  //   super.key,
  //   required String text,
  //   this.expanded = false,
  //   this.highlightType = SRButtonHighlightType.none,
  //   Color? backgroundColor,
  //   this.onTap,
  // })  : assert((highlightType != SRButtonHighlightType.none) ^
  //           (backgroundColor != null)),
  //       child = Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           color: onTap != null ? null : const Color(0x33FFFFFF),
  //           shadows: onTap != null ? null : defaultTextShadow,
  //         ),
  //       );

  factory SRButton.circular({
    Key? key,
    required Widget child,
    Size? size,
    SRButtonHighlightType? highlightType,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    assert(
      !(highlightType == SRButtonHighlightType.highlightedPlus),
      "Cannot use SRButtonHighlightType.highlightedPlus for circular buttons!",
    );
    SRButton button = SRButton.custom(
      key: key,
      expanded: false,
      circular: true,
      backgroundColor: backgroundColor,
      highlightType: highlightType,
      circleSize: size,
      onTap: onTap,
      child: FittedBox(child: child),
    );
    return button;
  }

  factory SRButton.text({
    Key? key,
    required String text,
    bool expanded = false,
    SRButtonHighlightType? highlightType,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    Widget child = Text(
      text,
      style: TextStyle(
        fontSize: srButtonTextSize,
        fontWeight: FontWeight.bold,
        color: onTap != null ? null : const Color(0x33FFFFFF),
        shadows: onTap != null ? null : defaultTextShadow,
      ),
    );
    SRButton button = SRButton.custom(
      expanded: expanded,
      onTap: onTap,
      backgroundColor: backgroundColor,
      highlightType: highlightType,
      key: key,
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
    VoidCallback? onTap,
  }) {
    assert(
        !(highlightType != null &&
            highlightType != SRButtonHighlightType.none &&
            backgroundColor != null),
        "Use either backgroundColor or SRButtonHighlightType.highlighted(or "
        "SRButtonHighlightType.highlightedPlus)! Now highlightType= $highlightType, "
        "backgroundColor= $backgroundColor");
    SRButton button = SRButton._internal(
      key: key,
      expanded: expanded,
      circular: circular,
      circleSize: circleSize,
      backgroundColor: backgroundColor ?? srButtonBackground,
      highlightType: highlightType ?? SRButtonHighlightType.none,
      onTap: onTap,
      child: child,
    );
    return button;
  }

  const SRButton._internal({
    super.key,
    required this.child,
    required this.expanded,
    required this.circular,
    this.circleSize,
    required this.highlightType,
    required this.backgroundColor,
    this.onTap,
  });

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
      decoration = onTap != null
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: _getFrameBackgroundColor(),
              border: _SRBorder.all(color: srButtonBorder),
              boxShadow: defaultBoxShadow,
            )
          : BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x1AFFFFFF), width: 1.5),
            );
      padding = const EdgeInsets.all(8);
      Size size = circleSize ?? Size(_circularMinSize, _circularMinSize);
      width = size.width;
      height = size.height;
    } else {
      decoration = onTap != null
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: _getFrameBackgroundColor(),
              gradient: _getFrameGradient(),
              border: _SRBorder.all(color: srButtonBorder),
              boxShadow: defaultBoxShadow,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0x1AFFFFFF), width: 1.5),
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
          padding: const EdgeInsets.all(1),
          child: _buildFrame(child: child),
        ),
        Positioned.fill(child: _TouchOverlay(onTap: onTap)),
      ],
    );
  }
}

class _TouchOverlay extends StatefulWidget {
  final VoidCallback? onTap;

  const _TouchOverlay({required this.onTap});

  @override
  State<_TouchOverlay> createState() => _TouchOverlayState();
}

class _TouchOverlayState extends State<_TouchOverlay> {
  bool _touched = false;

  void _onTapDown() {
    if (widget.onTap == null) {
      return;
    }
    setState(() {
      _touched = true;
    });
  }

  void _onTapUp() {
    if (widget.onTap == null) {
      return;
    }
    setState(() {
      _touched = false;
    });
  }

  void _onTap() {
    widget.onTap?.call();
  }

  // void _onGestureTapDown(TapDownDetails details) {
  //   if (widget.onTapDown != null) {
  //     widget.onTapDown?.call(details);
  //   }
  // }

  // void _onLongPress() {
  //   if (!widget.disabled && widget.onLongPress != null) {
  //     _onHapticFeedback();
  //     widget.onLongPress?.call();
  //   }
  // }

  Widget _buildGesture() {
    return GestureDetector(
      onTap: _onTap,
      // onTapDown: _onGestureTapDown,
      // onLongPress: _onLongPress,
      behavior: HitTestBehavior.opaque,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _touched ? 1 : 0,
      duration: defaultAnimationDuration,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x33000000),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Listener(
          onPointerDown: (v) => _onTapDown(),
          onPointerUp: (v) => _onTapUp(),
          onPointerCancel: (v) => _onTapUp(),
          child: _buildGesture(),
        ),
      ),
    );
  }
}

class _SRBorder extends Border {
  final double padding = 4.5;

  factory _SRBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.5,
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
    canvas.save();
    canvas.translate(rect.left + rect.width / 2, rect.top + rect.height / 2);
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
            center: Offset(0, 0),
            width: radius * 2,
            height: radius * 2,
          ),
          -pi / 2,
          2 * pi - halfAngle * 2,
          false,
        ),
      paint,
    );

    canvas.translate(
      -(rect.left + rect.width / 2),
      -(rect.top + rect.height / 2),
    );
    canvas.rotate(halfAngle - (2 * pi - angleBase));
    canvas.restore();
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
