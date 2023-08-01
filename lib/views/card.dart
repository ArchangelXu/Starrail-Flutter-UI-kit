import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';

class SRCard extends StatelessWidget {
  final Widget child;

  const SRCard({
    super.key,
    required this.child,
  });

  Widget _buildFrame({Widget? child}) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          top: srCardFrameOffset,
          right: srCardFrameOffset,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: srCardFrameBorder,
                width: srCardFrameBorderWidth,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(srCardCornerRadius),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: srCardFrameOffset,
            bottom: srCardFrameOffset,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: srCardBackground,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(srCardCornerRadius),
              ),
              boxShadow: srBoxShadow,
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFrame(child: Container(child: child));
  }
}
