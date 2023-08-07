import 'dart:ui';

import 'package:example/pages/buttons.dart';
import 'package:example/pages/conversation.dart';
import 'package:example/pages/dialog.dart';
import 'package:example/pages/input.dart';
import 'package:example/pages/navigation.dart';
import 'package:example/pages/progress.dart';
import 'package:example/pages/selectable.dart';
import 'package:example/util.dart';
import 'package:flutter/material.dart';
import 'package:starrail_ui/theme/colors.dart';
import 'package:starrail_ui/views/base/listener.dart';
import 'package:starrail_ui/views/buttons/normal.dart';
import 'package:starrail_ui/views/dialog.dart';
import 'package:starrail_ui/views/misc/icon.dart';
import 'package:starrail_ui/views/misc/scroll.dart';
import 'package:starrail_ui/views/selectable/tabs.dart';

void main() {
  runApp(const MyApp());
}

ValueNotifier<bool> globalBrightnessLight = ValueNotifier(true);
ValueNotifier<Color> globalThemeColor = ValueNotifier(srHighlighted);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globalBrightnessLight,
      builder: (context, light, child) => ValueListenableBuilder(
        valueListenable: globalThemeColor,
        builder: (context, color, child) {
          var themeData = ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: color,
            ),
          );
          return MaterialApp(
            theme: themeData,
            darkTheme: themeData.copyWith(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: color,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: light ? ThemeMode.light : ThemeMode.dark,
            title: 'Starrail UI Kit Demo',
            scrollBehavior: DemoScrollBehavior(),
            home: const DemoPage(),
          );
        },
      ),
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
  static const List<Color> _colors = [
    srHighlighted,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
    Colors.pinkAccent,
  ];
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
    _PageInfo(
      title: "conversation",
      icon: Icons.forum_rounded,
      page: const ConversationPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _pages.length,
      initialIndex: 5,
      vsync: this,
    );
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
        actions: _buildActions(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages.map((e) => e.page).toList(),
      ),
    );
  }

  void _showColorPicker() {
    SRDialog.showCustom(
      context: context,
      dialog: SRDialog.custom(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SRDialogTitleRow(
                showCloseButton: true,
                showDivider: true,
                title: "Theme Color",
              ),
              SizedBox(
                height: 200,
                child: SRScrollbar(
                  direction: Axis.vertical,
                  child: GridView(
                    primary: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 75,
                      maxCrossAxisExtent: 65,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 65 / 75,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    children: _colors.map((e) => _ColorItem(color: e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      ValueListenableBuilder(
        valueListenable: globalBrightnessLight,
        builder: (BuildContext context, value, Widget? child) =>
            SRButton.circular(
          iconData: value ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          onPress: () {
            setState(() {
              globalBrightnessLight.value = !globalBrightnessLight.value;
            });
          },
        ),
      ),
      const SizedBox(width: 16),
      ValueListenableBuilder(
        valueListenable: globalThemeColor,
        builder: (BuildContext context, value, Widget? child) =>
            SRButton.circular(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value,
            ),
            width: 16,
            height: 16,
          ),
          onPress: () => _showColorPicker(),
        ),
      ),
      const SizedBox(
        width: 48,
      )
    ];
  }
}

class _ColorItem extends StatefulWidget {
  final Color color;

  const _ColorItem({super.key, required this.color});

  @override
  State<_ColorItem> createState() => _ColorItemState();
}

class _ColorItemState extends State<_ColorItem> with ClickableStateMixin {
  @override
  VoidCallback? get onLongPress => null;

  @override
  VoidCallback? get onPress => _onClick;

  void _onClick() {
    debugPrint("_onClick");
    setState(() {
      globalThemeColor.value = widget.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globalThemeColor,
      builder: (context, child) {
        return SRSelectionAnimatedBuilder(
          selected: widget.color == globalThemeColor.value,
          builder: (context, value, child) => SRInteractiveBuilder(
            builder: (context, hoverProgress, touchProgress) {
              return Transform.scale(
                scale: 1 + 0.1 * hoverProgress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.lerp(
                        Colors.white.withOpacity(0), Colors.white, value),
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(9)),
                    border: Border.all(
                      color: Color.lerp(
                          Colors.black.withOpacity(0), Colors.black, value)!,
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      left: 1.5, right: 1.5, top: 1.5, bottom: 3),
                  child: buildGestureDetector(
                    child: Stack(
                      children: [
                        _buildColor(),
                        _buildInnerBorder(),
                        _buildGradient(),
                        _buildTextBar(),
                        _buildIcon(),
                        _buildOverlay(touchProgress),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Positioned _buildOverlay(double progress) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(9)),
          color: Color.lerp(Colors.black.withOpacity(0),
              Colors.black.withOpacity(0.25), progress),
        ),
      ),
    );
  }

  Positioned _buildInnerBorder() {
    return Positioned(
      top: 2,
      right: 2,
      left: 2,
      bottom: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.75), width: 1),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(7)),
        ),
      ),
    );
  }

  Positioned _buildColor() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(7)),
        ),
      ),
    );
  }

  Container _buildGradient() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(7)),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0),
            Colors.black.withOpacity(0),
            Colors.black.withOpacity(0.25)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0, 0.5, 1],
        ),
      ),
    );
  }

  Positioned _buildIcon() {
    return const Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 16,
        child: Center(
          child: Icon(
            Icons.brush_rounded,
            color: Colors.white,
            size: 36,
          ),
        ));
  }

  Positioned _buildTextBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 1,
      child: Container(
        color: Colors.black,
        height: 14,
        child: Center(
          child: Text(
            widget.color.toHex(leadingHashSign: true).toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 8),
          ),
        ),
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
