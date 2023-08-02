import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starrail_ui/util/canvas.dart';

class SRLoading extends StatefulWidget {
  const SRLoading({super.key});

  @override
  State<SRLoading> createState() => _SRLoadingState();
}

class _SRLoadingState extends State<SRLoading> with TickerProviderStateMixin {
  static const double _interval = 0.25;
  static const int _rotationDuration = 8000;
  static const int _flashDuration = _rotationDuration ~/ 4;
  final ElasticOutCurve _overshotCurve = const ElasticOutCurve(0.8);
  late final Animation<double> _outerRotationAnimation;
  late final Animation<double> _innerRotationAnimation;
  late final Animation<double> _outerFlashAnimation;
  late final Animation<double> _innerFlashAnimation;
  late final AnimationController _outerRotationAnimationController;
  late final AnimationController _innerRotationAnimationController;
  late final AnimationController _outerFlashAnimationController;
  late final AnimationController _innerFlashAnimationController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void dispose() {
    _outerRotationAnimationController.dispose();
    _innerRotationAnimationController.dispose();
    _outerFlashAnimationController.dispose();
    _innerFlashAnimationController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _outerRotationAnimationController = AnimationController(
      duration: const Duration(milliseconds: _rotationDuration),
      vsync: this,
    );
    _innerRotationAnimationController = AnimationController(
      duration: const Duration(milliseconds: _rotationDuration),
      vsync: this,
    );
    _outerFlashAnimationController = AnimationController(
      duration: const Duration(milliseconds: _flashDuration),
      vsync: this,
    );
    _innerFlashAnimationController = AnimationController(
      duration: const Duration(milliseconds: _flashDuration),
      vsync: this,
    );
    double current = 0.0;
    List<TweenSequenceItem<double>> items = [];
    for (int i = 0; i < 4; i++) {
      var end = current + _interval;
      items.add(
        TweenSequenceItem(tween: Tween(begin: current, end: end), weight: 1),
      );
      items.add(
        TweenSequenceItem(tween: Tween(begin: end, end: end), weight: 1),
      );
      current += _interval;
    }
    _outerRotationAnimation =
        TweenSequence<double>(items).animate(_outerRotationAnimationController);
    _innerRotationAnimation =
        TweenSequence<double>(items).animate(_innerRotationAnimationController);
    _outerFlashAnimation =
        Tween(begin: 0.0, end: 2.0).animate(_outerFlashAnimationController);
    _innerFlashAnimation =
        Tween(begin: 0.0, end: 2.0).animate(_innerFlashAnimationController);
    _outerRotationAnimationController.repeat();
    _outerFlashAnimationController.repeat();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        _innerRotationAnimationController.repeat();
        _innerFlashAnimationController.repeat();
      },
    );
  }

  double _computeRotationProgress(double progress) {
    var frag = (progress % _interval);
    return progress -
        frag +
        _interval * _overshotCurve.transform(frag / _interval);
  }

  Widget _buildOuterDots() {
    return SizedBox.square(
      dimension: 90,
      child: AnimatedBuilder(
        animation: _outerFlashAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _Painter(
              progress: _outerFlashAnimation.value,
              radius: 13 / 2,
              borderWidth: 1,
              color: Colors.white,
              flashTimes: 7,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInnerDots() {
    return Center(
      child: SizedBox.square(
        dimension: 75,
        child: AnimatedBuilder(
          animation: _innerRotationAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: -pi / 4 -
                  pi *
                      2 *
                      _computeRotationProgress(
                        _innerRotationAnimation.value,
                      ),
              child: AnimatedBuilder(
                animation: _innerFlashAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _Painter(
                      progress: _innerFlashAnimation.value,
                      radius: 4 / 2,
                      borderWidth: 0.5,
                      color: Colors.white,
                      flashTimes: 7,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _outerRotationAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle:
              -pi * 2 * _computeRotationProgress(_outerRotationAnimation.value),
          child: Stack(
            children: [
              _buildOuterDots(),
              Positioned.fill(
                child: _buildInnerDots(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Painter extends CustomPainter {
  static const double _borderOpacity = 0.75;
  static const double _dotAnimationTotalProgress = 0.5;
  static const double _dotAnimationOffset = _dotAnimationTotalProgress / 2;

  /// 1:[0,0.25), 2:[0,0.5), 3:[0.25,0.75), 4:[0.5,1)
  final double progress;
  final double radius;
  final double borderWidth;
  final Color color;
  final int flashTimes;
  final Paint _paint = Paint();

  _Painter({
    required this.progress,
    required this.radius,
    required this.borderWidth,
    required this.color,
    required this.flashTimes,
  }) {
    _paint.strokeWidth = borderWidth;
  }

  void _drawDot({
    required Canvas canvas,
    required Rect rect,
    required Offset dotProgressRange,
    required bool drawBorder,
  }) {
    if (drawBorder) {
      _paint.color = color.withOpacity(_borderOpacity);
      _paint.style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(0, -rect.width / 2 + radius), radius, _paint);
    }
    var end = dotProgressRange.dy;
    var start = dotProgressRange.dx;
    if (progress >= start && progress < end) {
      _paint.style = PaintingStyle.fill;
      var center = (start + end) / 2;
      var opacity = -(progress - center).abs() / (end - center) + 1;
      _paint.color = color.withOpacity(opacity);
      canvas.drawCircle(Offset(0, -rect.width / 2 + radius), radius, _paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.centerPivot(rect);
    var dx = 0.0;
    Offset range = Offset(dx, dx + _dotAnimationTotalProgress);
    for (int i = 0; i < max(4, flashTimes); i++) {
      _drawDot(
        canvas: canvas,
        rect: rect,
        dotProgressRange: range,
        drawBorder: i < 4,
      );
      canvas.rotate(-pi / 2);
      range = range.translate(_dotAnimationOffset, _dotAnimationOffset);
    }
    canvas.resetPivot(rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Painter || oldDelegate.progress != progress;
  }
}
