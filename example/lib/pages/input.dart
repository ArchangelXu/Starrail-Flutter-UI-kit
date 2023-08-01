import 'package:flutter/material.dart';
import 'package:starrail_ui/views/input/text.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController _inputController1 =
      TextEditingController(text: "Single line");

  final TextEditingController _inputController2 =
      TextEditingController(text: "Multi-line");
  final TextEditingController _inputController3 =
      TextEditingController(text: "Disabled");

  @override
  void dispose() {
    _inputController1.dispose();
    _inputController2.dispose();
    _inputController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SRTextField(
              controller: _inputController1,
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            SRTextField(
              controller: _inputController2,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            SRTextField(
              controller: _inputController3,
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
