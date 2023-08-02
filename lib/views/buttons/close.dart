import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/util/canvas.dart';
import 'package:starrail_ui/views/base/listener.dart';

class SRCloseButton extends StatefulWidget {
  final double strokeWidth = 2;
  final Color? color;
  final VoidCallback? onPress;

  const SRCloseButton({super.key, this.color, this.onPress});

  @override
  State<SRCloseButton> createState() => _SRCloseButtonState();
}

class _SRCloseButtonState extends State<SRCloseButton>
    with ClickableStateMixin, SingleTickerProviderStateMixin {
  @override
  VoidCallback? get onLongPress => null;

  @override
  VoidCallback? get onPress => widget.onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 20,
      child: SRInteractiveBuilder(
        builder: (context, hoverProgress, touchProgress) => CustomPaint(
          painter: _Painter(
            color: widget.color,
            hoverProgress: hoverProgress,
            touchProgress: touchProgress,
            strokeWidth: widget.strokeWidth,
          ),
          child: buildGestureDetector(),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  static const _centerOvalRadius = 1.5;
  static const _centerOvalSpacing = 4.0;
  static const _range = -0.5;
  final double hoverProgress;
  final double touchProgress;
  final double strokeWidth;
  final Paint p = Paint();
  late final double _distance;

  _Painter({
    Color? color,
    Color pressedColor = srHighlighted,
    required this.hoverProgress,
    required this.touchProgress,
    required this.strokeWidth,
  }) {
    p.style = PaintingStyle.stroke;
    p.color = Color.lerp(color ?? Colors.black, pressedColor, touchProgress)!;
    p.strokeWidth = strokeWidth;
    _distance = sqrt(_centerOvalRadius + _centerOvalSpacing);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.centerPivot(rect);
    p.style = PaintingStyle.stroke;
    var interactiveProgress =
        (_range * hoverProgress - 1) * (1 - touchProgress);
    var translate = _distance * interactiveProgress;
    var scale = -interactiveProgress;
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        //start (center)
        Offset(
          0 + translate,
          0 + translate,
        ),
        //end (edge)
        Offset(
          -rect.width / 2 + translate,
          -rect.height / 2 + translate,
        ),
        p,
      );
      canvas.rotate(pi / 2);
    }
    p.style = PaintingStyle.fill;
    var size2 = _centerOvalRadius * 2 * scale;
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0, 0),
        width: size2,
        height: size2,
      ),
      p,
    );
    canvas.resetPivot(rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Painter ||
        oldDelegate.hoverProgress != hoverProgress ||
        oldDelegate.touchProgress != touchProgress;
  }
}
