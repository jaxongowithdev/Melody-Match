import 'package:flutter/material.dart';
import '../widgets/stoa_chrome.dart';
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
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            bottom: false,
            child: Column(children: [
              StoaTitle(
                  trailing: IconButton(
                      tooltip: 'Practice settings',
                      icon: const Icon(Icons.tune),
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PlinthView(
                                onPrefsChanged: widget.onPrefsChanged)));
                        if (mounted) setState(() => _revision++);
                      })),
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
        bottomNavigationBar: StoaColon(index: _index, onSelect: _select),
      );
}
