import 'package:flutter/material.dart';
import '../widgets/stoa_chrome.dart';
import '../utils/visual_theme.dart';
import 'plinth_view.dart';
import 'range_view.dart';
import 'shade_view.dart';
import 'tablet_view.dart';
import 'walk_view.dart';

class DashboardView extends StatefulWidget {
  final VoidCallback onPrefsChanged;
  const DashboardView({super.key, required this.onPrefsChanged});
  @override
  State<DashboardView> createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  int _index = 0, _revision = 0;
  void _select(int index) => setState(() => _index = index);
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        return Scaffold(
          appBar: AppBar(
              title: Text(['Walk', 'Range', 'Rest', 'Tablet'][_index]),
              actions: [
                IconButton(
                    tooltip: 'Practice settings',
                    icon: const Icon(Icons.tune),
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PlinthView(
                              onPrefsChanged: widget.onPrefsChanged)));
                      if (mounted) setState(() => _revision++);
                    }),
              ]),
          drawer: wide
              ? null
              : Drawer(
                  child: SafeArea(
                      child: SingleChildScrollView(
                          child: Column(children: [
                  const StoaTitle(),
                  const SizedBox(height: 28),
                  StoaColon(
                      index: _index,
                      onSelect: (i) {
                        Navigator.of(context).pop();
                        _select(i);
                      }),
                  const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Private journal.\nNo account. No cloud.')),
                ])))),
          body: SafeArea(
              top: false,
              child: Row(children: [
                if (wide)
                  SizedBox(
                      width: 190,
                      child: SingleChildScrollView(
                          child: Column(children: [
                        const StoaTitle(),
                        const SizedBox(height: 28),
                        StoaColon(index: _index, onSelect: _select),
                      ]))),
                if (wide)
                  VerticalDivider(
                      width: 1,
                      color:
                          VisualTheme.mutedOf(context).withValues(alpha: .2)),
                Expanded(
                    child: IndexedStack(index: _index, children: [
                  WalkView(
                      key: ValueKey(_revision),
                      onRange: () => _select(1),
                      onTablet: () => _select(3)),
                  const RangeView(),
                  const ShadeView(),
                  const TabletView(),
                ])),
              ])),
        );
      });
}
