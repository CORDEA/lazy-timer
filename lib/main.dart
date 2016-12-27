import 'dart:core' hide Stopwatch;
import 'package:flutter/material.dart';
import 'stopwatch.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'Lazy Timer',
      theme: new ThemeData(
          primarySwatch: Colors.teal, accentColor: Colors.amber[500]),
      home: new LazyTimer(),
    ),
  );
}

class LazyTimer extends StatefulWidget {
  LazyTimer({Key key}) : super(key: key);

  @override
  _StopwatchState createState() => new _StopwatchState();
}

class _StopwatchState extends State<LazyTimer> with TickerProviderStateMixin {
  final _margin = 16.0;

  double _currentValue = 0.0;

  Stopwatch _stopwatch;

  String _currentTime;

  Color _textColor = Colors.white;

  bool _isRemaining = false;

  String _toString(Duration duration) {
    var fixDigits = (int n) {
      if (n >= 10) {
        return "$n";
      }
      return "0$n";
    };
    var min = duration.inMinutes.remainder(Duration.MINUTES_PER_HOUR).abs();
    var sec = duration.inSeconds.remainder(Duration.SECONDS_PER_MINUTE).abs();
    if (min == 0) {
      return "${fixDigits(sec)}";
    }
    return "${min} ${fixDigits(sec)}";
  }

  String _remainingTime() {
    var min = (_currentValue * 10).floor();
    var sec = (((_currentValue * 10) % 1) * 100).floor();
    var remaining =
        new Duration(minutes: min, seconds: sec) - _stopwatch.current;
    if (remaining.isNegative) {
      _textColor = Colors.red[500];
    } else {
      _textColor = Colors.white;
    }
    return remaining.isNegative
        ? "-${_toString(remaining)}"
        : _toString(remaining);
  }

  @override
  void initState() {
    super.initState();

    _stopwatch = new Stopwatch(() {
      setState(() {
        _currentTime = _toString(_stopwatch.current);
      });
    });
    _currentTime = _toString(_stopwatch.current);
  }

  Widget _buildBody() {
    return new Container(
        decoration: new BoxDecoration(backgroundColor: Colors.teal[500]),
        child: new Stack(children: [
          new Positioned(
              bottom: _margin,
              left: 0.0,
              right: 0.0,
              child: new Column(children: [
                new Slider(
                    value: _currentValue,
                    onChanged: (v) {
                      setState(() {
                        _currentValue = v;
                      });
                    }),
                new Container(
                    margin: new EdgeInsets.only(
                        top: _margin,
                        bottom: _margin,
                        left: _margin * 2,
                        right: _margin * 2),
                    child: new Stack(children: [
                      new Align(
                          alignment: FractionalOffset.center,
                          child: new FloatingActionButton(
                              child: new Icon(Icons.timer),
                              onPressed: () {
                                if (_stopwatch.isRunning) {
                                  _stopwatch.stop();
                                } else {
                                  _stopwatch.start();
                                }
                              })),
                      new Align(
                          alignment: FractionalOffset.centerLeft,
                          child: new Material(
                              type: MaterialType.circle,
                              child: new Container(
                                  width: 56.0,
                                  height: 56.0,
                                  child: new InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isRemaining = !_isRemaining;
                                        });
                                      },
                                      child: new IconTheme.merge(
                                          context: context,
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: new Icon(_isRemaining
                                              ? Icons.rotate_left
                                              : Icons.rotate_right))))))
                    ])),
              ])),
          new Align(
              alignment: FractionalOffset.center,
              child: new Container(
                  margin: new EdgeInsets.only(bottom: 64.0),
                  child: new Column(mainAxisSize: MainAxisSize.min, children: [
                    new Text(_isRemaining ? _remainingTime() : _currentTime,
                        style: new TextStyle(color: _textColor, fontSize: 72.0))
                  ])))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: _buildBody());
  }
}
