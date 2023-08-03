import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:starrail_ui/views/misc/icon.dart';
import 'package:starrail_ui/views/selectable/navigation_bar.dart';
import 'package:starrail_ui/views/selectable/tabs.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 3;
  late final TabController _tabController;
  final List<Widget> _pages = List.generate(6, (index) => index)
      .map(
        (e) => _SubPage(
          index: e,
        ),
      )
      .toList();
  int _tabIndex = 0;
  final icons = [
    Icons.image_rounded,
    Icons.volume_down_rounded,
    Icons.notifications_rounded,
    Icons.perm_contact_cal,
    Icons.extension_rounded,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
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
      backgroundColor: colorScheme.surface,
      extendBody: true,
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Tabs",
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SRTabBar(
                  tabController: _tabController,
                  selectedBackgroundColor: colorScheme.inverseSurface,
                  unselectedBackgroundColor: colorScheme.surface,
                  selectedForegroundColor: colorScheme.inversePrimary,
                  unselectedForegroundColor: colorScheme.primary,
                  items: icons
                      .take(_tabCount)
                      .map(
                        (e) => SRTabBarItem(
                          title: lorem(
                            paragraphs: 1,
                            words: 1 + Random().nextInt(1),
                          ),
                          icon: SRIcon(iconData: e),
                        ),
                      )
                      .toList(),
                ),
              ),
              Container(color: Colors.white, height: 4),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Navigation bar",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          SRNavigationBar.auto(
            context: context,
            direction: Axis.horizontal,
            // scroll: true,
            onChanged: (value) {
              setState(() {
                _tabIndex = value;
              });
            },
            icons: icons.map((e) => SRIcon(iconData: e)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SubPage extends StatefulWidget {
  static const _colors = [
    Color(0xFFFF6060),
    Color(0xFFFF9D60),
    Color(0xFFD8A24D),
    Color(0xFF63B248),
    Color(0xFF49BABA),
    Color(0xFF608DFF),
    Color(0xFFA060FF),
  ];
  final int index;

  const _SubPage({super.key, required this.index});

  @override
  State<_SubPage> createState() => _SubPageState();
}

class _SubPageState extends State<_SubPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _SubPage._colors[widget.index % _SubPage._colors.length],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Page ${widget.index + 1}\nPage state will be kept.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
