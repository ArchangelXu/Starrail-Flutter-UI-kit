import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/util/canvas.dart';

class SRSlider extends StatelessWidget {
  final double value;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const SRSlider({
    super.key,
    required this.value,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(sliderTheme: srSliderThemeData),
      child: Slider(
        divisions: divisions,
        max: 1,
        min: 0,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class SRSliderValueIndicatorShape extends SliderComponentShape {
  static const _radius = 7.0;
  static const _strokeWidth = 2.5;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(_radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation.value * 0.2 + 1;
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor ?? srHighlighted
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;
    var rect = Rect.fromCenter(
      center: center,
      width: _radius * 2 * 0.9,
      height: _radius * 2 * 0.9,
    );
    canvas.drawShadow(
      Path()..addOval(rect),
      const Color(0x80000000),
      2,
      true,
    );
    canvas.centerPivot(rect);
    canvas.scale(scale);
    canvas.drawCircle(Offset.zero, _radius - _strokeWidth, fillPaint);
    canvas.drawCircle(Offset.zero, _radius - _strokeWidth, borderPaint);
    canvas.scale(1 / scale);
    canvas.resetPivot(rect);
  }
}
