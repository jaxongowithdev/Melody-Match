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

/// A top-mounted, scroll-safe destination strip.
class StoaColon extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  const StoaColon({super.key, required this.index, required this.onSelect});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: VisualTheme.bayOf(context),
                borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              for (var i = 0; i < 4; i++)
                Expanded(
                    child: Semantics(
                        selected: index == i,
                        button: true,
                        child: Material(
                            color: index == i
                                ? VisualTheme.fuchsia
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(19),
                            child: InkWell(
                                onTap: () => onSelect(i),
                                borderRadius: BorderRadius.circular(19),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 2),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                              [
                                                Icons.dashboard_outlined,
                                                Icons.widgets_outlined,
                                                Icons.nights_stay_outlined,
                                                Icons.inventory_2_outlined
                                              ][i],
                                              size: 19,
                                              color: index == i
                                                  ? Colors.white
                                                  : VisualTheme.mutedOf(
                                                      context)),
                                          const SizedBox(height: 4),
                                          Text(
                                              [
                                                'Walk',
                                                'Range',
                                                'Rest',
                                                'Tablet'
                                              ][i],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: index == i
                                                      ? Colors.white
                                                      : VisualTheme.mutedOf(
                                                          context))),
                                        ])))))),
            ])),
      );
}

class StoaTitle extends StatelessWidget {
  final Widget? trailing;
  const StoaTitle({super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
        child: Row(children: [
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: VisualTheme.fuchsia,
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.waves, color: Colors.white, size: 22)),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Tideframe',
                    style: VisualTheme.heading(21,
                        color: VisualTheme.inkOf(context), w: FontWeight.w800)),
                Text('YOUR OFFLINE PRACTICE SPACE',
                    style: VisualTheme.micro(8,
                        color: VisualTheme.mutedOf(context))),
              ])),
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
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: VisualTheme.kindTint(session.kind)
                                  .withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(session.kind.toUpperCase(),
                              style: VisualTheme.micro(9,
                                  color: VisualTheme.inkOf(context)))),
                      const Spacer(),
                      Text('${session.minutes} min',
                          style: VisualTheme.heading(14,
                              color: VisualTheme.mutedOf(context))),
                      const SizedBox(width: 8),
                      const Icon(Icons.north_east, size: 18),
                    ]),
                    const SizedBox(height: 18),
                    Text(session.title,
                        style: VisualTheme.heading(23,
                            color: VisualTheme.inkOf(context),
                            w: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(session.subtitle,
                        style: VisualTheme.body(14,
                            color: VisualTheme.mutedOf(context))),
                    const SizedBox(height: 16),
                    Row(children: [
                      for (var i = 0; i < 4; i++)
                        Expanded(
                            child: Container(
                                height: 4,
                                margin: const EdgeInsets.only(right: 4),
                                color: VisualTheme.accentOf(context)
                                    .withValues(alpha: .15 + i * .15)))
                    ]),
                  ])),
        ),
      );
}

class FieldMark extends StatelessWidget {
  final double size;
  const FieldMark({super.key, this.size = 150});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _TidePainter(VisualTheme.accentOf(context))));
}

class _TidePainter extends CustomPainter {
  final Color color;
  _TidePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .15, h * .08, w * .7, h * .84),
            Radius.circular(w * .14)),
        Paint()..color = color.withValues(alpha: .15));
    canvas.drawCircle(
        Offset(w * .71, h * .28), w * .1, Paint()..color = VisualTheme.apricot);
    for (var i = 0; i < 2; i++) {
      final path = Path()
        ..moveTo(w * .06, h * (.43 + i * .24))
        ..cubicTo(w * .4, h * (.12 + i * .24), w * .6, h * (.85 + i * .05),
            w * .94, h * (.5 + i * .2));
      canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = w * .09
            ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(_TidePainter oldDelegate) => oldDelegate.color != color;
}

class ColumnWalk extends StatelessWidget {
  final double t;
  final Color color;
  const ColumnWalk({super.key, required this.t, required this.color});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 240,
      height: 180,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 4; i++)
              SizedBox(
                  width: 42,
                  height: 180,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                        decoration: BoxDecoration(
                            color: color.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(21))),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        height: 20 + t.clamp(0.0, 1.0) * 160,
                        decoration: BoxDecoration(
                            color: color.withValues(alpha: 1 - i * .15),
                            borderRadius: BorderRadius.circular(21))),
                  ])),
          ]));
}
