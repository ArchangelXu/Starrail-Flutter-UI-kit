import 'dart:math';

import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';
import 'package:starrail_ui/views/blur.dart';
import 'package:starrail_ui/views/buttons/close.dart';
import 'package:starrail_ui/views/card.dart';
import 'package:starrail_ui/views/misc/scroll.dart';
import 'package:starrail_ui/views/progress/circular.dart';

class SRDialog extends StatelessWidget {
  final Widget child;
  final BoxConstraints? constraints;

  static Future<T?> showMessage<T>({
    required BuildContext context,
    String? title,
    required String message,
  }) {
    return showCustom(
      context: context,
      dialog: SRDialog.message(
        context: context,
        message: message,
        title: title,
      ),
    );
  }

  static Future<T?> showCustom<T>({
    required BuildContext context,
    required SRDialog dialog,
  }) {
    return _showBlurBackgroundDialog<T>(
      context: context,
      builder: (context) => dialog,
    );
  }

  static void showLoading({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) => const Center(child: SRLoading()),
    );
  }

  static Future<T?> _showBlurBackgroundDialog<T>({
    required BuildContext context,
    bool allowDismiss = true,
    required Widget Function(BuildContext context) builder,
  }) {
    //use WillPopScope to prevent dismiss dialog by pressing
    //back button on Android devices
    return showGeneralDialog<T>(
      context: context,
      barrierLabel: "",
      barrierDismissible: allowDismiss,
      barrierColor: Colors.black.withOpacity(0.25),
      pageBuilder: (ctx, anim1, anim2) => WillPopScope(
        child: LayoutBuilder(
          builder: (context, constraints) {
            var width = min(
                  constraints.maxWidth,
                  MediaQuery.of(context).size.width,
                ) -
                48 * 2;
            return SizedBox(width: width, child: builder(context));
          },
        ),
        onWillPop: () => Future.value(allowDismiss),
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        var value = anim1.value;
        value = Curves.easeInOut.transform(value);
        return Blurred(
          blurSigma: 24 * value,
          child: Transform.translate(
            offset: Offset(0, -8 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          ),
          // child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  factory SRDialog.message({
    Key? key,
    required BuildContext context,
    String? title,
    required String message,
  }) {
    return SRDialog.custom(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SRDialogTitleRow(
                  showCloseButton: true,
                  showDivider: title != null,
                  title: title,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (constraints.maxHeight) * 3 / 4,
                  ),
                  child: _buildMessageRow(message),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  factory SRDialog.custom({
    Key? key,
    required Widget child,
    BoxConstraints? constraints,
  }) {
    return SRDialog._internal(
      key: key,
      constraints: constraints,
      child: child,
    );
  }

  const SRDialog._internal({
    super.key,
    required this.child,
    this.constraints,
  });

  static Widget _buildMessageRow(String message) {
    return SRScrollView(
      children: [
        Text(
          message,
          style: const TextStyle(fontSize: srDialogMessageSize),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DialogContainer(
      constraints: constraints,
      child: SRCard(child: child),
    );
  }
}

class SRDialogTitleRow extends StatelessWidget {
  final String? title;
  final bool showCloseButton;
  final bool showDivider;

  const SRDialogTitleRow({
    super.key,
    this.title,
    required this.showCloseButton,
    required this.showDivider,
  });

  Widget _buildCloseButton(BuildContext context) => showCloseButton
      ? SRCloseButton(
          onPress: () => Navigator.of(context).pop(),
        )
      : const SizedBox.shrink();

  Widget _buildTitleRow(BuildContext context, String? title) {
    return title == null
        ? Row(
            children: [
              const Spacer(),
              _buildCloseButton(context),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: srDialogTitleSize),
                  textAlign: TextAlign.left,
                ),
              ),
              _buildCloseButton(context),
            ],
          );
  }

  Widget _buildTitleRowDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        height: srDialogTitleRowDividerWidth,
        color: srCardTitleRowDivider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitleRow(context, title),
        if (showDivider) _buildTitleRowDivider(),
      ],
    );
  }
}

class _DialogContainer extends StatelessWidget {
  static const _landscapeOuterPadding = 48;
  static const _portraitOuterPadding = 24;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final BorderRadiusGeometry? borderRadius;

  const _DialogContainer({
    Key? key,
    required this.child,
    this.padding,
    this.constraints,
    this.borderRadius,
  }) : super(key: key);

  ({double bottomPadding, double maxWidth, double maxHeight}) _getConstraints(
    BuildContext context,
  ) {
    final MediaQueryData? data = MediaQuery.maybeOf(context);
    double bottomPadding = 0;
    bool landscape = data?.orientation == Orientation.landscape;
    int padding =
        (landscape ? _landscapeOuterPadding : _portraitOuterPadding) * 2;
    double maxWidth = landscape ? 640 : 360;
    double maxHeight = landscape ? 320 : 540;
    if (constraints != null) {
      maxWidth = constraints!.maxWidth;
      maxHeight = constraints!.maxHeight;
    }
    if (data != null) {
      if (data.viewInsets.bottom > 0) {
        bottomPadding = data.viewInsets.bottom;
      }
      if (maxWidth >= data.size.width - padding) {
        maxWidth = data.size.width - padding;
      }
      if (maxHeight >= data.size.height - padding) {
        maxHeight = data.size.height - padding;
      }
    }
    return (
      bottomPadding: bottomPadding,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _getConstraints(context);
    final bottomPadding = data.bottomPadding;
    final maxWidth = data.maxWidth;
    final maxHeight = data.maxHeight;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: bottomPadding),
          padding: padding,
          width: maxWidth,
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: child,
        ),
      ),
    );
  }
}
