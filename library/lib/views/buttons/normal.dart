import 'dart:math';
import 'dart:ui';

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

class SRButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final bool expanded;
  final bool circular;
  final Size? circleSize;
  final SRButtonHighlightType highlightType;
  final Color backgroundColor;

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
        color: onPress != null ? srButtonText : srButtonDisabled,
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
    !(highlightType != null && highlightType != SRButtonHighlightType.none && backgroundColor != null),
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
  }

  @override
  State<SRButton> createState() => _SRButtonState();
}

class _SRButtonState extends State<SRButton> with TickerProviderStateMixin, ClickableStateMixin {
  static const double _minHeight = 32;
  static const double _circularMinSize = 26;
  static const _constraints = BoxConstraints(
    minWidth: _minHeight * 3,
    minHeight: _minHeight,
  );
  Stream? _repaintStream;
  ValueNotifier<int>? _repaint;
  List<_HighlightDot>? _highlightDots;

  @override
  VoidCallback? get onPress => widget.onPress;

  @override
  VoidCallback? get onLongPress => widget.onLongPress;

  @override
  void initState() {
    super.initState();
    if (widget.highlightType != SRButtonHighlightType.none) {
      _repaintStream = Stream.periodic(const Duration(milliseconds: 1000 ~/ 60));
      _repaint = ValueNotifier(0);
      _highlightDots = [];
    }
  }

  @override
  void dispose() {
    _repaint?.dispose();
    super.dispose();
  }

  Widget _buildCustomPaint(double hoverProgress, double touchProgress) {
    BoxConstraints? constraints;
    EdgeInsets padding;
    double? width;
    double? height;
    if (widget.circular) {
      padding = EdgeInsets.zero;
      Size size = widget.circleSize ?? const Size(_circularMinSize, _circularMinSize);
      width = size.width;
      height = size.height;
    } else {
      constraints = _constraints;
      padding = const EdgeInsets.symmetric(horizontal: _minHeight * 2 / 3);
    }
    return RepaintBoundary(
      child: CustomPaint(
        painter: _Painter(
          enabled: hasCallback,
          repaint: _repaint,
          dots: _highlightDots,
          hoverProgress: hoverProgress,
          touchProgress: touchProgress,
          highlightType: widget.highlightType,
          backgroundColor: widget.backgroundColor,
        ),
        child: buildGestureDetector(
          child: Container(
            width: width,
            height: height,
            constraints: constraints,
            padding: padding,
            child: widget.expanded
                ? Row(
              children: [Expanded(child: Center(child: widget.child))],
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [widget.child],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SRInteractiveBuilder(
      hoverEnabled: hasCallback,
      touchEnabled: hasCallback,
      builder: (context, hoverProgress, touchProgress) {
        if (widget.highlightType != SRButtonHighlightType.none) {
          return StreamBuilder(
            stream: _repaintStream,
            builder: (context, snapshot) {
              if (widget.highlightType != SRButtonHighlightType.none) {
                _repaint?.value = DateTime.now().millisecondsSinceEpoch;
              }
              return _buildCustomPaint(hoverProgress, touchProgress);
            },
          );
        }
        return _buildCustomPaint(hoverProgress, touchProgress);
      },
    );
  }
}

class _Painter extends CustomPainter {
  static const double _borderNotchSize = 5.5;
  static const double _borderDotRadius = 0.5;
  static const Color _borderColor = Color(0x35000000);
  static const double _highlightDotMaxTranslationPerSecond = 48;
  static const double _highlightDotMinTranslationPerSecond = 16;
  static const double _highlightDotMaxVisibleMilliseconds = 5000;
  static const double _highlightDotMinVisibleMilliseconds = 2000;
  static const int _highlightDotMaxCount = 10;
  final double padding = 2.5;
  final bool enabled;
  final double hoverProgress;
  final double touchProgress;
  final Color backgroundColor;
  final SRButtonHighlightType highlightType;
  final List<_HighlightDot>? dots;

  _Painter({
    required this.enabled,
    required this.hoverProgress,
    required this.touchProgress,
    required this.backgroundColor,
    required this.highlightType,
    this.dots,
    Listenable? repaint,
  }) : super(repaint: repaint);

  Color? _getFrameBackgroundColor() {
    if (highlightType == SRButtonHighlightType.highlighted) {
      return srButtonBackgroundHighlighted;
    } else if (highlightType == SRButtonHighlightType.none) {
      return backgroundColor;
    }

    return null;
  }

  void _drawBackground(Canvas canvas, Rect rect) {
    var radius = Radius.circular(rect.height / 2);
    var paint = Paint();
    if (enabled) {
      paint.style = PaintingStyle.fill;
      Color? frameBackgroundColor = _getFrameBackgroundColor();
      if (frameBackgroundColor != null) {
        paint.color = frameBackgroundColor;
      } else {
        paint.shader = srButtonBackgroundHighlightedGradient.createShader(rect);
      }
    } else {
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;
      paint.color = srButtonDisabled;
    }
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: radius,
        topLeft: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint,
    );
  }

  void _drawDecoration(Canvas canvas, Rect rect) {
    if (!enabled) {
      return;
    }
    if (rect.width == rect.height) {
      //circular
      final double radius = rect.shortestSide / 2 - padding;
      var paint = Paint();
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;
      paint.color = _borderColor;
      paint.strokeCap = StrokeCap.round;
      // canvas.drawCircle(rect.center, radius, paint);
      var angleBase = 5 * pi / 4;
      var halfAngle = asin((_borderNotchSize / 2) / radius);
      final Rect borderRect = rect.deflate(padding);
      canvas.centerPivot(rect);
      canvas.rotate(-halfAngle * 3);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -borderRect.height / 2 + _borderDotRadius),
          width: _borderDotRadius,
          height: _borderDotRadius,
        ),
        paint,
      );
      canvas.rotate(halfAngle);
      canvas.drawPath(
        Path()
          ..moveTo(0, -borderRect.height / 2 + _borderDotRadius)
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
    } else {
      var corner = Radius.circular(rect.height / 2);
      double dotX = rect.width / 5;
      var borderRect = RRect.fromRectAndCorners(
        rect,
        topRight: corner,
        topLeft: corner,
        bottomLeft: corner,
        bottomRight: corner,
      ).deflate(padding);
      Paint paint = Paint();
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;
      paint.strokeCap = StrokeCap.round;
      paint.color = _borderColor;
      var radius = borderRect.height / 2;
      canvas.drawPath(
        Path()
          ..moveTo(borderRect.left + radius, borderRect.top)
          ..lineTo(
            borderRect.left + dotX - _borderNotchSize / 2,
            borderRect.top,
          )
          ..relativeMoveTo(_borderNotchSize, 0)
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
          width: _borderDotRadius,
          height: _borderDotRadius,
        ),
        paint,
      );
    }
  }

  void _drawHover(Canvas canvas, Rect rect) {
    var progress = max(hoverProgress, touchProgress);
    if (progress > 0) {
      Paint paint = Paint();
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;
      var hoverColor = Colors.white;
      paint.color = Color.lerp(hoverColor.withOpacity(0), hoverColor, progress)!;
      var inflated = rect.inflate(0.5);
      var radius = Radius.circular(inflated.height / 2);
      var rRect = RRect.fromRectAndCorners(
        inflated,
        topRight: radius,
        topLeft: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );
      canvas.drawRRect(rRect, paint);
    }
  }

  void _drawTouch(Canvas canvas, Rect rect) {
    if (touchProgress > 0) {
      Paint paint = Paint();
      paint.style = PaintingStyle.fill;
      var touchColor = Colors.black;
      paint.color = Color.lerp(
        touchColor.withOpacity(0),
        touchColor.withOpacity(0.2),
        touchProgress,
      )!;
      var inflated = rect.inflate(0.5);
      var radius = Radius.circular(inflated.height / 2);
      var rRect = RRect.fromRectAndCorners(
        inflated,
        topRight: radius,
        topLeft: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );
      canvas.drawRRect(rRect, paint);
    }
  }

  void _drawShadow(Canvas canvas, Rect rect) {
    if (!enabled) {
      return;
    }
    var radius = Radius.circular(rect.height / 2);
    canvas.drawShadow(
      Path()
        ..addRRect(
          RRect.fromLTRBAndCorners(
            rect.left,
            rect.top,
            rect.right,
            rect.bottom,
            topRight: radius,
            topLeft: radius,
            bottomLeft: radius,
            bottomRight: radius,
          ),
        ),
      Colors.black.withOpacity(0.5),
      2,
      true,
    );
  }

  void _drawHighlight(Canvas canvas, Rect rect) {
    List<_HighlightDot>? dotList = dots;
    if (highlightType == SRButtonHighlightType.none || dotList == null) {
      return;
    }
    var paint = Paint();
    var radius = Radius.circular(rect.height / 2);
    var rRect = RRect.fromRectAndCorners(
      rect,
      topRight: radius,
      topLeft: radius,
      bottomLeft: radius,
      bottomRight: radius,
    );
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    if (dotList.length < _highlightDotMaxCount) {
      dotList.add(_HighlightDot(rect));
    }
    for (int i = dotList.length - 1; i >= 0; i--) {
      var dot = dotList[i];
      dot._update();
      if (dot.progress == 1) {
        dotList.removeAt(i);
        continue;
      }
      paint.color = Colors.white.withOpacity(dot.currentOpacity);
      var location = dot.currentLocation;
      if (rRect.contains(location)) {
        canvas.drawPoints(PointMode.points, [location], paint);
      } else {
        dotList.removeAt(i);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    _drawShadow(canvas, rect);
    _drawBackground(canvas, rect);
    _drawDecoration(canvas, rect);
    _drawHighlight(canvas, rect);
    _drawTouch(canvas, rect);
    _drawHover(canvas, rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Painter ||
        oldDelegate.enabled != enabled ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.hoverProgress != hoverProgress ||
        oldDelegate.touchProgress != touchProgress ||
        oldDelegate.dots != dots;
  }
}

class _HighlightDot {
  late Offset startLocation;
  late int startTimestamp;
  late double speed;
  late int totalTime;
  late double progress;

  Offset get currentLocation => startLocation.translate(-speed * progress, 0);

  double get currentOpacity => Curves.easeInOutSine.transform(-2 * (progress - 0.5).abs() + 1);

  _HighlightDot(Rect rect) {
    var random = Random();
    startLocation = Offset(
      rect.left + random.nextDouble() * rect.width,
      rect.top + random.nextDouble() * rect.height,
    );
    startTimestamp = DateTime.now().millisecondsSinceEpoch;
    speed = _Painter._highlightDotMinTranslationPerSecond +
        random.nextDouble() *
            (_Painter._highlightDotMaxTranslationPerSecond - _Painter._highlightDotMinTranslationPerSecond);
    totalTime = (_Painter._highlightDotMinVisibleMilliseconds +
        random.nextDouble() *
            (_Painter._highlightDotMaxVisibleMilliseconds - _Painter._highlightDotMinVisibleMilliseconds))
        .toInt();
    progress = 0;
  }

  void _update() {
    progress = min(
      1,
      (DateTime.now().millisecondsSinceEpoch - startTimestamp) / totalTime,
    );
  }
}
