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

class _MyHomePageState extends State<MyHomePage> {
  final _counter = ValueNotifier<int>(0);
  final _message = ValueNotifier<String>("");

  void _incrementCounter() {
    _counter.value++;
  }

  void _decrementCounter() {
    _counter.value--;
  }

  void _resetCounter() {
    _counter.value = 0;
  }

  void _hoveredIncrement() {
    _message.value = "Hovered increment";
  }

  void _hoveredDecrement() {
    _message.value = "Hovered decrement";
  }

  void _hoveredReset() {
    _message.value = "Hovered reset";
  }

  @override
  Widget build(BuildContext context) {
    return PieControls(
      pieSize: 100,
      showTriggerArea: true,
      pies: [
        PieControlsItem(
          onTriggered: _incrementCounter,
          onHover: _hoveredIncrement,
          child: const Icon(Icons.add),
          childSize: 24,
          angle: math.pi / 3,
        ),
        PieControlsItem(
          onHover: _hoveredDecrement,
          onTriggered: _decrementCounter,
          child: const Icon(Icons.remove),
          childSize: 24,
          angle: math.pi / 3,
        ),
        PieControlsItem(
          onHover: _hoveredReset,
          onTriggered: _resetCounter,
          child: const Icon(Icons.refresh),
          childSize: 24,
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
