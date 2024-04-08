import 'package:flutter/material.dart';

import 'package:otter/otter.dart';

import 'package:example/src/app.dart';
import 'package:example/src/otter/example_task_handler.dart';

Future<void> main() async {
  runApp(const App());
  Otter.init(ExampleTaskHandler());
}
