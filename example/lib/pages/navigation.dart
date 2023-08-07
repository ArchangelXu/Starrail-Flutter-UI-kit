import 'package:example/util.dart';
import 'package:flutter/material.dart';
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

  final icons = [
    Icons.image_rounded,
    Icons.volume_down_rounded,
    Icons.notifications_rounded,
    Icons.perm_contact_cal,
    Icons.extension_rounded,
    Icons.settings,
    Icons.memory_rounded,
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
                      title: "Tab ${icons.indexOf(e) + 1}",
                      icon: SRIcon(iconData: e),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(color: colorScheme.inverseSurface, height: 4),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Navigation bar",
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SRNavigationBar.auto(
            context: context,
            direction: Axis.horizontal,
            onChanged: (value) {
              showSnackBar(context, "This is page ${value + 1}");
            },
            icons: icons.take(4).map((e) => SRIcon(iconData: e)).toList(),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Scrollable navigation bar",
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SRNavigationBar.auto(
            context: context,
            direction: Axis.horizontal,
            scroll: true,
            onChanged: (value) {
              showSnackBar(context, "This is page ${value + 1}");
            },
            icons: icons.map((e) => SRIcon(iconData: e)).toList(),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Vertical",
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: colorScheme.primaryContainer,
              child: Row(
                children: [
                  SRNavigationBar.auto(
                    context: context,
                    direction: Axis.vertical,
                    onChanged: (value) {
                      showSnackBar(context, "This is page ${value + 1}");
                    },
                    icons:
                        icons.take(4).map((e) => SRIcon(iconData: e)).toList(),
                  ),
                  const SizedBox(width: 8),
                  SRNavigationBar.auto(
                    context: context,
                    direction: Axis.vertical,
                    scroll: true,
                    onChanged: (value) {
                      showSnackBar(context, "This is page ${value + 1}");
                    },
                    icons: icons.map((e) => SRIcon(iconData: e)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
