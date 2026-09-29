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
              icon: Icon(Icons.route_outlined), label: 'Walk'),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined), label: 'Range'),
          NavigationDestination(
              icon: Icon(Icons.bedtime_outlined), label: 'Rest'),
          NavigationDestination(
              icon: Icon(Icons.edit_note_outlined), label: 'Tablet'),
        ],
      );
}

class StoaTitle extends StatelessWidget {
  final Widget? trailing;
  const StoaTitle({super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 12, 8),
        child: Row(children: [
          Icon(Icons.bookmark_outline,
              size: 24, color: VisualTheme.accentOf(context)),
          const SizedBox(width: 9),
          Expanded(
              child: Text('soft margin',
                  style: VisualTheme.display(26,
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
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        width: 5, color: VisualTheme.kindTint(session.kind)))),
            padding: const EdgeInsets.all(18),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                        '${session.kind.toUpperCase()} · ${session.minutes} MIN',
                        style: VisualTheme.micro(10,
                            color: VisualTheme.mutedOf(context))),
                    const SizedBox(height: 9),
                    Text(session.title,
                        style: VisualTheme.display(26,
                            color: VisualTheme.inkOf(context))),
                    const SizedBox(height: 7),
                    Text(session.subtitle,
                        style: VisualTheme.body(14,
                            color: VisualTheme.mutedOf(context))),
                  ])),
              const SizedBox(width: 12),
              Icon(Icons.arrow_outward,
                  size: 21, color: VisualTheme.accentOf(context)),
            ]),
          ),
        ),
      );
}

/// Folded notebook illustration, drawn on-device.
class FieldMark extends StatelessWidget {
  final double size;
  const FieldMark({super.key, this.size = 150});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FoldPainter(VisualTheme.accentOf(context))));
}

class _FoldPainter extends CustomPainter {
  final Color color;
  _FoldPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .18, h * .12, w * .64, h * .76),
            Radius.circular(w * .025)),
        Paint()..color = color.withValues(alpha: .12));
    final page = Path()
      ..moveTo(w * .28, h * .06)
      ..lineTo(w * .7, h * .06)
      ..lineTo(w * .9, h * .26)
      ..lineTo(w * .9, h * .79)
      ..lineTo(w * .28, h * .91)
      ..close();
    canvas.drawPath(page, Paint()..color = color);
    final fold = Path()
      ..moveTo(w * .7, h * .06)
      ..lineTo(w * .7, h * .26)
      ..lineTo(w * .9, h * .26)
      ..close();
    canvas.drawPath(fold, Paint()..color = VisualTheme.apricot);
    final rule = Paint()
      ..color = Colors.white.withValues(alpha: .6)
      ..strokeWidth = 2;
    for (var i = 0; i < 3; i++) {
      canvas.drawLine(Offset(w * .4, h * (.42 + i * .1)),
          Offset(w * .75, h * (.42 + i * .1)), rule);
    }
  }

  @override
  bool shouldRepaint(_FoldPainter oldDelegate) => oldDelegate.color != color;
}

class ColumnWalk extends StatelessWidget {
  final double t;
  final Color color;
  const ColumnWalk({super.key, required this.t, required this.color});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 240,
      height: 200,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 4; i++)
              SizedBox(
                  width: 40,
                  height: 200,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: color.withValues(alpha: .2)),
                            borderRadius: BorderRadius.circular(4))),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        height: 24 + t.clamp(0.0, 1.0) * 176,
                        decoration: BoxDecoration(
                            color: color.withValues(alpha: 1 - i * .17),
                            borderRadius: BorderRadius.circular(4))),
                  ])),
          ]));
}
