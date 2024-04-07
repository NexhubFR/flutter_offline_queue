import 'package:flutter_test/flutter_test.dart';
import 'package:otter/network/http_method.dart';

void main() {
  group('HTTPMethod Tests', () {
    test('fromString get', () {
      expect(HTTPMethodExtension.fromString('get') == HTTPMethod.get, true);
    });

    test('fromString post', () {
      expect(HTTPMethodExtension.fromString('post') == HTTPMethod.post, true);
    });

    test('fromString patch', () {
      expect(HTTPMethodExtension.fromString('patch') == HTTPMethod.patch, true);
    });

    test('fromString put', () {
      expect(HTTPMethodExtension.fromString('put') == HTTPMethod.put, true);
    });
  });
}
