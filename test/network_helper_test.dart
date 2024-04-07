import 'package:flutter_test/flutter_test.dart';

import 'package:otter/handler/task_handler.dart';
import 'package:otter/model/task.dart';
import 'package:otter/network/http_method.dart';
import 'package:otter/network/network_helper.dart';

void main() {
  requestsAreSuccessful();
  requestsAreUnsuccessful();
}

void requestsAreSuccessful() {
  group('Successful NetworkHelper Tests', () {
    late SuccessStubOTNetworkHelper successStubOTNetworkHelper;
    late MockOTTaskHandler mockOTTaskHandler;
    late bool didSuccessIsExecuted;
    late bool didFinishIsExecuted;

    setUp(() => {
          didSuccessIsExecuted = false,
          didFinishIsExecuted = false,
          mockOTTaskHandler = MockOTTaskHandler(
              didSucccesCallback: () => {didSuccessIsExecuted = true},
              didFinishCallback: () => {didFinishIsExecuted = true}),
          successStubOTNetworkHelper =
              SuccessStubOTNetworkHelper(mockOTTaskHandler),
        });

    test(
        'Successful OTNetworkHelper get',
        () async => {
              await successStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.get, {}, {})],
                  mockOTTaskHandler),
              expect(didSuccessIsExecuted, true),
              expect(didFinishIsExecuted, true)
            });

    test(
        'Successful OTNetworkHelper patch',
        () async => {
              await successStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.patch, {}, {})],
                  mockOTTaskHandler),
              expect(didSuccessIsExecuted, true),
              expect(didFinishIsExecuted, true)
            });
    test(
        'Successful OTNetworkHelper post',
        () async => {
              await successStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.post, {}, {})],
                  mockOTTaskHandler),
              expect(didSuccessIsExecuted, true),
              expect(didFinishIsExecuted, true)
            });

    test(
        'Successful OTNetworkHelper put',
        () async => {
              await successStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.put, {}, {})],
                  mockOTTaskHandler),
              expect(didSuccessIsExecuted, true),
              expect(didFinishIsExecuted, true),
            });
  });
}

void requestsAreUnsuccessful() {
  group('Unsuccessful NetworkHelper Tests', () {
    late FailStubOTNetworkHelper failStubOTNetworkHelper;
    late MockOTTaskHandler mockOTTaskHandler;
    late bool didFailIsExecuted = false;
    late bool didFinishIsExecuted = false;

    setUp(() => {
          didFailIsExecuted = false,
          didFinishIsExecuted = false,
          mockOTTaskHandler = MockOTTaskHandler(
            didFailCallback: () => {didFailIsExecuted = true},
            didFinishCallback: () => {didFinishIsExecuted = true},
          ),
          failStubOTNetworkHelper = FailStubOTNetworkHelper(mockOTTaskHandler),
        });

    test(
        'Unsuccessful OTNetworkHelper get',
        () async => {
              await failStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.get, {}, {})],
                  mockOTTaskHandler),
              expect(didFailIsExecuted, true),
              expect(didFinishIsExecuted, true)
            });

    test(
        'Unsuccessful OTNetworkHelper patch',
        () async => {
              await failStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.patch, {}, {})],
                  mockOTTaskHandler),
              expect(didFailIsExecuted, true),
              expect(didFinishIsExecuted, true)
            });

    test(
        'Unsuccessful OTNetworkHelper post',
        () async => {
              await failStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.post, {}, {})],
                  mockOTTaskHandler),
              expect(didFailIsExecuted, true),
              expect(didFinishIsExecuted, true)
            });

    test(
        'Unsuccessful OTNetworkHelper put',
        () async => {
              await failStubOTNetworkHelper.execute(
                  [OTTask(Uri.https('google.com'), HTTPMethod.put, {}, {})],
                  mockOTTaskHandler),
              expect(didFailIsExecuted, true),
              expect(didFinishIsExecuted, true)
            });
  });
}

class SuccessStubOTNetworkHelper extends OTNetworkHelper
    implements DefaultOTNetworkHelper {
  SuccessStubOTNetworkHelper(super.handler);

  @override
  Future<void> get(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didSuccess(task, 'get');
  }

  @override
  Future<void> patch(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didSuccess(task, 'patch');
  }

  @override
  Future<void> post(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didSuccess(task, 'post');
  }

  @override
  Future<void> put(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didSuccess(task, 'put');
  }
}

class FailStubOTNetworkHelper extends OTNetworkHelper
    implements DefaultOTNetworkHelper {
  FailStubOTNetworkHelper(super.handler);

  @override
  Future<void> get(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didFail(task, MockError('Get error'), MockStackTrace());
  }

  @override
  Future<void> patch(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didFail(task, MockError('Patch error'), MockStackTrace());
  }

  @override
  Future<void> post(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didFail(task, MockError('Post error'), MockStackTrace());
  }

  @override
  Future<void> put(OTTask task, DefaultOTTaskHandler handler) async {
    handler.didFail(task, MockError('Put error'), MockStackTrace());
  }
}

class MockOTTaskHandler implements DefaultOTTaskHandler {
  late Function()? didSucccesCallback;
  late Function()? didFailCallback;
  late Function() didFinishCallback;

  MockOTTaskHandler(
      {this.didSucccesCallback,
      this.didFailCallback,
      required this.didFinishCallback});

  @override
  void didFail(OTTask task, Object? error, StackTrace stackTrace) {
    switch (task.method) {
      case HTTPMethod.get:
        expect((error as MockError).description, 'Get error');
      case HTTPMethod.patch:
        expect((error as MockError).description, 'Patch error');
      case HTTPMethod.post:
        expect((error as MockError).description, 'Post error');
      case HTTPMethod.put:
        expect((error as MockError).description, 'Put error');
    }

    if (didFailCallback != null) didFailCallback!();
  }

  @override
  Future<void> didFinish(OTTask task) async {
    didFinishCallback();
  }

  @override
  void didSuccess(OTTask task, String response) {
    switch (task.method) {
      case HTTPMethod.get:
        expect(response, 'get');
      case HTTPMethod.patch:
        expect(response, 'patch');
      case HTTPMethod.post:
        expect(response, 'post');
      case HTTPMethod.put:
        expect(response, 'put');
    }

    if (didSucccesCallback != null) didSucccesCallback!();
  }
}

class MockError {
  final String description;

  MockError(this.description);
}

class MockStackTrace implements StackTrace {}
