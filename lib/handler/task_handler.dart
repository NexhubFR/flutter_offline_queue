import 'package:otter/database/database_provider.dart';
import 'package:otter/model/task.dart';

abstract class DefaultOTTaskHandler {
  Future<void> didFinish(OTTask task);
  void didSuccess(OTTask task, String response);
  void didFail(OTTask task, Object? error, StackTrace stackTrace);
}

/// `OTTaskHandler` Handles post-processing task
class OTTaskHandler implements DefaultOTTaskHandler {
  final _databaseProvider = OTDBProvider();

  /// Handles task failure.
  ///
  /// This method is invoked when an error occurs during task processing.
  /// It provides a way to handle or log errors associated with a specific `OTTask`.
  ///
  /// Parameters:
  /// - `task`: The task that failed.
  /// - `error`: The error encountered during processing, which may be `null`.
  /// - `stackTrace`: The stack trace associated with the error, providing context for debugging.
  ///
  @override
  void didFail(OTTask task, Object? error, StackTrace stackTrace) {}

  /// Completes processing of a given task.
  ///
  /// Upon successfully finishing the processing of a task,
  /// this method removes the task from the database using its UUID.
  /// This signifies that the task no longer needs to be tracked or processed further.
  ///
  /// Parameters:
  /// - `task`: The `OTTask` that has been processed and needs to be removed from persistence.
  ///
  @override
  Future<void> didFinish(OTTask task) async {
    await _databaseProvider.eraseTask(task.uuid);
  }

  /// Handles the successful completion of a task.
  ///
  /// This callback is invoked when a task is completed successfully,
  /// allowing for any post-success logic.
  ///
  /// Parameters:
  /// - `task`: The `OTTask` that succeeded.
  /// - `response`: The success response associated with the task completion.
  ///               This could be data returned from a network request or a confirmation message.
  ///
  @override
  void didSuccess(OTTask task, String response) {}
}
