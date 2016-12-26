import 'dart:async';
import 'dart:core' as core;

typedef void StopwatchCallback();

class Stopwatch {
  Stopwatch(StopwatchCallback callback) {
    _callback = callback;
    _stopwatch = new core.Stopwatch();
  }

  StopwatchCallback _callback;

  core.Stopwatch _stopwatch;

  Timer _timer;

  core.Duration _current = new core.Duration();

  core.Duration get current => _current;

  core.bool get isRunning => _stopwatch.isRunning;

  void start() {
    _stopwatch.start();
    _timer = new Timer.periodic(new core.Duration(milliseconds: 1000), (t) {
      _current = _stopwatch.elapsed;
      _onUpdate();
    });
  }

  void stop() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _onUpdate() {
    _callback();
  }
}
