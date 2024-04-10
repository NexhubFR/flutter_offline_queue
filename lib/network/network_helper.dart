import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:otter/handler/task_handler.dart';
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_provider.dart';
import 'package:otter/model/task.dart';
import 'package:synchronized/synchronized.dart';
import 'package:http/http.dart' as http;

abstract class DefaultOTNetworkHelper {
  Future<void> execute(List<OTTask> tasks, DefaultOTTaskHandler handler);
  Future<void> get(OTTask task, OTTaskHandler handler);
  Future<void> post(OTTask task, OTTaskHandler handler);
  Future<void> patch(OTTask task, OTTaskHandler handler);
  Future<void> put(OTTask task, OTTaskHandler handler);
  Future<void> delete(OTTask task, OTTaskHandler handler);
}

class OTNetworkHelper implements DefaultOTNetworkHelper {
  final OTDBProvider _databaseProvider = OTDBProvider();

  final DefaultOTTaskHandler _handler;

  OTNetworkHelper(this._handler);

  /// Monitors connectivity changes to process tasks when the network is available.
  ///
  /// This method sets up a listener for connectivity changes using `Connectivity().onConnectivityChanged`.
  /// Upon detecting a connectivity change, if the device is not disconnected (`ConnectivityResult.none`),
  /// it:
  /// - Acquires a reentrant lock to ensure synchronized access to the following operations.
  /// - Fetches tasks from the database using `_databaseProvider.getTasks()`.
  /// - If there are tasks, it calls `execute(tasks, _handler)` to process them.
  ///
  /// This method ensures tasks are only executed when network connectivity is available,
  /// preventing unnecessary processing attempts during offline periods.
  void observe() {
    var lock = Lock(reentrant: true);

    Connectivity().onConnectivityChanged.listen((event) async {
      if (event.first != ConnectivityResult.none) {
        await lock.synchronized(() async {
          final tasks = await _databaseProvider.getTasks();

          if (tasks.isNotEmpty) {
            await execute(tasks, _handler);
          }
        });
      }
    });
  }

  /// Executes a list of tasks using the specified handler.
  ///
  /// Iterates over the provided list of `OTTask` objects and executes them based
  /// on their HTTP method (`get`, `post`, `patch`, `put`, `delete`).
  /// After each task is executed, it calls `handler.didFinish(task)` to signal completion.
  ///
  /// Parameters:
  /// - `tasks`: The list of tasks to be executed.
  /// - `handler`: The `DefaultOTTaskHandler` used to handle task completion.
  ///
  /// This method ensures that each task is processed according to
  /// its specified method and properly signals when it's finished.
  @override
  Future<void> execute(List<OTTask> tasks, DefaultOTTaskHandler handler) async {
    for (var task in tasks) {
      switch (task.method) {
        case HTTPMethod.get:
          await get(task, handler);
        case HTTPMethod.post:
          await post(task, handler);
        case HTTPMethod.patch:
          await patch(task, handler);
        case HTTPMethod.put:
          await put(task, handler);
        case HTTPMethod.delete:
          await delete(task, handler);
      }

      await handler.didFinish(task);
    }
  }

  /// Executes a GET request for the specified task.
  ///
  /// Performs an HTTP GET request using the task's URI.
  /// Upon successful completion, it invokes `handler.didSuccess` with the task and response body.
  /// If an error occurs, `handler.didFail` is called with the task, error, and stack trace.
  ///
  /// Parameters:
  /// - `task`: The `OTTask` object representing the task to be executed.
  ///           Its `uri` property specifies the endpoint for the GET request.
  /// - `handler`: The `DefaultOTTaskHandler` responsible for handling the success or failure of the task.
  ///
  @override
  Future<void> get(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .get(task.uri)
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  /// Executes a POST request for the given task.
  ///
  /// Sends an HTTP POST request using the task's URI, headers, and body.
  /// On success, it calls `handler.didSuccess` with the task and the response body.
  /// If an error occurs, `handler.didFail` is invoked with the task, the error,
  /// and the stack trace for handling the failure.
  ///
  /// Parameters:
  /// - `task`: The `OTTask` to be executed, containing the endpoint URI,
  ///           request headers, and the body of the request.
  /// - `handler`: The `DefaultOTTaskHandler` used to handle the outcome of the task,
  ///              whether successful or failed.
  ///
  @override
  Future<void> post(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .post(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  /// Executes a PATCH request for the specified task.
  ///
  /// This method performs an HTTP PATCH request to the task's URI
  /// with the provided headers and body.
  /// On successful completion of the request,
  /// it triggers `handler.didSuccess` with the task and response body.
  /// In case of an error, it invokes `handler.didFail` with the task,
  /// the encountered error, and the stack trace.
  ///
  /// Parameters:
  /// - `task`: The `OTTask` detailing the request, including the URI,
  ///           headers, and the JSON-encoded body.
  /// - `handler`: The `DefaultOTTaskHandler` for managing the task's outcome,
  ///              addressing both success and failure scenarios.
  ///
  @override
  Future<void> patch(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .patch(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  /// Executes a PUT request for the given task.
  ///
  /// Sends an HTTP PUT request to the specified URI of the task with
  /// the provided headers and a JSON-encoded body. Upon successful request completion,
  /// `handler.didSuccess` is invoked with the task and the response body.
  /// If an error occurs, `handler.didFail` is called with the task,
  /// the error, and the stack trace.
  ///
  /// Parameters:
  /// - `task`: The `OTTask` object containing the endpoint URI, headers, and the body for the request.
  /// - `handler`: The `DefaultOTTaskHandler` responsible for handling
  ///              the response to the request, managing both success and failure outcomes.
  ///
  @override
  Future<void> put(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .put(task.uri, headers: task.headers, body: jsonEncode(task.body))
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }

  /// Executes a DELETE request for the specified task.
  ///
  /// This method performs an HTTP DELETE request using the task's URI.
  /// Upon successfully completing the request,
  /// it invokes `handler.didSuccess` with the task and the response body.
  /// If the request fails, `handler.didFail` is called with the task,
  /// the error, and the stack trace.
  ///
  /// Parameters:
  /// - `task`: The `OTTask` representing the DELETE operation, including the endpoint URI.
  /// - `handler`: The `DefaultOTTaskHandler` tasked with managing the success
  ///              or failure of the delete operation.
  ///
  @override
  Future<void> delete(OTTask task, DefaultOTTaskHandler handler) async {
    await http
        .delete(task.uri)
        .then((value) => handler.didSuccess(task, value.body))
        .onError(
            (error, stackTrace) => handler.didFail(task, error, stackTrace));
  }
}
