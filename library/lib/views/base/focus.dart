import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:rxdart/rxdart.dart';

class FocusAwareBuilder extends StatefulWidget {
  final Widget Function(bool isForeground) builder;

  const FocusAwareBuilder({super.key, required this.builder});

  @override
  State<FocusAwareBuilder> createState() => _FocusAwareBuilderState();
}

class _FocusAwareBuilderState extends State<FocusAwareBuilder> {
  final _isForeground = BehaviorSubject<bool>.seeded(true);

  @override
  void dispose() {
    _isForeground.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () {
        // _isForeground.add(false);
      },
      onFocusGained: () {
        // _isForeground.add(true);
      },
      child: StreamBuilder(
        stream: _isForeground,
        builder: (context, snapshot) {
          return widget.builder(_isForeground.value);
        },
      ),
    );
  }
}
