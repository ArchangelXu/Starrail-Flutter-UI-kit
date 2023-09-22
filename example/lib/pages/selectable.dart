import 'package:flutter/material.dart';
import 'package:starrail_ui/views/base/squircle.dart';
import 'package:starrail_ui/views/selectable/checkbox.dart';
import 'package:starrail_ui/views/selectable/radio.dart';

class SelectablePage extends StatefulWidget {
  const SelectablePage({super.key});

  @override
  State<SelectablePage> createState() => _SelectablePageState();
}

class _SelectablePageState extends State<SelectablePage> {
  bool _checked1 = false;
  bool _checked2 = false;
  bool _checked3 = false;
  int _radioValue = 2;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    var textStyle = TextStyle(color: scheme.inverseSurface);
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Checkbox",
              textAlign: TextAlign.start,
              style: textStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFrame(
                  context: context,
                  index: 0,
                  child: _buildCheckbox(
                    textStyle: textStyle,
                    context: context,
                    title: "Light",
                    dark: false,
                    checked: _checked1,
                    onChanged: (value) {
                      setState(() {
                        _checked1 = value ?? false;
                      });
                    },
                  ),
                ),
                _buildFrame(
                  context: context,
                  index: 1,
                  child: _buildCheckbox(
                    textStyle: textStyle,
                    context: context,
                    title: "Dark",
                    dark: true,
                    checked: _checked2,
                    onChanged: (value) {
                      setState(() {
                        _checked2 = value ?? false;
                      });
                    },
                  ),
                ),
                _buildFrame(
                  context: context,
                  index: 2,
                  child: _buildCheckbox(
                    textStyle: textStyle,
                    context: context,
                    title: "Auto",
                    checked: _checked3,
                    onChanged: (value) {
                      setState(() {
                        _checked3 = value ?? false;
                      });
                    },
                  ),
                ),
                _buildFrame(
                  context: context,
                  index: 3,
                  child: _buildCheckbox(
                    textStyle: textStyle,
                    context: context,
                    title: "Disabled 1",
                    checked: true,
                  ),
                ),
                _buildFrame(
                  context: context,
                  index: 4,
                  child: _buildCheckbox(
                    textStyle: textStyle,
                    context: context,
                    title: "Disabled 2",
                    checked: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              "Radio",
              textAlign: TextAlign.start,
              style: textStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFrame(
                  context: context,
                  index: 0,
                  child: _buildRadio(
                    textStyle: textStyle,
                    context: context,
                    title: "Light",
                    dark: false,
                    value: 0,
                    onChanged: _onRadioValueChanged,
                  ),
                ),
                _buildFrame(
                  context: context,
                  index: 1,
                  child: _buildRadio(
                    textStyle: textStyle,
                    context: context,
                    title: "Dark",
                    dark: true,
                    value: 1,
                    onChanged: _onRadioValueChanged,
                  ),
                ),
                _buildFrame(
                  context: context,
                  index: 2,
                  child: _buildRadio(
                    textStyle: textStyle,
                    context: context,
                    title: "Auto",
                    value: 2,
                    onChanged: _onRadioValueChanged,
                  ),
                ),
                _buildFrame(
                  context: context,
                  index: 3,
                  child: _buildRadio(
                    textStyle: textStyle,
                    context: context,
                    title: "Disabled",
                    value: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrame({
    required Widget child,
    required BuildContext context,
    required int index,
  }) {
    var colorScheme = Theme.of(context).colorScheme;
    var color = index % 2 == 0
        ? colorScheme.inverseSurface.withOpacity(0.05)
        : colorScheme.primaryContainer.withOpacity(0.4);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: SmoothCornerBorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }

  Widget _buildCheckbox({
    required BuildContext context,
    required TextStyle textStyle,
    required String title,
    required bool checked,
    bool? dark,
    ValueChanged<bool?>? onChanged,
  }) {
    SRCheckbox checkbox;
    if (dark == true) {
      checkbox = SRCheckbox.dark(
        checked: checked,
        onChanged: onChanged,
      );
    } else if (dark == false) {
      checkbox = SRCheckbox.light(
        checked: checked,
        onChanged: onChanged,
      );
    } else {
      checkbox = SRCheckbox.auto(
        context: context,
        checked: checked,
        onChanged: onChanged,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Text(title, style: textStyle)),
        checkbox,
      ],
    );
  }

  void _onRadioValueChanged(int? value) {
    setState(() {
      _radioValue = value ?? 2;
    });
  }

  Widget _buildRadio({
    required BuildContext context,
    required TextStyle textStyle,
    required String title,
    required int value,
    ValueChanged<int?>? onChanged,
    bool? dark,
  }) {
    SRRadio radio;
    if (dark == true) {
      radio = SRRadio<int>.dark(
        value: value,
        groupValue: _radioValue,
        onChanged: onChanged,
      );
    } else if (dark == false) {
      radio = SRRadio<int>.light(
        value: value,
        groupValue: _radioValue,
        onChanged: onChanged,
      );
    } else {
      radio = SRRadio<int>.auto(
        context: context,
        value: value,
        groupValue: _radioValue,
        onChanged: onChanged,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Text(title, style: textStyle)),
        radio,
      ],
    );
  }
}
