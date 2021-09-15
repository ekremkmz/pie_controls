import 'package:flutter/material.dart';
import 'package:pie_controls/src/pie_controls_item.dart';
import 'package:pie_controls/src/pie_drawer.dart';
import 'dart:math' as math;

class PieControls extends StatefulWidget {
  const PieControls({
    Key? key,
    required this.child,
    required this.pies,
    this.pieSize = 80,
    this.piePadding = 30,
    this.pieMargin = 4,
    this.angle = math.pi,
    this.color = Colors.orange,
    this.triggerAreaSize = 15,
    this.showTriggerArea = false,
    required this.triggerPositions,
  }) : super(key: key);

  final Widget child;

  final List<PieControlsItem> pies;

  final double pieSize;

  final double piePadding;

  final double pieMargin;

  final double angle;

  final Color color;

  final bool showTriggerArea;

  final double triggerAreaSize;

  final List<TriggerPositions> triggerPositions;

  @override
  State<PieControls> createState() => _PieControlsState();
}

class _PieControlsState extends State<PieControls> {
  final ValueNotifier<bool> _triggered = ValueNotifier<bool>(false);
  late TriggerPositions _triggeredPosition;
  final ValueNotifier<Offset> _currentOffsetFromLocal =
      ValueNotifier<Offset>(Offset.zero);
  Offset _triggerStartedOffsetFromLocal = Offset.zero;
  Offset _triggerStartedOffsetFromParent = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            widget.child,
            ...widget.triggerPositions
                .map((e) => _buildTriggerArea(e, constraints))
                .toList(),
            ValueListenableBuilder<bool>(
              valueListenable: _triggered,
              builder: (context, value, child) =>
                  value ? _buildPieDrawer(constraints) : Container(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPieDrawer(BoxConstraints constraints) {
    double? _top, _bottom, _left, _right;
    switch (_triggeredPosition.alignement) {
      case TriggerAlignement.top:
        _top = widget.triggerAreaSize;
        _bottom = null;

        double pieStartingPoint =
            _triggerStartedOffsetFromParent.dx - widget.pieSize;
        double pieEndingPoint =
            _triggerStartedOffsetFromParent.dx + widget.pieSize;

        if (pieStartingPoint.isNegative) {
          pieEndingPoint += pieStartingPoint.abs();
          pieStartingPoint = 0.0;
        }
        if (pieEndingPoint > constraints.maxWidth) {
          double dx = pieEndingPoint - constraints.maxWidth;
          pieStartingPoint -= dx;
          pieEndingPoint -= dx;
        }
        _left = pieStartingPoint;
        _right = constraints.maxWidth - pieEndingPoint;
        _triggerStartedOffsetFromParent = Offset(
          (pieEndingPoint - pieStartingPoint) / 2,
          _triggerStartedOffsetFromLocal.dy,
        );
        break;
      case TriggerAlignement.bottom:
        _top = null;
        _bottom = widget.triggerAreaSize;

        double pieStartingPoint =
            _triggerStartedOffsetFromParent.dx - widget.pieSize;
        double pieEndingPoint =
            _triggerStartedOffsetFromParent.dx + widget.pieSize;

        if (pieStartingPoint.isNegative) {
          pieEndingPoint += pieStartingPoint.abs();
          pieStartingPoint = 0.0;
        }
        if (pieEndingPoint > constraints.maxWidth) {
          double dx = pieEndingPoint - constraints.maxWidth;
          pieStartingPoint -= dx;
          pieEndingPoint -= dx;
        }
        _left = pieStartingPoint;
        _right = constraints.maxWidth - pieEndingPoint;
        _triggerStartedOffsetFromParent = Offset(
          (pieEndingPoint - pieStartingPoint) / 2,
          _triggerStartedOffsetFromLocal.dy,
        );
        break;
      case TriggerAlignement.left:
        _left = widget.triggerAreaSize;
        _right = null;

        double pieStartingPoint =
            _triggerStartedOffsetFromParent.dy - widget.pieSize;
        double pieEndingPoint =
            _triggerStartedOffsetFromParent.dy + widget.pieSize;

        if (pieStartingPoint.isNegative) {
          pieEndingPoint += pieStartingPoint.abs();
          pieStartingPoint = 0.0;
        }
        if (pieEndingPoint > constraints.maxHeight) {
          double dx = pieEndingPoint - constraints.maxHeight;
          pieStartingPoint -= dx;
          pieEndingPoint -= dx;
        }
        _top = pieStartingPoint;
        _bottom = constraints.maxHeight - pieEndingPoint;
        _triggerStartedOffsetFromParent = Offset(
          _triggerStartedOffsetFromLocal.dx,
          (pieEndingPoint - pieStartingPoint) / 2,
        );
        break;
      case TriggerAlignement.right:
        _left = null;
        _right = widget.triggerAreaSize;

        double pieStartingPoint =
            _triggerStartedOffsetFromParent.dy - widget.pieSize;
        double pieEndingPoint =
            _triggerStartedOffsetFromParent.dy + widget.pieSize;

        if (pieStartingPoint.isNegative) {
          pieEndingPoint += pieStartingPoint.abs();
          pieStartingPoint = 0.0;
        }
        if (pieEndingPoint > constraints.maxHeight) {
          double dx = pieEndingPoint - constraints.maxHeight;
          pieStartingPoint -= dx;
          pieEndingPoint -= dx;
        }
        _top = pieStartingPoint;
        _bottom = constraints.maxHeight - pieEndingPoint;
        _triggerStartedOffsetFromParent = Offset(
          _triggerStartedOffsetFromLocal.dx,
          (pieEndingPoint - pieStartingPoint) / 2,
        );
        break;
    }
    return Positioned(
      top: _top,
      bottom: _bottom,
      left: _left,
      right: _right,
      child: PieDrawer(
        pieMargin: widget.pieMargin,
        angle: widget.angle,
        color: widget.color,
        piePadding: widget.piePadding,
        pies: widget.pies,
        pieSize: widget.pieSize,
        alignement: _triggeredPosition.alignement,
        currentOffsetFromLocal: _currentOffsetFromLocal,
        triggerStartedOffset: _triggerStartedOffsetFromLocal,
      ),
    );
  }

  Widget _buildTriggerArea(
      TriggerPositions triggerPositions, BoxConstraints constraints) {
    final _alignement = triggerPositions.alignement;

    final _vertical = const [TriggerAlignement.left, TriggerAlignement.right]
        .contains(_alignement);
    final _top = _alignement == TriggerAlignement.top
        ? 0.0
        : !_vertical
            ? null
            : triggerPositions.startMargin;
    final _bottom = _alignement == TriggerAlignement.bottom
        ? 0.0
        : !_vertical
            ? null
            : triggerPositions.endMargin;
    final _left = _alignement == TriggerAlignement.left
        ? 0.0
        : _vertical
            ? null
            : triggerPositions.startMargin;
    final _right = _alignement == TriggerAlignement.right
        ? 0.0
        : _vertical
            ? null
            : triggerPositions.endMargin;
    final _size = triggerPositions.size;
    final _height = _vertical ? _size : widget.triggerAreaSize;
    final _width = !_vertical ? _size : widget.triggerAreaSize;
    return Positioned(
      top: _top,
      bottom: _bottom,
      left: _left,
      right: _right,
      child: GestureDetector(
        onPanUpdate: (details) => _handleOnPanUpdate(
            details, _vertical, triggerPositions, constraints),
        child: Container(
          color: widget.showTriggerArea ? Colors.blue : Colors.transparent,
          height: _height,
          width: _width,
        ),
      ),
    );
  }

  void _handleOnPanUpdate(DragUpdateDetails details, bool vertical,
      TriggerPositions triggerPositions, BoxConstraints constraints) {
    final _localOffset = details.localPosition;
    final double _primary, _secondary, _secondarySize;
    if (vertical) {
      _primary = _localOffset.dx;
      _secondary = _localOffset.dy;
      _secondarySize = triggerPositions.size ??
          (constraints.maxHeight -
              triggerPositions.startMargin! -
              triggerPositions.endMargin!);
    } else {
      _primary = _localOffset.dy;
      _secondary = _localOffset.dx;
      _secondarySize = triggerPositions.size ??
          (constraints.maxWidth -
              triggerPositions.startMargin! -
              triggerPositions.endMargin!);
    }
    bool negative;
    if (!_triggered.value &&
        ((negative = (_primary < 0)) || _primary > widget.triggerAreaSize) &&
        (_secondary > 0 && _secondary < _secondarySize)) {
      final _dx = !vertical
          ? _localOffset.dx
          : negative
              ? 0.0
              : widget.triggerAreaSize;
      final _dy = vertical
          ? _localOffset.dy
          : negative
              ? 0.0
              : widget.triggerAreaSize;
      _triggerStartedOffsetFromLocal = Offset(_dx, _dy);
      _triggerStartedOffsetFromParent = _calculateParentOffset(
        _triggerStartedOffsetFromLocal,
        triggerPositions,
        vertical,
        constraints,
      );
      _triggeredPosition = triggerPositions;
      _triggered.value = true;
    }
    if (_triggered.value && _primary > 0 && _primary < widget.triggerAreaSize) {
      _triggered.value = false;
    }
    if (_triggered.value) {
      _currentOffsetFromLocal.value = _localOffset;
      Offset _currentOffsetFromTriggered =
          _localOffset - _triggerStartedOffsetFromLocal;
      debugPrint(_currentOffsetFromTriggered.direction.toString() +
          " " +
          _currentOffsetFromTriggered.distance.toString());
    }
  }

  static Offset _calculateParentOffset(
      Offset triggerStartedOffsetFromLocal,
      TriggerPositions triggerPositions,
      bool vertical,
      BoxConstraints constraints) {
    double startMargin = triggerPositions.startMargin ??
        ((vertical ? constraints.maxHeight : constraints.maxWidth) -
            (triggerPositions.size! + triggerPositions.endMargin!));
    return Offset(
      vertical
          ? triggerStartedOffsetFromLocal.dx
          : startMargin + triggerStartedOffsetFromLocal.dx,
      vertical
          ? startMargin + triggerStartedOffsetFromLocal.dy
          : triggerStartedOffsetFromLocal.dy,
    );
  }
}

@immutable
class TriggerPositions {
  /// Only two out of three size values ([startMargin],[size],[endMargin]) can
  /// be set. At least one of the three must be null.
  const TriggerPositions({
    this.startMargin,
    this.size,
    this.endMargin,
    required this.alignement,
  }) : assert(
          startMargin == null || size == null || endMargin == null,
          "Only two out of three size values ([startMargin],[size],[endMargin]) can be set.",
        );

  final double? startMargin;

  final double? size;

  final double? endMargin;

  final TriggerAlignement alignement;
}

enum TriggerAlignement { top, bottom, left, right }
