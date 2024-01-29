import 'package:example/util.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/views/buttons/normal.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Text buttons",
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            SRButton.text(
              text: "Normal",
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              expanded: true,
              text: "Expanded",
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "Disabled",
              // onTap: () => showSnackBar(context, "tap2"),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "Highlighted",
              highlightType: SRButtonHighlightType.highlighted,
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 16),
            SRButton.text(
              text: "Highlighted Plus",
              highlightType: SRButtonHighlightType.highlightedPlus,
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 16),
            SRButton.custom(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_rounded,
                    size: 16,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text("Custom child"),
                  SizedBox(width: 8),
                ],
              ),
              onPress: () => showSnackBar(context, "tap"),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Icon buttons",
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
