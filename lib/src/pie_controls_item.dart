import 'package:flutter/material.dart';
import 'dart:math' as math;

class PieControlsItem extends StatelessWidget {
  const PieControlsItem({
    Key? key,
    required this.child,
    required this.childSize,
    required this.angle,
    this.onTriggered,
    this.onHover,
  })  : assert(angle <= math.pi),
        super(key: key);

  final Widget child;

  final double childSize;

  final double angle;

  final VoidCallback? onTriggered;

  final VoidCallback? onHover;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: childSize,
      width: childSize,
      child: child,
    );
  }
}
