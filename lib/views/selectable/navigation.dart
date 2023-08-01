import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/util/canvas.dart';
import 'package:starrail_ui/views/base/listener.dart';
import 'package:starrail_ui/views/misc/icon.dart';

class SRNavigationBar extends StatefulWidget {
  static const double _thickness = 56;
  static const double _spacing = 8;
  static const double _lineThickness = 1;
  final bool scroll;
  final bool dark;
  final Axis direction;
  final double thickness;
  final double spacing;
  final int initialSelectedIndex;
  final ValueChanged<int>? onChanged;
  final List<SRIcon Function(Color color, double size)> iconBuilders;

  factory SRNavigationBar.auto({
    Key? key,
    required BuildContext context,
    required Axis direction,
    bool? scroll,
    double? spacing,
    double? thickness,
    int? initialSelectedIndex,
    required List<SRIcon Function(Color color, double size)> iconBuilders,
    ValueChanged<int>? onChanged,
  }) {
    return Theme.of(context).brightness == Brightness.dark
        ? SRNavigationBar.dark(
            key: key,
            scroll: scroll,
            direction: direction,
            spacing: spacing,
            thickness: thickness,
            initialSelectedIndex: initialSelectedIndex,
            iconBuilders: iconBuilders,
            onChanged: onChanged,
          )
        : SRNavigationBar.light(
            key: key,
            scroll: scroll,
            direction: direction,
            spacing: spacing,
            thickness: thickness,
            initialSelectedIndex: initialSelectedIndex,
            iconBuilders: iconBuilders,
            onChanged: onChanged,
          );
  }

  factory SRNavigationBar.light({
    Key? key,
    bool? scroll,
    double? spacing,
    double? thickness,
    required Axis direction,
    required List<SRIcon Function(Color color, double size)> iconBuilders,
    ValueChanged<int>? onChanged,
    int? initialSelectedIndex,
  }) {
    return SRNavigationBar._internal(
      key: key,
      direction: direction,
      scroll: scroll ?? false,
      spacing: spacing ?? _spacing,
      thickness: thickness ?? _thickness,
      dark: false,
      initialSelectedIndex: initialSelectedIndex ?? 0,
      iconBuilders: iconBuilders,
      onChanged: onChanged,
    );
  }

  factory SRNavigationBar.dark({
    Key? key,
    bool? scroll,
    double? spacing,
    double? thickness,
    required Axis direction,
    required List<SRIcon Function(Color color, double size)> iconBuilders,
    ValueChanged<int>? onChanged,
    int? initialSelectedIndex,
  }) {
    return SRNavigationBar._internal(
      key: key,
      direction: direction,
      scroll: scroll ?? false,
      spacing: spacing ?? _spacing,
      thickness: thickness ?? _thickness,
      dark: true,
      initialSelectedIndex: initialSelectedIndex ?? 0,
      iconBuilders: iconBuilders,
      onChanged: onChanged,
    );
  }

  const SRNavigationBar._internal({
    super.key,
    required this.scroll,
    required this.direction,
    required this.dark,
    required this.thickness,
    required this.spacing,
    required this.iconBuilders,
    required this.initialSelectedIndex,
    this.onChanged,
  });

  @override
  State<SRNavigationBar> createState() => _SRNavigationBarState();
}

class _SRNavigationBarState extends State<SRNavigationBar> {
  late int _selectedIndex;
  ScrollController? _scrollController;

  Color get lineColor =>
      widget.dark ? srNavigationBarLineDark : srNavigationBarLineLight;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
    if (widget.scroll) {
      _scrollController = ScrollController();
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  List<Widget> _buildItems() {
    return widget.iconBuilders.map(
      (e) {
        var index = widget.iconBuilders.indexOf(e);
        if (widget.dark) {
          return SRNavigationBarItem.dark(
            selected: index == _selectedIndex,
            iconBuilder: e,
            onPress: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onChanged?.call(index);
            },
          );
        } else {
          return SRNavigationBarItem.light(
            selected: index == _selectedIndex,
            iconBuilder: e,
            onPress: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onChanged?.call(index);
            },
          );
        }
      },
    ).toList();
  }

  List<Widget> _buildCutoutItems() {
    double lineThickness = 1;
    double itemSize = _SRNavigationBarItemState._size;
    return widget.iconBuilders
        .map(
          (e) => SizedBox.square(
            dimension: itemSize,
            child: Padding(
              padding: EdgeInsets.all(_SRNavigationBarItemState._padding),
              child: Center(
                child: Container(
                  // must not be transparent
                  color: Colors.black,
                  width: widget.direction == Axis.vertical
                      ? lineThickness
                      : itemSize,
                  height: widget.direction == Axis.horizontal
                      ? lineThickness
                      : itemSize,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _applyDirectionOnItems(List<Widget> items) {
    List<Widget> widgets;
    Widget child;
    if (widget.scroll) {
      widgets = items
          .map((e) => [e, SizedBox.square(dimension: widget.spacing)])
          .expand((e) => e)
          .toList()
        ..removeLast();
      if (widget.direction == Axis.horizontal) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        );
      } else {
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        );
      }
    } else {
      widgets = items.map((e) => Expanded(child: Center(child: e))).toList();

      if (widget.direction == Axis.horizontal) {
        child = Row(
          children: widgets,
        );
      } else {
        child = Column(
          children: widgets,
        );
      }
    }
    return child;
  }

  Widget _buildForeground() {
    List<Widget> items = _buildItems();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return _applyDirectionOnItems(items);
  }

  Widget _buildBackground() {
    List<Widget> items = _buildCutoutItems();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    // return Positioned.fill(
    //   child: _applyDirectionOnItems(items),
    // );
    return Positioned.fill(
      child: _Cutout(color: lineColor, child: _applyDirectionOnItems(items)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget stack = Stack(
      children: [
        _buildBackground(),
        _buildForeground(),
      ],
    );
    if (widget.scroll) {
      stack = Center(
        child: SingleChildScrollView(
          scrollDirection: widget.direction,
          child: stack,
        ),
      );
    }
    return SizedBox(
      width: widget.direction == Axis.horizontal ? null : widget.thickness,
      height: widget.direction == Axis.vertical ? null : widget.thickness,
      child: stack,
    );
  }
}

class SRNavigationBarItem extends StatefulWidget {
  final bool selected;
  final VoidCallback? onPress;
  final SRIcon Function(Color color, double size) iconBuilder;

  final Color unselectedBackgroundColor;
  final Color selectedBackgroundColor;
  final Color unselectedIconColor;
  final Color selectedIconColor;
  final Color borderColor;

  factory SRNavigationBarItem.auto({
    Key? key,
    required BuildContext context,
    required bool selected,
    VoidCallback? onPress,
    required SRIcon Function(Color color, double size) iconBuilder,
  }) {
    return Theme.of(context).brightness == Brightness.dark
        ? SRNavigationBarItem.dark(
            key: key,
            selected: selected,
            onPress: onPress,
            iconBuilder: iconBuilder,
          )
        : SRNavigationBarItem.light(
            key: key,
            selected: selected,
            onPress: onPress,
            iconBuilder: iconBuilder,
          );
  }

  factory SRNavigationBarItem.light({
    Key? key,
    required bool selected,
    VoidCallback? onPress,
    required SRIcon Function(Color color, double size) iconBuilder,
  }) {
    return SRNavigationBarItem(
      selected: selected,
      onPress: onPress,
      iconBuilder: iconBuilder,
      unselectedBackgroundColor: srNavigationBarItemUnselectedBackgroundLight,
      selectedBackgroundColor: srNavigationBarItemSelectedBackgroundLight,
      borderColor: srNavigationBarItemBorderLight,
      unselectedIconColor: srNavigationBarItemIconUnselectedLight,
      selectedIconColor: srNavigationBarItemIconSelectedLight,
    );
  }

  factory SRNavigationBarItem.dark({
    Key? key,
    required bool selected,
    VoidCallback? onPress,
    required SRIcon Function(Color color, double size) iconBuilder,
  }) {
    return SRNavigationBarItem(
      selected: selected,
      onPress: onPress,
      iconBuilder: iconBuilder,
      unselectedBackgroundColor: srNavigationBarItemUnselectedBackgroundDark,
      selectedBackgroundColor: srNavigationBarItemSelectedBackgroundDark,
      borderColor: srNavigationBarItemBorderDark,
      unselectedIconColor: srNavigationBarItemIconUnselectedDark,
      selectedIconColor: srNavigationBarItemIconSelectedDark,
    );
  }

  const SRNavigationBarItem({
    super.key,
    required this.iconBuilder,
    required this.selected,
    required this.unselectedBackgroundColor,
    required this.selectedBackgroundColor,
    required this.borderColor,
    required this.unselectedIconColor,
    required this.selectedIconColor,
    this.onPress,
  });

  @override
  State<SRNavigationBarItem> createState() => _SRNavigationBarItemState();
}

class _SRNavigationBarItemState extends State<SRNavigationBarItem>
    with SingleTickerProviderStateMixin, ClickableStateMixin {
  static const double _size = 48;
  static const double _padding = _size / 8;
  late final Animation<double> _selectionAnimation;
  late final AnimationController _selectionAnimationController;

  @override
  VoidCallback? get onLongPress => null;

  @override
  VoidCallback? get onPress => widget.onPress;

  @override
  void initState() {
    super.initState();
    _selectionAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _selectionAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_selectionAnimationController);
    _updateSelectionController();
  }

  @override
  void dispose() {
    _selectionAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SRNavigationBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectionController();
  }

  void _updateSelectionController() {
    if (widget.selected) {
      _selectionAnimationController.forward();
    } else {
      _selectionAnimationController.reset();
    }
  }

  // SRLoopAnimatedBuilder _buildSpinning() {
  //   return SRLoopAnimatedBuilder(
  //     enabled: widget.selected,
  //     duration: const Duration(seconds: 12),
  //     builder: (context, value) {
  //       return Transform.rotate(
  //         angle: 2 * pi * value,
  //         child: _buildPainter(),
  //       );
  //     },
  //   );
  // }

  SRInteractiveBuilder _buildPainter() {
    return SRInteractiveBuilder(
      builder: (context, hoverProgress, touchProgress) {
        return SRLoopAnimatedBuilder(
          enabled: widget.selected || touchProgress > 0,
          duration: const Duration(seconds: 12),
          builder: (context, value) {
            return Transform.rotate(
              angle: 2 * pi * value,
              child: AnimatedBuilder(
                animation: _selectionAnimation,
                builder: (BuildContext context, Widget? child) {
                  return CustomPaint(
                    painter: _BarItemPainter(
                      progress: _selectionAnimationController.value,
                      hoverProgress: hoverProgress,
                      touchProgress: touchProgress,
                      padding: _padding,
                      borderColor: widget.borderColor,
                      selectedBackgroundColor: widget.selectedBackgroundColor,
                      unselectedBackgroundColor:
                          widget.unselectedBackgroundColor,
                    ),
                    child: child,
                  );
                },
                child: buildGestureDetector(),
              ),
            );
          },
        );
      },
    );
  }

  Positioned _buildIcon() {
    var color =
        widget.selected ? widget.selectedIconColor : widget.unselectedIconColor;
    return Positioned.fill(
      child: IgnorePointer(
        child: widget.iconBuilder.call(color, _size / 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.square(dimension: _size, child: _buildPainter()),
        _buildIcon(),
      ],
    );
  }
}

class _Cutout extends StatelessWidget {
  const _Cutout({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcOut,
      shaderCallback: (bounds) =>
          LinearGradient(colors: [color], stops: const [0.0])
              .createShader(bounds),
      child: child,
    );
  }
}

class _BarItemPainter extends CustomPainter {
  /// radius of bigger dot
  static const double _biggerDotRadius = 1.5;

  /// radius of small dot
  static const double _smallDotRadius = 0.5;

  /// define how many small dots there should be. (total 30*2 dots for 48dp)
  static const double _dotCountPerRadiusDp = 30 / (48 - _biggerDotRadius * 2);

  final double progress;
  final double hoverProgress;
  final double touchProgress;
  final double padding;
  final Color unselectedBackgroundColor;
  final Color selectedBackgroundColor;
  final Color borderColor;
  final Paint _paint = Paint();

  _BarItemPainter({
    required this.progress,
    required this.hoverProgress,
    required this.touchProgress,
    required this.padding,
    required this.unselectedBackgroundColor,
    required this.selectedBackgroundColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.centerPivot(rect);
    // draw background
    Rect drawRect = Rect.fromCenter(
      center: Offset.zero,
      width: rect.width - padding * 2,
      height: rect.height - padding * 2,
    );
    _paint.color = Color.lerp(
      unselectedBackgroundColor,
      selectedBackgroundColor,
      progress,
    )!;
    _paint.style = PaintingStyle.fill;
    Color? currentBorderColor;
    canvas.drawOval(drawRect, _paint);
    if (progress > 0) {
      // draw border
      currentBorderColor = _paint.color =
          Color.lerp(borderColor.withOpacity(0), borderColor, progress)!;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = 1;
      canvas.drawOval(drawRect, _paint);
      if (progress < 1) {
        // draw shimmer
        var centerRect = Rect.fromCenter(
          center: Offset.zero,
          width: rect.width - padding * 2,
          height: rect.height - padding * 2,
        );
        drawRect = Rect.fromCenter(
          center: Offset.zero,
          width: centerRect.width / 2,
          height: centerRect.height,
        );
        var shimmerAngle = pi / 6;
        var distance = drawRect.width / 2 -
            (centerRect.width) +
            (drawRect.width + centerRect.width) * progress;
        canvas.saveLayer(centerRect, Paint());
        canvas.clipPath(
          Path()..addOval(centerRect),
          doAntiAlias: false,
        );
        canvas.rotate(-shimmerAngle);
        canvas.translate(distance, 0);
        _paint.style = PaintingStyle.fill;
        _paint.color = srHighlightedPlus;

        canvas.drawRect(drawRect, _paint);
        canvas.rotate(shimmerAngle);
        canvas.restore();
      }
      _paint.style = PaintingStyle.fill;
      _paint.color = borderColor;
      // draw bigger dot 1
      drawRect = Rect.fromCenter(
        center: Offset(0, -rect.height / 2 + _biggerDotRadius),
        width: _biggerDotRadius * 2,
        height: _biggerDotRadius * 2,
      );
      canvas.drawOval(drawRect, _paint);
      // draw small dots
      var dotCount = (size.width * _dotCountPerRadiusDp).toInt();
      var paddingAngle = asin(_biggerDotRadius * 2 / (rect.width / 2));
      var angle = (pi - paddingAngle * 2) / (dotCount + 1);
      int count = (dotCount * progress).toInt();
      var totalAngle = angle * count;
      canvas.rotate(paddingAngle);
      _drawDots(size, canvas, rect, count, angle);
      canvas.rotate(pi - paddingAngle - totalAngle);
      // draw bigger dot 2
      canvas.drawOval(drawRect, _paint);
      canvas.rotate(paddingAngle);
      // draw small dots
      _drawDots(size, canvas, rect, count, angle);
      canvas.rotate(pi - paddingAngle - totalAngle);
    }
    double interactProgress = max(hoverProgress, touchProgress);
    if (progress == 0 && interactProgress > 0) {
      // draw hover effect
      drawRect = Rect.fromCenter(
        center: Offset.zero,
        width: rect.width - padding * 2,
        height: rect.height - padding * 2,
      );
      _paint.color = Color.lerp(
        currentBorderColor ?? srHighlightedPlus.withOpacity(0),
        srHighlightedPlus.withOpacity(0.75),
        interactProgress,
      )!;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = 1;
      canvas.drawOval(drawRect, _paint);

      if (touchProgress > 0) {
        // draw touch effect
        _paint.color = srHighlightedPlus;
        _paint.style = PaintingStyle.stroke;
        _paint.strokeWidth = _biggerDotRadius * 2;
        drawRect = Rect.fromCenter(
          center: Offset.zero,
          width: rect.width - _paint.strokeWidth / 2,
          height: rect.height - _paint.strokeWidth / 2,
        );
        var sweepAngle = pi * 5 / 6 * touchProgress;
        canvas.drawArc(drawRect, 0, -sweepAngle, false, _paint);
        canvas.rotate(pi);
        canvas.drawArc(drawRect, 0, -sweepAngle, false, _paint);
      }
    }

    canvas.resetPivot(rect);
  }

  void _drawDots(Size size, Canvas canvas, Rect rect, int count, double angle) {
    for (int i = 0; i < count; i++) {
      canvas.rotate(angle);
      var rect2 = Rect.fromCenter(
        center: Offset(0, -rect.height / 2 + _biggerDotRadius),
        width: _smallDotRadius * 2,
        height: _smallDotRadius * 2,
      );
      canvas.drawOval(rect2, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _BarItemPainter ||
        oldDelegate.progress != progress ||
        oldDelegate.hoverProgress != hoverProgress ||
        oldDelegate.touchProgress != touchProgress;
  }
}
