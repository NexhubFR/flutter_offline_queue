import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:example/src/otter/example_task.dart';

import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';

class CRUDScreen extends StatelessWidget {
  const CRUDScreen({super.key});

  void post() {
    final store = OTDBStore();

    final task = ExampleTask(
        Uri.https('dummyjson.com', '/products/add'),
        HTTPMethod.post,
        {'Content-Type': 'application/json'},
        {'title': 'BMW Pencil'});

    store.addOneTask(
      task,
      didFail: (task, error, stackTrace) => {log('$task, $error, $stackTrace')},
      networkAvailable: () => {log('Network is available')},
    );
  }

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
