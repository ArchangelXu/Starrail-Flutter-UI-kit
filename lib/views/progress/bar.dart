import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';

class SRProgressBar2 extends StatelessWidget {
  final double progress;
  final Color foregroundColor;
  final Color backgroundColor;
  final String Function(double progress)? labelBuilder;

  SRProgressBar2({
    super.key,
    required double progress,
    this.labelBuilder,
    Color? foregroundColor,
    Color? backgroundColor,
  })  : progress = clampDouble(progress, 0, 1),
        foregroundColor = foregroundColor ?? srProgressBarForeground,
        backgroundColor = backgroundColor ?? Colors.black;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.fromHeight(13),
      painter: _Painter(
        foreground: foregroundColor,
        background: backgroundColor,
        progress: progress,
        label: labelBuilder?.call(progress),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  static const _strokeWidth = 1.5;
  static const _fontSize = 11.0;
  final Color foreground;
  final Color background;
  final double progress;
  final String? label;
  final Paint p = Paint();

  _Painter({
    required this.foreground,
    required this.background,
    required this.progress,
    this.label,
  }) {
    p.style = PaintingStyle.fill;
    p.strokeWidth = _strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    p.color = background;
    // draw background
    var rrect = RRect.fromRectAndRadius(rect, const Radius.circular(100));
    canvas.drawRRect(rrect, p);
    // draw foreground
    p.color = foreground;
    rrect = rrect.deflate(_strokeWidth);
    var foregroundRect = Rect.fromLTWH(
      rrect.left,
      rrect.top,
      rrect.width * progress,
      rrect.height,
    );
    canvas.saveLayer(foregroundRect, p);
    canvas.drawRRect(rrect, p);
    canvas.restore();
    if (label != null && label!.trim().isNotEmpty) {
      // draw label
      var span = TextSpan(
        text: label,
        style: const TextStyle(fontSize: _fontSize, color: Colors.black),
      );
      var tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      var tpRect = Rect.fromCenter(
        center: rect.center,
        width: tp.width,
        height: tp.height,
      );
      if (foregroundRect.left <= tpRect.left &&
          foregroundRect.right >= tpRect.right) {
        // covered label
        tp.text = TextSpan(
          text: label,
          style: TextStyle(fontSize: _fontSize, color: background),
        );
        tp.markNeedsLayout();
        tp.layout();
        tp.paint(
          canvas,
          rect.center.translate(-tpRect.width / 2, -tpRect.height / 2),
        );
      } else if (foregroundRect.right >= tpRect.left) {
        // paint left part
        canvas.saveLayer(foregroundRect, Paint()..color = Colors.black);
        tp.text = TextSpan(
          text: label,
          style: TextStyle(fontSize: _fontSize, color: background),
        );
        tp.markNeedsLayout();
        tp.layout();
        tp.paint(
          canvas,
          rect.center.translate(-tpRect.width / 2, -tpRect.height / 2),
        );
        canvas.restore();
        // paint right part
        var rightRect = Rect.fromLTWH(
          foregroundRect.right,
          rrect.top,
          rrect.right,
          rrect.height,
        );
        canvas.saveLayer(
          rightRect,
          Paint()..color = Colors.black,
        );
        canvas.clipRect(rightRect, doAntiAlias: false);
        tp.text = TextSpan(
          text: label,
          style: TextStyle(fontSize: _fontSize, color: foreground),
        );
        tp.markNeedsLayout();
        tp.layout();
        tp.paint(
          canvas,
          rect.center.translate(-tpRect.width / 2, -tpRect.height / 2),
        );
        canvas.restore();
      } else {
        tp.text = TextSpan(
          text: label,
          style: TextStyle(fontSize: _fontSize, color: foreground),
        );
        tp.markNeedsLayout();
        tp.layout();
        tp.paint(
          canvas,
          rect.center.translate(-tpRect.width / 2, -tpRect.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Painter ||
        oldDelegate.progress != progress ||
        oldDelegate.label != label;
  }
}
