import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:starrail_ui/views/buttons/normal.dart';
import 'package:starrail_ui/views/dialog.dart';
import 'package:starrail_ui/views/misc/scroll.dart';

class DialogPage extends StatelessWidget {
  const DialogPage({super.key});

  void _showCustomDialog(BuildContext context) {
    SRDialog.showCustom(
      context: context,
      dialog: SRDialog.custom(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 360),
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
              Expanded(
                child: SRScrollView(
                  children: [
                    Image.asset(
                      "assets/images/02.jpg",
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lorem(paragraphs: 3, words: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
我：谁是小可爱呀？
宝宝：我
我：爸爸抱一下owo
宝宝：（玩积木）可是，我要忙着呢
我：啊...（失落）
宝宝：（转过来，把我的手扒拉开）好，去上班吧
* */
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
                title: "Message",
                message: lorem(paragraphs: 2, words: 20),
              ),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "SRDialog.message long",
              expanded: true,
              onPress: () => SRDialog.showMessage(
                context: context,
                title: "Long message",
                message: lorem(paragraphs: 5, words: 200),
              ),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "SRDialog.custom",
              expanded: true,
              onPress: () => _showCustomDialog(context),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "SRDialog.loading",
              expanded: true,
              onPress: () => SRDialog.showLoading(context: context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
