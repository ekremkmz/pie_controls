import 'package:flutter/material.dart';
import 'dart:math' as math;

class PieControlsItem extends StatelessWidget {
  const PieControlsItem({
    Key? key,
    required this.child,
    this.maxChildHeight = 100,
    this.maxChildWidth = 100,
    required this.angle,
    this.onTriggered,
    this.onHover,
  })  : assert(angle <= math.pi),
        super(key: key);

  final Widget child;

  final double maxChildHeight;

  final double maxChildWidth;

  final double angle;

  final VoidCallback? onTriggered;

  final VoidCallback? onHover;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxChildHeight,
      width: maxChildWidth,
      child: Center(
        child: child,
      ),
    );
  }
}
