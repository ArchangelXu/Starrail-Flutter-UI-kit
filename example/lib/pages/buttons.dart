import 'package:example/util.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/views/buttons/normal.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

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
              text: "SRButton.text",
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "SRButton onTap=null",
              // onTap: () => showSnackBar(context, "tap2"),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "SRButton highlighted",
              highlightType: SRButtonHighlightType.highlighted,
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "SRButton highlighted plus",
              highlightType: SRButtonHighlightType.highlightedPlus,
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SRButton.custom(
                    expanded: true,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_rounded,
                          size: 16,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text("SRButton with custom child"),
                        SizedBox(width: 8),
                      ],
                    ),
                    onPress: () => showSnackBar(context, "tap"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SRButton.circular(
                  child: const Text("A"),
                  onPress: () => showSnackBar(context, "tap"),
                ),
                const SizedBox(width: 16),
                SRButton.circular(
                  iconData: Icons.image_rounded,
                  highlightType: SRButtonHighlightType.highlighted,
                  onPress: () => showSnackBar(context, "tap"),
                ),
                const SizedBox(width: 16),
                SRButton.circular(
                  //supports assets/url/file path
                  iconPath: "assets/icons/icon_delete.svg",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
