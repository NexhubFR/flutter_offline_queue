import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:otter/handler/task_handler.dart';
import 'package:otter/model/task.dart';
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/otter.dart';

void main() {
  runApp(const App());
  Otter.init(ExampleTaskHandler());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CRUDScreen(),
    );
  }
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

class CRUDScreen extends StatelessWidget {
  final store = OTDBStore();

  final baseUrl = 'dummyjson.com';
  final pathToOneProduct = '/products/1';
  final pathToAddProduct = '/products/add';

  CRUDScreen({super.key});

  void storeTask(ExampleTask task) {
    store.addOneTask(
      task,
      didFail: (task, error, stackTrace) => {log('$task, $error, $stackTrace')},
      networkAvailable: () => {log('Network is available')},
    );
  }

  void get() {
    storeTask(ExampleTask(
        Uri.https(baseUrl, pathToOneProduct), HTTPMethod.get, {}, {}));
  }

  void post() {
    storeTask(ExampleTask(Uri.https(baseUrl, pathToAddProduct), HTTPMethod.post,
        {'Content-Type': 'application/json'}, {'title': 'POST'}));
  }

  void patch() {
    storeTask(ExampleTask(
        Uri.https(baseUrl, pathToOneProduct),
        HTTPMethod.patch,
        {'Content-Type': 'application/json'},
        {'title': 'PATCH'}));
  }

  void put() {
    storeTask(ExampleTask(Uri.https(baseUrl, pathToOneProduct), HTTPMethod.put,
        {'Content-Type': 'application/json'}, {'title': 'PUT'}));
  }

  void delete() {
    storeTask(ExampleTask(
        Uri.https(baseUrl, pathToOneProduct), HTTPMethod.delete, {}, {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBB8ED).withOpacity(0.2),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Otter 🦦',
              style: TextStyle(
                  color: Color(0xFFDBB8ED),
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
            ),
            button(context, 'GET', () => get()),
            button(context, 'POST', () => post()),
            button(context, 'PATCH', () => patch()),
            button(context, 'PUT', () => put()),
            button(context, 'DELETE', () => delete())
          ]),
    );
  }

  Widget button(BuildContext context, String text, void Function() onPressed) {
    return Center(
        child: Container(
            width: 300,
            height: 50,
            margin: const EdgeInsets.all(10),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFDBB8ED)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFDBB8ED).withOpacity(0.3))),
              onPressed: onPressed,
              child: Text(text),
            )));
  }
}
