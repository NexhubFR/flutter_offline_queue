import 'package:flutter/material.dart';

import 'package:example/src/otter/example_task.dart';
import 'package:example/src/otter/example_task_handler.dart';

import 'package:otter/enum/http_method.dart';
import 'package:otter/core/task_processor.dart';

class CRUDScreen extends StatelessWidget {
  const CRUDScreen({super.key});

  void post() {
    final processor = OTTaskProcessor();

    final url = Uri.https('dummyjson.com', '/products/add');
    final headers = {'Content-Type': 'application/json'};
    final body = {'title': 'BMW Pencil'};
    final task = ExampleTask(url, HTTPMethod.post, headers, body);

    processor.executeOneTask(task, ExampleTaskHandler(), true);
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
