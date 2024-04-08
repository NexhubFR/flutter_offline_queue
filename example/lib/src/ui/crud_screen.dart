import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:example/src/otter/example_task.dart';

import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';

class CRUDScreen extends StatelessWidget {
  final store = OTDBStore();

  CRUDScreen({super.key});

  void get() {
    final task = ExampleTask(Uri.https('dummyjson.com', '/products/1'),
        HTTPMethod.get, {'Content-Type': 'application/json'}, {});

    store.addOneTask(
      task,
      didFail: (task, error, stackTrace) => {log('$task, $error, $stackTrace')},
      networkAvailable: () => {log('Network is available')},
    );
  }

  void post() {
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

  void patch() {
    final task = ExampleTask(
        Uri.https('dummyjson.com', '/products/1'),
        HTTPMethod.patch,
        {'Content-Type': 'application/json'},
        {'title': 'iPhone Galaxy +1'});

    store.addOneTask(
      task,
      didFail: (task, error, stackTrace) => {log('$task, $error, $stackTrace')},
      networkAvailable: () => {log('Network is available')},
    );
  }

  void put() {
    final task = ExampleTask(
        Uri.https('dummyjson.com', '/products/1'),
        HTTPMethod.put,
        {'Content-Type': 'application/json'},
        {'title': 'iPhone Galaxy +1'});

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
            button('GET', () => get()),
            button('POST', () => post()),
            button('PATCH', () => patch()),
            button('PUT', () => put()),
          ]),
    );
  }

  Widget button(String text, void Function() onPressed) {
    return Center(
        child: TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: onPressed,
      child: Text(text),
    ));
  }
}
