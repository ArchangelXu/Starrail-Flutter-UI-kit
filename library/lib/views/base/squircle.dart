import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

export 'package:figma_squircle/figma_squircle.dart' show SmoothRadius;

/// Corner Smoothing: Cupertino Rectangle Border: cornerSmoothing = 60%
enum SmoothBorderAlign {
  inside,
  center,
  outside;

  BorderAlign get value {
    switch (this) {
      case inside:
        return BorderAlign.inside;
      case center:
        return BorderAlign.center;
      case outside:
        return BorderAlign.outside;
    }
  }
}

extension SmoothCornerBorder on SmoothRectangleBorder {
  static SmoothRectangleBorder borderRadius({
    BorderRadius borderRadius = BorderRadius.zero,
    BorderSide side = BorderSide.none,
    // Corner Smoothing
    double cornerSmoothing = 0.6,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothRectangleBorder(
        side: side,
        borderAlign: borderAlign.value,
        borderRadius: SmoothCornerBorderRadius.borderRadius(
          borderRadius: borderRadius,
          cornerSmoothing: cornerSmoothing,
        ),
      );

  static SmoothRectangleBorder circular(
    double radius, {
    BorderSide side = BorderSide.none,
    // Corner Smoothing
    double cornerSmoothing = 0.6,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothRectangleBorder(
        side: side,
        borderAlign: borderAlign.value,
        borderRadius: SmoothCornerBorderRadius.circular(
          radius,
          cornerSmoothing: cornerSmoothing,
        ),
      );

  static SmoothRectangleBorder vertical({
    BorderSide side = BorderSide.none,
    // Corner Smoothing
    SmoothRadius top = SmoothRadius.zero,
    SmoothRadius bottom = SmoothRadius.zero,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothRectangleBorder(
        side: side,
        borderAlign: borderAlign.value,
        borderRadius: SmoothBorderRadius.vertical(top: top, bottom: bottom),
      );

  static SmoothRectangleBorder horizontal({
    BorderSide side = BorderSide.none,
    // Corner Smoothing
    SmoothRadius left = SmoothRadius.zero,
    SmoothRadius right = SmoothRadius.zero,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothRectangleBorder(
        side: side,
        borderAlign: borderAlign.value,
        borderRadius: SmoothBorderRadius.horizontal(left: left, right: right),
      );

  static SmoothRectangleBorder only({
    BorderSide side = BorderSide.none,
    // Corner Smoothing
    SmoothRadius topLeft = SmoothRadius.zero,
    SmoothRadius topRight = SmoothRadius.zero,
    SmoothRadius bottomLeft = SmoothRadius.zero,
    SmoothRadius bottomRight = SmoothRadius.zero,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothRectangleBorder(
        side: side,
        borderAlign: borderAlign.value,
        borderRadius: SmoothBorderRadius.only(
          topLeft: topLeft,
          bottomRight: topRight,
          topRight: topRight,
          bottomLeft: bottomLeft,
        ),
      );
}

extension SmoothCornerBorderRadius on SmoothBorderRadius {
  static SmoothBorderRadius borderRadius({
    BorderRadius borderRadius = BorderRadius.zero,
    double cornerSmoothing = 0.6,
  }) =>
      SmoothBorderRadius.only(
        topLeft: SmoothRadius(
          cornerRadius: borderRadius.topLeft.x,
          cornerSmoothing: cornerSmoothing,
        ),
        topRight: SmoothRadius(
          cornerRadius: borderRadius.topRight.x,
          cornerSmoothing: cornerSmoothing,
        ),
        bottomLeft: SmoothRadius(
          cornerRadius: borderRadius.bottomLeft.x,
          cornerSmoothing: cornerSmoothing,
        ),
        bottomRight: SmoothRadius(
          cornerRadius: borderRadius.bottomRight.x,
          cornerSmoothing: cornerSmoothing,
        ),
      );

  static SmoothBorderRadius circular(
    double radius, {
    double cornerSmoothing = 0.6,
  }) =>
      SmoothBorderRadius.all(
        SmoothCornerRadius.circular(radius, cornerSmoothing: cornerSmoothing),
      );
}

extension SmoothCornerRadius on SmoothRadius {
  static SmoothRadius circular(
    double radius, {
    double cornerSmoothing = 0.6,
  }) =>
      SmoothRadius(cornerRadius: radius, cornerSmoothing: cornerSmoothing);
}

class SmoothCornerClipRRect extends StatelessWidget {
  final Widget? child;
  final Clip clipBehavior;

  // Corner Smoothing
  final SmoothRectangleBorder shape;

  const SmoothCornerClipRRect({
    super.key,
    this.child,
    required this.shape,
    this.clipBehavior = Clip.antiAlias,
  });

  factory SmoothCornerClipRRect.borderRadius({
    Key? key,
    Widget? child,
    BorderRadius borderRadius = BorderRadius.zero,
    BorderSide side = BorderSide.none,
    Clip clipBehavior = Clip.antiAlias,
    // Corner Smoothing
    double cornerSmoothing = 0.6,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothCornerClipRRect(
        key: key,
        shape: SmoothCornerBorder.borderRadius(
          side: side,
          borderAlign: borderAlign,
          borderRadius: borderRadius,
          cornerSmoothing: cornerSmoothing,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  factory SmoothCornerClipRRect.circular({
    Key? key,
    Widget? child,
    double radius = 0,
    BorderSide side = BorderSide.none,
    Clip clipBehavior = Clip.antiAlias,
    // Corner Smoothing
    double cornerSmoothing = 0.6,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothCornerClipRRect(
        key: key,
        shape: SmoothCornerBorder.circular(
          radius,
          cornerSmoothing: cornerSmoothing,
          side: side,
          borderAlign: borderAlign,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  factory SmoothCornerClipRRect.vertical({
    Key? key,
    Widget? child,
    BorderSide side = BorderSide.none,
    Clip clipBehavior = Clip.antiAlias,
    // Corner Smoothing
    SmoothRadius top = SmoothRadius.zero,
    SmoothRadius bottom = SmoothRadius.zero,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothCornerClipRRect(
        key: key,
        shape: SmoothCornerBorder.vertical(
          side: side,
          borderAlign: borderAlign,
          top: top,
          bottom: bottom,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  factory SmoothCornerClipRRect.horizontal({
    Key? key,
    Widget? child,
    BorderSide side = BorderSide.none,
    Clip clipBehavior = Clip.antiAlias,
    // Corner Smoothing
    SmoothRadius left = SmoothRadius.zero,
    SmoothRadius right = SmoothRadius.zero,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothCornerClipRRect(
        key: key,
        shape: SmoothCornerBorder.horizontal(
          left: left,
          right: right,
          side: side,
          borderAlign: borderAlign,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  factory SmoothCornerClipRRect.only({
    Key? key,
    Widget? child,
    BorderSide side = BorderSide.none,
    Clip clipBehavior = Clip.antiAlias,
    // Corner Smoothing
    SmoothRadius topLeft = SmoothRadius.zero,
    SmoothRadius topRight = SmoothRadius.zero,
    SmoothRadius bottomLeft = SmoothRadius.zero,
    SmoothRadius bottomRight = SmoothRadius.zero,
    SmoothBorderAlign borderAlign = SmoothBorderAlign.inside,
  }) =>
      SmoothCornerClipRRect(
        key: key,
        shape: SmoothCornerBorder.only(
          topLeft: topLeft,
          bottomRight: topRight,
          topRight: topRight,
          bottomLeft: bottomLeft,
          side: side,
          borderAlign: borderAlign,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return ClipPath.shape(
      clipBehavior: clipBehavior,
      shape: shape,
      child: child,
    );
  }
}
