import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';
import 'package:starrail_ui/views/base/squircle.dart';

class SRCard extends StatelessWidget {
  final Widget child;

  const SRCard({
    super.key,
    required this.child,
  });

  Widget _buildFrame({Widget? child}) {
    return CustomPaint(
      painter: _Painter(),
      child: Padding(
        padding: const EdgeInsets.only(
          left: srCardFrameOffset,
          bottom: srCardFrameOffset,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: srCardBackground,
            borderRadius: BorderRadius.only(
              topRight: SmoothCornerRadius.circular(srCardCornerRadius),
            ),
            boxShadow: srBoxShadow,
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFrame(child: Container(child: child));
  }
}

class _Painter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = srCardFrameBorder
    ..style = PaintingStyle.stroke
    ..strokeWidth = srCardFrameBorderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(
          rect.left,
          rect.top + srCardFrameOffset,
          rect.right - srCardFrameOffset,
          rect.bottom,
        ),
        topRight: const Radius.circular(srCardCornerRadius),
      ),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Painter;
  }
}
