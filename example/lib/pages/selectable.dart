import 'package:flutter/material.dart';
import 'package:starrail_ui/views/selectable/checkbox.dart';

class SelectablePage extends StatefulWidget {
  const SelectablePage({super.key});

  @override
  State<SelectablePage> createState() => _SelectablePageState();
}

class _SelectablePageState extends State<SelectablePage> {
  bool _checked1 = false;
  bool _checked2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("Option"),
                SRCheckbox.light(
                  checked: _checked1,
                  onChanged: (value) {
                    setState(() {
                      _checked1 = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Option",
                ),
                SRCheckbox.dark(
                  checked: _checked2,
                  onChanged: (value) {
                    setState(() {
                      _checked2 = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
