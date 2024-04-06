import 'package:flutter/material.dart';

import 'package:example/src/app.dart';

import 'package:otter/otter.dart';
import 'package:example/src/otter/example_task_handler.dart';

void main() {
  runApp(const App());
  Otter.init(ExampleTaskHandler());
}
