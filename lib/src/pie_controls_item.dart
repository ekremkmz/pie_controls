import 'package:flutter/material.dart';

class PieControlsItem extends StatelessWidget {
  const PieControlsItem({
    Key? key,
    required this.child,
    required this.childSize,
    this.onTriggered,
    this.onHover,
  }) : super(key: key);

  final Widget child;

  final double childSize;

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
