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
                seedColor: Colors.deepPurple, brightness: Brightness.dark),
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
    _PageInfo("button", const ButtonPage()),
    _PageInfo("input", const InputPage()),
    _PageInfo("selectable", const SelectablePage()),
    _PageInfo("progress", const ProgressPage()),
    _PageInfo("dialog", const DialogPage()),
    _PageInfo("navigation", const NavigationPage()),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Kit Demo'),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          tabs: _pages.map((e) => Tab(text: e.title.capitalize())).toList(),
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
  final Widget page;

  _PageInfo(this.title, this.page);
}
