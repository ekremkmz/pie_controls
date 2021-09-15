import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'pie_controls.dart';

import 'pie_controls_item.dart';
import 'dart:math' as math;

class PieDrawer extends StatelessWidget {
  const PieDrawer({
    Key? key,
    required this.pieSize,
    required this.alignement,
    required this.currentOffsetFromLocal,
    required this.triggerStartedOffset,
    required this.pies,
    required this.piePadding,
    required this.pieMargin,
    required this.angle,
    required this.color,
  }) : super(key: key);

  final List<PieControlsItem> pies;

  final double pieSize;

  final double pieMargin;

  final double piePadding;

  final double angle;

  final Color color;

  final TriggerAlignement alignement;

  final ValueNotifier<Offset> currentOffsetFromLocal;

  final Offset triggerStartedOffset;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: pieSize,
      height: 2 * pieSize,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: PiePainter(
                pieMargin: pieMargin,
                pieCount: pies.length,
                angle: angle,
                color: color,
                piePadding: piePadding,
                pieSize: pieSize,
              ),
            ),
          ),
          ..._buildPieChilds(),
        ],
      ),
    );
    switch (alignement) {
      case TriggerAlignement.top:
        return RotatedBox(
          quarterTurns: 1,
          child: child,
        );
      case TriggerAlignement.bottom:
        return RotatedBox(
          quarterTurns: 3,
          child: child,
        );
      case TriggerAlignement.left:
        return child;
      case TriggerAlignement.right:
        return RotatedBox(
          quarterTurns: 2,
          child: child,
        );
    }
  }

  List<Widget> _buildPieChilds() {
    return pies
        .asMap()
        .map((index, pieControlsItem) {
          double _angle = (2 * index + 1) / (2 * pies.length) * angle +
              ((math.pi - angle) / 2);

          double _r = (pieSize + piePadding) / 2;

          return MapEntry(
            index,
            Positioned(
              top: pieSize -
                  math.cos(_angle) * _r -
                  (pieControlsItem.childSize / 2),
              left: math.sin(_angle) * _r - (pieControlsItem.childSize / 2),
              child:
                  Transform.rotate(angle: _angle, child: pieControlsItem.child),
            ),
          );
        })
        .values
        .toList();
  }
}

class PiePainter extends CustomPainter {
  PiePainter({
    required this.pieCount,
    required this.pieSize,
    required this.piePadding,
    required this.pieMargin,
    required this.angle,
    required this.color,
  });

  final int pieCount;

  final double pieSize;

  final double piePadding;

  final double pieMargin;

  final double angle;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final piePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final fillEraser = Paint()..blendMode = BlendMode.clear;

    final eraser = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.stroke
      ..strokeWidth = pieMargin;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawArc(
      Rect.fromLTWH(-pieSize, 0, 2 * pieSize, 2 * pieSize),
      -angle / 2,
      angle,
      true,
      piePaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(
          -piePadding, pieSize - piePadding, 2 * piePadding, 2 * piePadding),
      -angle / 2,
      angle,
      true,
      fillEraser,
    );
    for (var i = 0; i < pieCount + 1; i++) {
      canvas.drawLine(
        Offset(0, pieSize),
        Offset(pieSize * math.cos((angle / pieCount * i) - angle / 2),
            pieSize + pieSize * math.sin((angle / pieCount * i) - angle / 2)),
        eraser,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
