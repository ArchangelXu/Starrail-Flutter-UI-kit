import 'package:flutter/material.dart';
import 'package:starrail_ui/views/misc/icon.dart';
import 'package:starrail_ui/views/selectable/navigation.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> _pages = List.generate(6, (index) => index)
      .map(
        (e) => _SubPage(
          index: e,
        ),
      )
      .toList();
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      extendBody: true,
      body: IndexedStack(
        index: _tabIndex,
        children: _pages,
      ),
      bottomNavigationBar: SRNavigationBar.auto(
        context: context,
        direction: Axis.horizontal,
        // scroll: true,
        onChanged: (value) {
          setState(() {
            _tabIndex = value;
          });
        },
        iconBuilders: [
          Icons.image_rounded,
          Icons.volume_down_rounded,
          Icons.notifications_rounded,
          Icons.perm_contact_cal,
          Icons.extension_rounded,
          Icons.settings,
        ]
            .map(
              (e) => (color, size) => SRIcon(
                    iconData: e,
                    color: color,
                    size: size,
                  ),
            )
            .toList(),
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
