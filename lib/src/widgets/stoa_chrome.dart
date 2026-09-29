import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class MistWash extends StatelessWidget {
  final Widget child;
  const MistWash({super.key, required this.child});
  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: VisualTheme.mistOf(context), child: child);
}

class StoaColon extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  const StoaColon({super.key, required this.index, required this.onSelect});
  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onSelect,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Walk'),
          NavigationDestination(
              icon: Icon(Icons.view_agenda_outlined), label: 'Range'),
          NavigationDestination(
              icon: Icon(Icons.dark_mode_outlined), label: 'Rest'),
          NavigationDestination(
              icon: Icon(Icons.book_outlined), label: 'Tablet'),
        ],
      );
}

class StoaTitle extends StatelessWidget {
  final Widget? trailing;
  const StoaTitle({super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
        child: Row(children: [
          Icon(Icons.spa_outlined,
              color: VisualTheme.accentOf(context), size: 24),
          const SizedBox(width: 10),
          Expanded(
              child: Text('MOSSLIGHT',
                  style: VisualTheme.micro(13,
                      color: VisualTheme.inkOf(context)))),
          if (trailing != null) trailing!,
        ]),
      );
}

class BayCard extends StatelessWidget {
  final PracticeSession session;
  final VoidCallback onTap;
  const BayCard({super.key, required this.session, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
        color: VisualTheme.bayOf(context),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                Container(
                    width: 4,
                    height: 76,
                    color: VisualTheme.kindTint(session.kind)),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          '${session.kind.toUpperCase()} / ${session.minutes} MIN',
                          style: VisualTheme.micro(10,
                              color: VisualTheme.mutedOf(context))),
                      const SizedBox(height: 7),
                      Text(session.title,
                          style: VisualTheme.display(24,
                              color: VisualTheme.inkOf(context))),
                      const SizedBox(height: 4),
                      Text(session.subtitle,
                          style: VisualTheme.body(13,
                              color: VisualTheme.mutedOf(context))),
                    ])),
                const SizedBox(width: 8),
                Icon(Icons.north_east,
                    size: 18, color: VisualTheme.accentOf(context)),
              ])),
        ),
      );
}

/// Decorative contour rings, drawn locally without network assets.
class FieldMark extends StatelessWidget {
  final double size;
  const FieldMark({super.key, this.size = 150});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
            painter: _Contours(VisualTheme.accentOf(context)),
            child: Center(
                child: Icon(Icons.spa_outlined,
                    size: size * .34, color: VisualTheme.accentOf(context)))),
      );
}

class _Contours extends CustomPainter {
  final Color color;
  _Contours(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: .35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final inset = i * size.width * .07 + 3;
      canvas.drawArc(
          Rect.fromLTWH(
              inset, inset, size.width - inset * 2, size.height - inset * 2),
          -.5,
          math.pi * 1.7,
          false,
          paint);
    }
  }

  @override
  bool shouldRepaint(_Contours oldDelegate) => oldDelegate.color != color;
}

class ColumnWalk extends StatelessWidget {
  final double t;
  final Color color;
  const ColumnWalk({super.key, required this.t, required this.color});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 224,
        height: 190,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < 4; i++)
                AnimatedContainer(
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeInOut,
                    width: 38,
                    height: 35 + t.clamp(0.0, 1.0) * (135 - i * 12),
                    decoration: BoxDecoration(
                        color: color.withValues(alpha: 1 - i * .16),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)))),
            ]),
      );
}
