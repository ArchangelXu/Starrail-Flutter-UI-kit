import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';
import 'package:starrail_ui/views/base/listener.dart';
import 'package:starrail_ui/views/misc/icon.dart';

class SRTabBar extends StatefulWidget implements PreferredSizeWidget {
  static const double _height = 42;
  final List<SRTabBarItem> items;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedForegroundColor;
  final Color? unselectedForegroundColor;
  final bool scroll;
  final TabController tabController;

  const SRTabBar({
    super.key,
    required this.items,
    required this.tabController,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
    this.scroll = false,
  });

  @override
  State<SRTabBar> createState() => _SRTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(_height);
}

class _SRTabBarState extends State<SRTabBar> {
  static const double _overlapSize = 16;

  int get _selected => widget.tabController.index;

  void _onPressTab(int index) {
    widget.tabController.index = index;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.tabController,
      builder: (context, child) {
        List<Widget> widgets;
        if (widget.scroll) {
          widgets = widget.items
              .map(
                (e) {
                  var index = widget.items.indexOf(e);
                  var selected = index == _selected;
                  return [
                    AnimatedSize(
                      duration: srAnimationDuration,
                      curve: srAnimationCurve,
                      clipBehavior: Clip.none,
                      child: selected
                          ? _buildTab(e)
                          : AspectRatio(
                              aspectRatio: 1,
                              child: _buildTab(e),
                            ),
                    ),
                    const SizedBox(width: 6),
                  ];
                },
              )
              .expand((e) => e)
              .toList();
        } else {
          widgets = widget.items
              .map(
                (e) =>
                    [Expanded(child: _buildTab(e)), const SizedBox(width: 6)],
              )
              .expand((e) => e)
              .toList();
          if (widgets.isNotEmpty) {
            widgets.removeLast();
          }
        }
        Widget view;
        if (widget.scroll) {
          view = ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: widgets,
          );
        } else {
          view = Row(children: widgets);
        }
        return SizedBox(height: SRTabBar._height, child: view);
      },
    );
  }

  Widget _buildTab(SRTabBarItem e) {
    var index = widget.items.indexOf(e);
    var selected = index == _selected;
    return GestureDetector(
      onTap: () => _onPressTab(index),
      child: _Container(
        content: _Content(
          item: e,
          selected: selected,
          scroll: widget.scroll,
          selectedColor: widget.selectedForegroundColor,
          unselectedColor: widget.unselectedForegroundColor,
        ),
        scroll: widget.scroll,
        overlapSize: index == widget.items.length - 1 ? 0 : _overlapSize,
        selected: selected,
        selectedColor: widget.selectedBackgroundColor,
        unselectedColor: widget.unselectedBackgroundColor,
      ),
    );
  }
}

class SRTabBarItem {
  final SRIcon? icon;
  final String title;

  SRTabBarItem({
    required this.title,
    this.icon,
  });
}

class _Container extends StatelessWidget {
  final _Content content;
  final bool selected;
  final bool scroll;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double overlapSize;

  const _Container({
    required this.content,
    required this.selected,
    required this.scroll,
    required this.overlapSize,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return SRSelectionAnimatedBuilder(
      selected: selected,
      builder: (context, value, child) => CustomPaint(
        painter: _Painter(
          progress: value,
          scroll: scroll,
          overlapSize: overlapSize,
          foregroundColor: selectedColor,
          backgroundColor: unselectedColor,
        ),
        child: child,
      ),
      child: Center(child: content),
    );
  }
}

class _Painter extends CustomPainter {
  static const double _selectedRadius = 8;
  static const double _unselectedRadius = 5;
  static const double _borderWidth = 1;
  static const double _padding = 2;
  final double progress;
  final double padding;
  final double overlapSize;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool scroll;
  final Paint _paint = Paint();
  final double _radius;

  _Painter({
    required this.progress,
    required this.scroll,
    required this.overlapSize,
    Color? foregroundColor,
    Color? backgroundColor,
  })  : foregroundColor = foregroundColor ?? Colors.white,
        backgroundColor = backgroundColor ?? Colors.black,
        padding = scroll ? 0 : _padding,
        _radius = scroll ? _selectedRadius : _unselectedRadius;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(
      0,
      0,
      size.width + (scroll ? overlapSize : 0),
      size.height,
    );
    canvas.clipRect(
      Rect.fromLTRB(
        rect.left - 200,
        rect.top,
        rect.right + 200,
        rect.bottom,
      ),
      doAntiAlias: false,
    );
    // draw unselected
    Rect drawRect;
    // var curvedProgress = srAnimationCurve.transform(progress);
    var curvedProgress = progress;
    if (curvedProgress < 1) {
      drawRect = Rect.fromLTRB(
        padding,
        padding - _borderWidth,
        rect.width - padding,
        rect.height,
      );
      _paint.style = PaintingStyle.fill;
      _paint.color = backgroundColor;
      var rRect = RRect.fromRectAndCorners(
        drawRect,
        topLeft: Radius.circular(_radius),
        topRight: Radius.circular(_radius),
      );
      canvas.save();
      canvas.translate(0, _borderWidth);
      _drawShadow(canvas, rRect);
      canvas.drawRRect(rRect, _paint);
      _paint.style = PaintingStyle.stroke;
      _paint.color = srHighlighted.withOpacity(0.25);
      _paint.strokeWidth = _borderWidth;
      canvas.drawRRect(rRect, _paint);
      canvas.restore();
    }
    // draw selected
    var rRect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(_selectedRadius),
      topRight: const Radius.circular(_selectedRadius),
    );
    _paint.style = PaintingStyle.fill;
    if (curvedProgress > 0) {
      if (scroll) {
        _paint.color = Color.lerp(
          foregroundColor.withOpacity(0),
          foregroundColor,
          curvedProgress,
        )!;
        if (curvedProgress == 1) {
          _drawShadow(canvas, rRect);
        }
        canvas.drawRRect(rRect, _paint);
      } else {
        canvas.save();
        canvas.translate(0, rect.height * (1 - curvedProgress));
        _paint.color = foregroundColor;
        if (curvedProgress == 1) {
          _drawShadow(canvas, rRect);
        }
        canvas.drawRRect(rRect, _paint);
        canvas.restore();
      }
    }
  }

  void _drawShadow(Canvas canvas, RRect rRect) {
    canvas.save();
    canvas.drawShadow(
      Path()
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(
              rRect.left - 2,
              rRect.top,
              rRect.right + 2,
              rRect.bottom,
            ),
            topLeft: rRect.tlRadius,
            topRight: rRect.trRadius,
            bottomLeft: rRect.blRadius,
            bottomRight: rRect.brRadius,
          ),
        ),
      Colors.black,
      4,
      true,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Painter || oldDelegate.progress != progress;
  }
}

class _Content extends StatelessWidget {
  final SRTabBarItem item;
  final bool selected;
  final bool scroll;
  final Color selectedColor;
  final Color unselectedColor;

  const _Content({
    required this.item,
    required this.selected,
    required this.scroll,
    Color? selectedColor,
    Color? unselectedColor,
  })  : selectedColor = selectedColor ?? srTabForegroundSelected,
        unselectedColor = unselectedColor ?? srTabForegroundUnselected;

  Widget _buildInternal() {
    var color = selected ? selectedColor : unselectedColor;
    if (scroll) {
      Widget icon = _buildIcon(color);
      if (selected) {
        var text = _buildText(color);
        return item.icon != null ? _buildRow(color, text) : text;
      } else {
        return icon;
      }
    } else {
      var text = _buildText(color);
      return item.icon != null ? _buildRow(color, text) : text;
    }
  }

  Row _buildRow(Color color, Text text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(color),
        const SizedBox(width: 8),
        text,
      ],
    );
  }

  Widget _buildIcon(Color color) => item.icon == null
      ? SizedBox.square(
          dimension: 36,
          child: Center(
            child: Text(
              item.title.substring(0, 1),
              style: TextStyle(fontSize: srTabContentTitle, color: color),
            ),
          ),
        )
      : item.icon!.copyWith(color: color, size: 16);

  Text _buildText(Color color) {
    return Text(
      item.title,
      maxLines: 2,
      style: TextStyle(
        fontSize: srTabContentTitle,
        color: color,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: _buildInternal(),
    );
  }
}
