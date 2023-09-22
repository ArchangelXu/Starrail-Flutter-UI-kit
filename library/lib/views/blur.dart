import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/views/base/squircle.dart';

class Blurred extends StatelessWidget {
  final Widget? child;
  final double blurSigma;
  final double borderRadius;

  const Blurred({
    super.key,
    this.blurSigma = 8,
    this.borderRadius = 0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (blurSigma == 0) {
      if (borderRadius == 0) {
        return child ?? const SizedBox.shrink();
      } else {
        return ClipSmoothRect(
          radius: SmoothCornerBorderRadius.circular(borderRadius),
          child: child ?? const SizedBox.shrink(),
        );
      }
    } else {
      var blurred = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: child,
      );
      if (borderRadius == 0) {
        return ClipRect(child: blurred);
      } else {
        return ClipSmoothRect(
          radius: SmoothCornerBorderRadius.circular(borderRadius),
          child: blurred,
        );
      }
    }
  }
}
