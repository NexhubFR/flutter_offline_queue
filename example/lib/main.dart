import 'package:flutter/material.dart';
import 'package:flutter_offline_queue/database_manager.dart';
import 'package:flutter_offline_queue/http_method.dart';
import 'package:flutter_offline_queue/task.dart';
import 'package:flutter_offline_queue/task_sequencer.dart';

void main() {
  runApp(const App());
  FOQDatabaseManager().init();
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
              child: const Text("POST"),
            )),
          ]),
    );
  }

  void post() {
    var sequencer = FOQTaskSequencer();

    var url = Uri.https("dummyjson.com", "/products/add");
    var headers = {'Content-Type': 'application/json'};
    var body = {"title": 'BMW Pencil'};
    var task = FOQTask(url, HTTPMethod.post, headers, body);

    sequencer.execute([task],
        didSuccess: (response) => {print(response)},
        didFail: (error, stackTrace) => {print(error), print(stackTrace)});
  }
}
