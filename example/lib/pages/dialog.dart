import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:starrail_ui/views/buttons/normal.dart';
import 'package:starrail_ui/views/dialog.dart';
import 'package:starrail_ui/views/misc/scroll.dart';

class DialogPage extends StatelessWidget {
  const DialogPage({super.key});

  void _showCustomDialog(BuildContext context) {
    return SRDialog.showCustom(
      context: context,
      dialog: SRDialog.custom(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SRDialogTitleRow(
                showCloseButton: true,
                showDivider: true,
                title: "Custom Dialog",
              ),
              SizedBox(
                height: 200,
                child: SRScrollView(
                  children: [
                    Image.asset(
                      "assets/images/02.jpg",
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lorem(paragraphs: 3, words: 100),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SRButton.text(
              text: "SRDialog.message",
              expanded: true,
              onPress: () => SRDialog.showMessage(
                context: context,
                title: "Title",
                message: lorem(paragraphs: 2, words: 20),
              ),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "SRDialog.custom",
              expanded: true,
              onPress: () => _showCustomDialog(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
