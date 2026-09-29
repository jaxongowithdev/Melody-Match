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
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Column(children: [
          StoaTitle(
              trailing: IconButton(
                  tooltip: 'Practice settings',
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            PlinthView(onPrefsChanged: widget.onPrefsChanged)));
                    if (mounted) setState(() => _revision++);
                  })),
          StoaColon(index: _index, onSelect: (i) => setState(() => _index = i)),
          Expanded(
              child: IndexedStack(index: _index, children: [
            WalkView(key: ValueKey(_revision)),
            const RangeView(),
            const ShadeView(),
            const TabletView(),
          ])),
        ])),
      );
}
