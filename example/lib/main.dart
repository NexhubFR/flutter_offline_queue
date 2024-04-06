import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:otter/core/task_handler.dart';
import 'package:otter/core/task_processor.dart';
import 'package:otter/otter.dart';
import 'package:otter/enum/http_method.dart';
import 'package:otter/model/task.dart';

void main() {
  runApp(const App());
  Otter.init(ExampleTaskHandler());
}

class ExampleTask extends OTTask {
  ExampleTask(super.uri, super.method, super.headers, super.body);
}

class ExampleTaskHandler extends OTTaskHandler {
  @override
  void didFail(OTTask task, Object? error, StackTrace stackTrace) {
    log('didFail: $task, $error, $stackTrace');
  }

  @override
  Future<void> didFinish(OTTask task) async {
    await super.didFinish(task);
    log('didFinish: $task');
  }

  @override
  void didSuccess(OTTask task, String response) {
    log('didSuccess: $task, $response');
  }
}

void post() {
  final processor = OTTaskProcessor();

  final url = Uri.https('dummyjson.com', '/products/add');
  final headers = {'Content-Type': 'application/json'};
  final body = {'title': 'BMW Pencil'};
  final task = ExampleTask(url, HTTPMethod.post, headers, body);

  processor.executeOneTask(task, ExampleTaskHandler());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () => post(),
              child: const Text('POST'),
            )),
          ]),
    );
  }
}
