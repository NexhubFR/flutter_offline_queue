import 'package:flutter_test/flutter_test.dart';
import 'package:otter/network/http_method.dart';

void main() {
  group('HTTPMethod Tests', () {
    test('fromString get', () {
      expect(HTTPMethodExtension.fromString('get'), HTTPMethod.get);
    });

    test('fromString post', () {
      expect(HTTPMethodExtension.fromString('post'), HTTPMethod.post);
    });

    test('fromString patch', () {
      expect(HTTPMethodExtension.fromString('patch'), HTTPMethod.patch);
    });

    test('fromString put', () {
      expect(HTTPMethodExtension.fromString('put'), HTTPMethod.put);
    });

    test('fromString delete', () {
      expect(HTTPMethodExtension.fromString('delete'), HTTPMethod.delete);
    });
  });
}
