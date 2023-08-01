import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/theme/dimens.dart';
import 'package:starrail_ui/views/buttons/close.dart';
import 'package:starrail_ui/views/card.dart';
import 'package:starrail_ui/views/misc/scroll.dart';

class SRDialog extends StatelessWidget {
  final Widget child;

  static void showMessage({
    required BuildContext context,
    String? title,
    required String message,
  }) {
    showCustom(
      context: context,
      dialog: SRDialog.message(
        context: context,
        message: message,
        title: title,
      ),
    );
  }

  static void showCustom({
    required BuildContext context,
    required SRDialog dialog,
  }) {
    _showBlurBackgroundDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static Future<T?> _showBlurBackgroundDialog<T>({
    required BuildContext context,
    bool allowDismiss = true,
    required SRDialog Function(BuildContext context) builder,
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
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 24 * anim1.value,
          sigmaY: 24 * anim1.value,
        ),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SRDialogTitleRow(
              showCloseButton: true,
              showDivider: title != null,
              title: title,
            ),
            _buildMessageRow(message),
          ],
        ),
      ),
    );
  }

  factory SRDialog.custom({
    Key? key,
    required Widget child,
  }) {
    return SRDialog._internal(
      key: key,
      child: child,
    );
  }

  const SRDialog._internal({
    super.key,
    required this.child,
  });

  static Widget _buildMessageRow(String message) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth / 1.5,
          child: SRScrollView(
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: srDialogMessageSize),
                textAlign: TextAlign.left,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DialogContainer(child: SRCard(child: child));
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

  Map<String, double> _getConstraints(BuildContext context) {
    final MediaQueryData? data = MediaQuery.maybeOf(context);
    double bottomPadding = 0;
    bool landscape = data?.orientation == Orientation.landscape;
    int padding =
        (landscape ? _landscapeOuterPadding : _portraitOuterPadding) * 2;
    double maxWidth = landscape ? 640 : 360;
    double maxHeight = landscape ? 280 : 540;
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
    return {
      "bottomPadding": bottomPadding,
      "maxWidth": maxWidth,
      "maxHeight": maxHeight,
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _getConstraints(context);
    final bottomPadding = data['bottomPadding']!;
    final maxWidth = data['maxWidth']!;
    final maxHeight = data['maxHeight']!;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: bottomPadding),
          padding: padding,
          width: maxWidth,
          constraints: constraints ?? BoxConstraints(maxHeight: maxHeight),
          child: child,
        ),
      ),
    );
  }
}
