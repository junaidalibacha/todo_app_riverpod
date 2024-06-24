import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  Debounce({
    this.milliseconds = 500,
  });

  final int milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    close();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void close() {
    if (_timer != null) _timer?.cancel();
  }
}
