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
    required this.triggerStartedOffset,
    required this.pies,
    required this.piePadding,
    required this.pieMargin,
    required this.totalAngle,
    required this.color,
    required this.onHoverColor,
    required this.hoveredIndex,
  }) : super(key: key);

  final List<PieControlsItem> pies;

  final double pieSize;

  final double pieMargin;

  final double piePadding;

  final double totalAngle;

  final Color color;

  final Color onHoverColor;

  final TriggerAlignement alignement;

  final ValueNotifier<int> hoveredIndex;

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
                hoveredIndex: hoveredIndex,
                pieMargin: pieMargin,
                pies: pies,
                totalAngle: totalAngle,
                color: color,
                onHoverColor: onHoverColor,
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
    double startingAngle = (math.pi - totalAngle) / 2;
    return pies.map((pieControlsItem) {
      double _angle = startingAngle + pieControlsItem.angle / 2;
      startingAngle += pieControlsItem.angle;

      double _r = (pieSize + piePadding) / 2;

      return Positioned(
        top: pieSize -
            math.cos(_angle) * _r -
            (pieControlsItem.maxChildHeight / 2),
        left: math.sin(_angle) * _r - (pieControlsItem.maxChildWidth / 2),
        child: Transform.rotate(angle: _angle, child: pieControlsItem),
      );
    }).toList();
  }
}

class PiePainter extends CustomPainter {
  PiePainter({
    required this.hoveredIndex,
    required this.pies,
    required this.pieSize,
    required this.piePadding,
    required this.pieMargin,
    required this.totalAngle,
    required this.color,
    required this.onHoverColor,
  }) : super(repaint: hoveredIndex);

  final ValueNotifier<int> hoveredIndex;

  final List<PieControlsItem> pies;

  final double pieSize;

  final double piePadding;

  final double pieMargin;

  final double totalAngle;

  final Color color;

  final Color onHoverColor;

  @override
  void paint(Canvas canvas, Size size) {
    final piePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final hoverPaint = Paint()
      ..color = onHoverColor
      ..style = PaintingStyle.fill;

    final fillEraser = Paint()..blendMode = BlendMode.clear;

    final eraser = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.stroke
      ..strokeWidth = pieMargin;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawArc(
      Rect.fromLTWH(-pieSize, 0, 2 * pieSize, 2 * pieSize),
      -totalAngle / 2,
      totalAngle,
      true,
      piePaint,
    );

    double currentAngle = -totalAngle / 2;

    canvas.drawLine(
      Offset(0, pieSize),
      Offset(pieSize * math.cos(currentAngle),
          pieSize + pieSize * math.sin(currentAngle)),
      eraser,
    );

    for (var i = 0; i < pies.length; i++) {
      if (hoveredIndex.value == i) {
        canvas.drawArc(
          Rect.fromLTWH(-pieSize, 0, 2 * pieSize, 2 * pieSize),
          currentAngle,
          pies[hoveredIndex.value].angle,
          true,
          hoverPaint,
        );
      }
      currentAngle += pies[i].angle;
      canvas.drawLine(
        Offset(0, pieSize),
        Offset(pieSize * math.cos(currentAngle),
            pieSize + pieSize * math.sin(currentAngle)),
        eraser,
      );
    }

    canvas.drawArc(
      Rect.fromLTWH(
          -piePadding, pieSize - piePadding, 2 * piePadding, 2 * piePadding),
      -totalAngle / 2,
      totalAngle,
      true,
      fillEraser,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
