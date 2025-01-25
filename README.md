# <img src="https://raw.githubusercontent.com/NexhubFR/otter/v1.0.0/resources/icon.jpg" width="30"> Otter

#### 🚨 This project is no longer maintained. Its sole purpose was to explore and test the creation and development of a Flutter package.

<img src="https://raw.githubusercontent.com/NexhubFR/otter/v1.0.0/resources/banner.jpg">

> Flutter plugin designed to simplify the management of HTTP requests in offline mode :
> - Cache HTTP requests in the event of network unavailability.
> - Monitor network connectivity status continuously.
> - Process and dispatch cached HTTP requests upon restoration of network access.

## Installation

```yml
dependencies:
    otter: ^1.0.3
```

## Configuration

> Here's a simple configuration. 

*⚠️ Note that you can create your own OTTaskHandler and pass it as a parameter to the init() function. [Example](#custom-ottaskhandler)*

```dart
import 'package:otter/handler/task_handler.dart';
import 'package:otter/database/database_provider.dart';
import 'package:otter/network/network_helper.dart';

void main() async {
  runApp(const App());
  Otter.init(OTTaskHandler());
}
```

## Using

*⚠️ Note that you can create your own OTTask and pass it as a parameter to the addOneTask() or addMultipleTasks() functions. [Example](#custom-ottask)*

### addOneTask

#### GET

```dart
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/model/task.dart';

final store = OTDBStore();
final task = OTTask(Uri.https('example.com', '/path/example'), HTTPMethod.get, {}, {});

store.addOneTask(
    task,
    didFail: (task, error, stackTrace) => {
        // Handle error saving here
    },
    networkAvailable: () => {
        // Perform HTTP request here, if network is available
    },
);
```

#### POST

```dart
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/model/task.dart';

final store = OTDBStore();

final task = OTTask(Uri.https('example.com', '/path/example'),HTTPMethod.post, 
                {'Content-Type': 'application/json'}, {'key': 'value'});

store.addOneTask(
    task,
    didFail: (task, error, stackTrace) => {
        // Handle error saving here
    },
    networkAvailable: () => {
        // Perform HTTP request here, if network is available
    },
);
```

#### PATCH

```dart
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/model/task.dart';

final store = OTDBStore();

final task = OTTask(Uri.https('example.com', '/path/example'), HTTPMethod.patch, 
                {'Content-Type': 'application/json'}, {'key': 'value'});

store.addOneTask(
    task,
    didFail: (task, error, stackTrace) => {
        // Handle error saving here
    },
    networkAvailable: () => {
        // Perform HTTP request here, if network is available
    },
);
```

#### PUT

```dart
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/model/task.dart';

final store = OTDBStore();

final task = OTTask(Uri.https('example.com', '/path/example'), HTTPMethod.put, 
                {'Content-Type': 'application/json'}, {'key': 'value'});

store.addOneTask(
    task,
    didFail: (task, error, stackTrace) => {
        // Handle error saving here
    },
    networkAvailable: () => {
        // Perform HTTP request here, if network is available
    },
);
```

#### DELETE

```dart
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/model/task.dart';

final store = OTDBStore();

final task = OTTask(Uri.https('example.com', '/path/example'), HTTPMethod.delete, {}, {});

store.addOneTask(
    task,
    didFail: (task, error, stackTrace) => {
        // Handle error saving here
    },
    networkAvailable: () => {
        // Perform HTTP request here, if network is available
    },
);
```

### addMultipleTasks

```dart
import 'package:otter/network/http_method.dart';
import 'package:otter/database/database_store.dart';
import 'package:otter/model/task.dart';

final store = OTDBStore();

final getTask = OTTask(Uri.https('example.com', '/path/example'), HTTPMethod.get, {}, {});
final postTask = OTTask(Uri.https('example.com', '/path/example'),HTTPMethod.post, 
                {'Content-Type': 'application/json'}, {'key': 'value'});
final deleteTask = OTTask(Uri.https('example.com', '/path/example'), HTTPMethod.delete, {}, {});

store.addMultipleTasks(
    [getTask, postTask, deleteTask],
    didFail: (task, error, stackTrace) => {
        // Handle error saving here
    },
    networkAvailable: () => {
        // Perform HTTP request here, if network is available
    },
);
```

---

### Custom OTTaskHandler

> TaskHandler is an important concept in Otter. 
> It is in this class that the post-processing of HTTP requests is managed.

```dart
import 'package:otter/handler/task_handler.dart';
import 'package:otter/model/task.dart';

class ExampleTaskHandler extends OTTaskHandler {
  @override
  void didFail(OTTask task, Object? error, StackTrace stackTrace) {
    // Handle task failure
  }

  @override
  Future<void> didFinish(OTTask task) async {
    await super.didFinish(task);
    // Complete processing of a given task
  }

  @override
  void didSuccess(OTTask task, String response) {
    // Handle the successful completion of a task
  }
}
```

### Custom OTTask

> Task is a representation of HTTP request

```dart
import 'package:otter/model/task.dart';

class ExampleTask extends OTTask {
  ExampleTask(super.uri, super.method, super.headers, super.body);
}
```

---

> support@nexhub.fr
