import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_controls/pie_controls.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PieControls example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PieControls example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _counter = ValueNotifier<int>(0);
  final _message = ValueNotifier<String>("");
  List<AnimationController>? _pieAnimationControllers;
  @override
  void initState() {
    super.initState();
    _pieAnimationControllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ),
      ),
    );
  }

  void _incrementCounter() {
    _counter.value++;
    _message.value = "Triggered increment";
  }

  void _decrementCounter() {
    _counter.value--;
    _message.value = "Triggered decrement";
  }

  void _resetCounter() {
    _counter.value = 0;
    _message.value = "Triggered reset";
  }

  void _hoverIncrement() {
    _pieAnimationControllers![0].reset();
    _pieAnimationControllers![0].forward();
    _message.value = "Hovered increment";
  }

  void _hoverDecrement() {
    _pieAnimationControllers![1].reset();
    _pieAnimationControllers![1].forward();
    _message.value = "Hovered decrement";
  }

  void _hoverReset() {
    _pieAnimationControllers![2].reset();
    _pieAnimationControllers![2].forward();
    _message.value = "Hovered reset";
  }

  void _hoverEndIncrement() {
    _pieAnimationControllers![0].reset();
    _message.value = "";
  }

  void _hoverEndDecrement() {
    _pieAnimationControllers![1].reset();
    _message.value = "";
  }

  void _hoverEndReset() {
    _pieAnimationControllers![2].reset();
    _message.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return PieControls(
      pieSize: 100,
      showTriggerArea: true,
      pies: [
        PieControlsItem(
          onTriggered: _incrementCounter,
          onHover: _hoverIncrement,
          onHoverEnd: _hoverEndIncrement,
          child: AnimatedBuilder(
            child: const Icon(Icons.add),
            animation: _pieAnimationControllers![0],
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _pieAnimationControllers![0].value * 2 * math.pi,
                child: child,
              );
            },
          ),
          angle: math.pi / 3,
        ),
        PieControlsItem(
          onTriggered: _decrementCounter,
          onHover: _hoverDecrement,
          onHoverEnd: _hoverEndDecrement,
          child: AnimatedBuilder(
            child: const Icon(Icons.remove),
            animation: _pieAnimationControllers![1],
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _pieAnimationControllers![1].value * 2 * math.pi,
                child: child,
              );
            },
          ),
          angle: math.pi / 3,
        ),
        PieControlsItem(
          onHover: _hoverReset,
          onTriggered: _resetCounter,
          onHoverEnd: _hoverEndReset,
          child: AnimatedBuilder(
            child: const Icon(Icons.refresh),
            animation: _pieAnimationControllers![2],
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _pieAnimationControllers![2].value * 2 * math.pi,
                child: child,
              );
            },
          ),
          angle: math.pi / 6,
        ),
      ],
      triggerPositions: const [
        TriggerPositions(
          endMargin: 150,
          startMargin: 150,
          alignement: TriggerAlignement.right,
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                    'Trigger your pie controls from right side of your screen!',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center),
              ),
              const Text(
                'You have pushed the button this many times:',
              ),
              ValueListenableBuilder<int>(
                valueListenable: _counter,
                builder: (context, value, child) {
                  return Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  );
                },
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: _message,
                builder: (context, value, child) {
                  return Text(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
