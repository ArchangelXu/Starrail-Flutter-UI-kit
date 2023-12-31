import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/dimens.dart';
import 'package:starrail_ui/views/base/listener.dart';

class SRScrollView extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  const SRScrollView({
    super.key,
    required this.children,
    this.padding,
    this.controller,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding2 = const EdgeInsetsDirectional.symmetric(
      vertical: srScrollbarFadeLength,
    );
    if (padding != null) {
      padding2 = padding2.add(padding!);
    }
    return SRScrollbar(
      controller: controller,
      direction: direction,
      child: children.length == 1
          ? SingleChildScrollView(
              scrollDirection: direction,
              padding: padding2,
              physics: const BouncingScrollPhysics(),
              primary: controller == null,
              controller: controller,
              child: children[0],
            )
          : ListView(
              scrollDirection: direction,
              padding: padding2,
              physics: const BouncingScrollPhysics(),
              primary: controller == null,
              controller: controller,
              children: children,
            ),
    );
  }
}

class SRScrollbar extends StatelessWidget {
  static const _fadeLength = srScrollbarFadeLength;
  final ScrollController? controller;
  final Axis direction;
  final Widget child;

  const SRScrollbar({
    super.key,
    required this.child,
    required this.direction,
    this.controller,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          double size = direction == Axis.vertical
              ? constraints.maxHeight
              : constraints.maxWidth;
          double stop = _fadeLength / size;
          return SRInteractiveBuilder(
            builder: (context, hoverProgress, touchProgress) => RawScrollbar(
              controller: controller,
              radius: Radius.zero,
              padding: EdgeInsets.symmetric(
                horizontal: direction == Axis.vertical ? 0 : _fadeLength,
                vertical: direction == Axis.horizontal ? 0 : _fadeLength,
              ),
              trackVisibility: true,
              trackColor: const Color(0x1A000000),
              thumbVisibility: true,
              thickness: srScrollbarThickness,
              thumbColor: Color.lerp(
                const Color(0x66000000),
                const Color(0x80000000),
                max(hoverProgress, touchProgress),
              ),
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: direction == Axis.vertical
                        ? Alignment.topCenter
                        : Alignment.centerLeft,
                    end: direction == Axis.vertical
                        ? Alignment.bottomCenter
                        : Alignment.centerRight,
                    colors: const [
                      Colors.black,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black,
                    ],
                    stops: [
                      0.0,
                      stop,
                      1 - stop,
                      1.0,
                    ], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                // blendMode: BlendMode.srcOver,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: srScrollbarThickness * 2),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      );
}
