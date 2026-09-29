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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: VisualTheme.bayOf(context),
                borderRadius: BorderRadius.circular(30)),
            child: Row(children: [
              for (final item in [
                (0, 'Walk'),
                (1, 'Range'),
                (2, 'Rest'),
                (3, 'Tablet')
              ])
                Expanded(
                    child: Semantics(
                        selected: item.$1 == index,
                        button: true,
                        child: InkWell(
                            onTap: () => onSelect(item.$1),
                            borderRadius: BorderRadius.circular(24),
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                    color: item.$1 == index
                                        ? VisualTheme.accentOf(context)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(item.$2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: item.$1 == index
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                            : VisualTheme.mutedOf(
                                                context))))))),
            ])),
      );
}

class StoaTitle extends StatelessWidget {
  final Widget? trailing;
  const StoaTitle({super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 12, 8),
        child: Row(children: [
          Icon(Icons.album_outlined,
              color: VisualTheme.accentOf(context), size: 28),
          const SizedBox(width: 10),
          Expanded(
              child: Text('cadence room',
                  style: VisualTheme.heading(22,
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
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: VisualTheme.kindTint(session.kind)
                                  .withValues(alpha: .2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(session.kind.toUpperCase(),
                              style: VisualTheme.micro(10,
                                  color: VisualTheme.inkOf(context)))),
                      const Spacer(),
                      Text('${session.minutes} min',
                          style: VisualTheme.heading(13,
                              color: VisualTheme.mutedOf(context))),
                    ]),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(
                          child: Text(session.title,
                              style: VisualTheme.display(27,
                                  color: VisualTheme.inkOf(context)))),
                      const SizedBox(width: 12),
                      Icon(Icons.play_circle_outline,
                          size: 36, color: VisualTheme.accentOf(context)),
                    ]),
                    const SizedBox(height: 8),
                    Text(session.subtitle,
                        style: VisualTheme.body(14,
                            color: VisualTheme.mutedOf(context))),
                  ])),
        ),
      );
}

/// A locally drawn rhythm disc, used in the app as its visual motif.
class FieldMark extends StatelessWidget {
  final double size;
  const FieldMark({super.key, this.size = 150});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _RhythmDisc(VisualTheme.accentOf(context))));
}

class _RhythmDisc extends CustomPainter {
  final Color color;
  _RhythmDisc(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * .07;
    for (var i = 0; i < 3; i++) {
      canvas.drawArc(
          Rect.fromCircle(
              center: center, radius: size.width * (.43 - i * .115)),
          .6,
          math.pi * 2 - 1.2,
          false,
          paint);
    }
    canvas.drawCircle(Offset(size.width * .84, size.height * .5),
        size.width * .08, Paint()..color = VisualTheme.apricot);
  }

  @override
  bool shouldRepaint(_RhythmDisc oldDelegate) => oldDelegate.color != color;
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
                  width: 42,
                  height: 200,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                        decoration: BoxDecoration(
                            color: color.withValues(alpha: .07),
                            borderRadius: BorderRadius.circular(24))),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        height: 30 + t.clamp(0.0, 1.0) * 170,
                        decoration: BoxDecoration(
                            color: i == 3
                                ? VisualTheme.apricot
                                : color.withValues(alpha: 1 - i * .2),
                            borderRadius: BorderRadius.circular(24))),
                  ])),
          ]));
}
