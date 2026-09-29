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
  Widget build(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        for (var i = 0; i < 4; i++)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  selected: index == i,
                  selectedTileColor:
                      VisualTheme.accentOf(context).withValues(alpha: .12),
                  leading: Icon([
                    Icons.route,
                    Icons.map_outlined,
                    Icons.bedtime_outlined,
                    Icons.article_outlined
                  ][i]),
                  title: Text(['Walk', 'Range', 'Rest', 'Tablet'][i]),
                  onTap: () => onSelect(i))),
      ]);
}

class StoaTitle extends StatelessWidget {
  final Widget? trailing;
  const StoaTitle({super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.local_fire_department_outlined,
            size: 30, color: VisualTheme.accentOf(context)),
        const SizedBox(height: 12),
        Text('Ember\nAtlas',
            style: VisualTheme.display(28, color: VisualTheme.inkOf(context))),
        if (trailing != null) trailing!,
      ]));
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
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                    width: 42,
                    child: Column(children: [
                      Text('${session.minutes}',
                          style: VisualTheme.display(28,
                              color: VisualTheme.accentOf(context))),
                      Text('MIN',
                          style: VisualTheme.micro(9,
                              color: VisualTheme.mutedOf(context))),
                    ])),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(session.title,
                          style: VisualTheme.heading(18,
                              color: VisualTheme.inkOf(context))),
                      const SizedBox(height: 6),
                      Text(session.subtitle,
                          style: VisualTheme.body(13,
                              color: VisualTheme.mutedOf(context))),
                    ])),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20),
              ]))));
}

class FieldMark extends StatelessWidget {
  final double size;
  const FieldMark({super.key, this.size = 150});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child:
          CustomPaint(painter: _AtlasPainter(VisualTheme.accentOf(context))));
}

class _AtlasPainter extends CustomPainter {
  final Color color;
  _AtlasPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    for (var i = 0; i < 3; i++) {
      final inset = w * (.1 + i * .13);
      final p = Path()
        ..moveTo(inset, h * .9)
        ..lineTo(inset, h * .5)
        ..quadraticBezierTo(inset, h * .2, w * .5, h * (.08 + i * .12))
        ..quadraticBezierTo(w - inset, h * .2, w - inset, h * .5)
        ..lineTo(w - inset, h * .9);
      canvas.drawPath(
          p,
          Paint()
            ..color = color.withValues(alpha: 1 - i * .2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = w * .045
            ..strokeCap = StrokeCap.round);
    }
    final diamond = Path()
      ..moveTo(w * .5, h * .58)
      ..lineTo(w * .58, h * .7)
      ..lineTo(w * .5, h * .82)
      ..lineTo(w * .42, h * .7)
      ..close();
    canvas.drawPath(diamond, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_AtlasPainter oldDelegate) => oldDelegate.color != color;
}

class ColumnWalk extends StatelessWidget {
  final double t;
  final Color color;
  const ColumnWalk({super.key, required this.t, required this.color});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 240,
      height: 210,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 4; i++)
              SizedBox(
                  width: 42,
                  height: 210,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: color.withValues(alpha: .25)),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(21)))),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        height: 16 + t.clamp(0.0, 1.0) * 194,
                        decoration: BoxDecoration(
                            color: color.withValues(alpha: 1 - i * .14),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(21)))),
                  ])),
          ]));
}
