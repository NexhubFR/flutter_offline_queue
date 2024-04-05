import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_offline_queue/core/task_handler.dart';
import 'package:flutter_offline_queue/core/task_processor.dart';
import 'package:flutter_offline_queue/foq.dart';
import 'package:flutter_offline_queue/enum/http_method.dart';
import 'package:flutter_offline_queue/model/task.dart';

void main() {
  runApp(const App());
  FOQ().init(ExampleTaskHandler());
}

class ExampleTask extends FOQTask {
  ExampleTask(super.uri, super.method, super.headers, super.body);
}

class ExampleTaskHandler extends FOQTaskHandler {
  @override
  void didFail(FOQTask task, Object? error, StackTrace stackTrace) {
    log('didFail: $task, $error, $stackTrace');
  }

  @override
  Future<void> didFinish(FOQTask task) async {
    await super.didFinish(task);
    log('didFinish: $task');
  }

  @override
  void didSuccess(FOQTask task, String response) {
    log('didSuccess: $task, $response');
  }
}

void post() {
  final processor = FOQTaskProcessor();

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
