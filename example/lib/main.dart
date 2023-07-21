import 'package:example/util.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/base.dart';
import 'package:starrail_ui/views/buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Kit Demo',
      theme: srTheme,
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demo")),
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SRButton.text(
                text: "SRButton.text",
                onTap: () => showSnackBar(context, "tap"),
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
                onTap: () => showSnackBar(context, "tap"),
              ),
              const SizedBox(height: 16),
              SRButton.text(
                text: "SRButton highlighted plus",
                highlightType: SRButtonHighlightType.highlightedPlus,
                onTap: () => showSnackBar(context, "tap"),
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
                            Icons.add,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text("SRButton with custom child"),
                          SizedBox(width: 8),
                        ],
                      ),
                      onTap: () => showSnackBar(context, "tap"),
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
                    child: Icon(Icons.message_rounded),
                    onTap: () => showSnackBar(context, "tap"),
                  ),
                  SizedBox(width: 16),
                  SRButton.circular(
                    child: Icon(Icons.image_rounded),
                    highlightType: SRButtonHighlightType.highlighted,
                    onTap: () => showSnackBar(context, "tap"),
                  ),
                  SizedBox(width: 16),
                  SRButton.circular(
                    child: Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
