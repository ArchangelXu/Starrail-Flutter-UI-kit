import 'dart:ui';

import 'package:example/pages/buttons.dart';
import 'package:example/pages/dialog.dart';
import 'package:example/pages/input.dart';
import 'package:example/pages/navigation.dart';
import 'package:example/pages/progress.dart';
import 'package:example/pages/selectable.dart';
import 'package:example/util.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/views/buttons/normal.dart';
import 'package:starrail_ui/views/misc/icon.dart';
import 'package:starrail_ui/views/selectable/tabs.dart';

void main() {
  runApp(const MyApp());
}

ValueNotifier<bool> globalBrightnessLight2 = ValueNotifier(true);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globalBrightnessLight2,
      builder: (context, value, child) {
        var themeData = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
        );
        return MaterialApp(
          theme: themeData,
          darkTheme: themeData.copyWith(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: value ? ThemeMode.light : ThemeMode.dark,
          title: 'Starrail UI Kit Demo',
          scrollBehavior: DemoScrollBehavior(),
          home: const DemoPage(),
        );
      },
    );
  }
}

class DemoScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  DemoPageState createState() => DemoPageState();
}

class DemoPageState extends State<DemoPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<_PageInfo> _pages = <_PageInfo>[
    _PageInfo(
      title: "button",
      icon: Icons.smart_button_rounded,
      page: const ButtonPage(),
    ),
    _PageInfo(
      title: "input",
      icon: Icons.text_fields_rounded,
      page: const InputPage(),
    ),
    _PageInfo(
      title: "selectable",
      icon: Icons.check_box_outlined,
      page: const SelectablePage(),
    ),
    _PageInfo(
      title: "progress",
      icon: Icons.tune_rounded,
      page: const ProgressPage(),
    ),
    _PageInfo(
      title: "dialog",
      icon: Icons.feedback_rounded,
      page: const DialogPage(),
    ),
    _PageInfo(
      title: "navigation",
      icon: Icons.anchor_rounded,
      page: const NavigationPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        title: const Text('UI Kit Demo'),
        bottom: SRTabBar(
          tabController: _tabController,
          scroll: true,
          items: _pages
              .map(
                (e) => SRTabBarItem(
                  title: e.title.capitalize(),
                  icon: SRIcon(iconData: e.icon),
                ),
              )
              .toList(),
          selectedBackgroundColor: colorScheme.surface,
          unselectedBackgroundColor: colorScheme.inverseSurface,
          selectedForegroundColor: colorScheme.primary,
          unselectedForegroundColor: colorScheme.inversePrimary,
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: globalBrightnessLight2,
            builder: (BuildContext context, value, Widget? child) =>
                SRButton.circular(
              iconData:
                  value ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              onPress: () {
                setState(() {
                  globalBrightnessLight2.value = !globalBrightnessLight2.value;
                    });
                  },
                ),
          ),
          const SizedBox(
            width: 48,
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages.map((e) => e.page).toList(),
      ),
    );
  }
}

class _PageInfo {
  final String title;
  final IconData icon;
  final Widget page;

  _PageInfo({
    required this.title,
    required this.page,
    required this.icon,
  });
}
