import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';

class SRLoopAnimatedBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, double value) builder;
  final Duration duration;
  final bool enabled;

  const SRLoopAnimatedBuilder({
    super.key,
    required this.duration,
    required this.builder,
    this.enabled = true,
  });

  @override
  State<SRLoopAnimatedBuilder> createState() => _SRLoopAnimatedBuilderState();
}

class _SRLoopAnimatedBuilderState extends State<SRLoopAnimatedBuilder>
    with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    if (widget.enabled) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SRLoopAnimatedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled) {
      _animationController.repeat();
    } else {
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) => widget.builder(
        context,
        _animation.value,
      ),
    );
  }
}

class SRInteractiveBuilder extends StatefulWidget {
  final bool hoverEnabled;
  final bool touchEnabled;
  final Widget Function(
    BuildContext context,
    double hoverProgress,
    double touchProgress,
  ) builder;

  const SRInteractiveBuilder({
    super.key,
    this.hoverEnabled = true,
    this.touchEnabled = true,
    required this.builder,
  });

  @override
  State<SRInteractiveBuilder> createState() => _SRInteractiveBuilderState();
}

class _SRInteractiveBuilderState extends State<SRInteractiveBuilder>
    with TouchableStateMixin, HoverableStateMixin, TickerProviderStateMixin {
  late final Animation<double> _touchAnimation;
  late final Animation<double> _hoverAnimation;
  late final AnimationController _touchController;
  late final AnimationController _hoverController;

  @override
  bool get hoverEnabled => widget.hoverEnabled;

  @override
  bool get touchEnabled => widget.touchEnabled;

  @override
  void initState() {
    super.initState();
    _touchController =
        AnimationController(duration: srAnimationDuration, vsync: this);
    _touchAnimation = Tween(begin: 0.0, end: 1.0).animate(_touchController);
    _hoverController =
        AnimationController(duration: srAnimationDuration, vsync: this);
    _hoverAnimation = Tween(begin: 0.0, end: 1.0).animate(_hoverController);
  }

  @override
  void dispose() {
    _touchController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  void onTapDown() {
    super.onTapDown();
    _touchController.forward();
  }

  @override
  void onTapUp() {
    super.onTapUp();
    _touchController.reverse();
  }

  @override
  void onHoverStart() {
    super.onHoverStart();
    _hoverController.forward();
  }

  @override
  void onHoverEnd() {
    super.onHoverEnd();
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return buildHoverable(
      child: buildTouchable(
        child: AnimatedBuilder(
          animation: _touchAnimation,
          builder: (BuildContext context, Widget? child) => AnimatedBuilder(
            animation: _hoverAnimation,
            builder: (context, child) => widget.builder(
              context,
              _hoverAnimation.value,
              _touchAnimation.value,
            ),
          ),
        ),
      ),
    );
  }
}

mixin TouchableStateMixin<T extends StatefulWidget> on State<T> {
  bool get touchEnabled;

  bool touched = false;

  void onTapDown() {}

  void onTapUp() {}

  void _onTapDown() {
    if (!touchEnabled) {
      return;
    }
    onTapDown();
    setState(() {
      touched = true;
    });
  }

  void _onTapUp() {
    if (!touchEnabled) {
      return;
    }
    onTapUp();
    setState(() {
      touched = false;
    });
  }

  // void _onGestureTapDown(TapDownDetails details) {
  //   if (widget.onTapDown != null) {
  //     widget.onTapDown?.call(details);
  //   }
  // }

  // void _onLongPress() {
  //   if (!widget.disabled && widget.onLongPress != null) {
  //     _onHapticFeedback();
  //     widget.onLongPress?.call();
  //   }
  // }

  // Widget buildGesture() {
  //   return Listener(
  //     onPointerDown: (v) => _onTapDown(),
  //     onPointerUp: (v) => _onTapUp(),
  //     onPointerCancel: (v) => _onTapUp(),
  //     child: GestureDetector(
  //       onTap: _onPress,
  //       onLongPress: _onLongPress,
  //       behavior: HitTestBehavior.opaque,
  //     ),
  //   );
  // }
  Widget buildTouchable({Widget? child}) {
    return Listener(
      onPointerDown: (v) => _onTapDown(),
      onPointerUp: (v) => _onTapUp(),
      onPointerCancel: (v) => _onTapUp(),
      child: child,
    );
  }
}
mixin HoverableStateMixin<T extends StatefulWidget> on State<T> {
  bool get hoverEnabled;

  bool hovered = false;

  void onHoverStart() {}

  void onHoverEnd() {}

  void _onHoverStart() {
    if (!hoverEnabled) {
      return;
    }
    onHoverStart();
    setState(() {
      hovered = true;
    });
  }

  void _onHoverEnd() {
    if (!hoverEnabled) {
      return;
    }
    onHoverEnd();
    setState(() {
      hovered = false;
    });
  }

  Widget buildHoverable({Widget? child}) {
    return MouseRegion(
      onEnter: (e) => _onHoverStart(),
      onExit: (e) => _onHoverEnd(),
      child: child,
    );
  }
}

mixin ClickableStateMixin<T extends StatefulWidget> on State<T> {
  bool get hasCallback => onPress != null || onLongPress != null;

  VoidCallback? get onPress;

  VoidCallback? get onLongPress;

  Widget buildGestureDetector({Widget? child}) {
    return GestureDetector(
      onTap: onPress,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
