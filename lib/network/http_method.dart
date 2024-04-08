library otter;

enum HTTPMethod { get, post, patch, put, delete }

extension HTTPMethodExtension on HTTPMethod {
  static HTTPMethod? fromString(String from) {
    switch (from) {
      case 'get':
        return HTTPMethod.get;
      case 'post':
        return HTTPMethod.post;
      case 'patch':
        return HTTPMethod.patch;
      case 'put':
        return HTTPMethod.put;
      case 'delete':
        return HTTPMethod.delete;
      default:
        Exception('HTTP method not recognized.');
        return null;
    }
  }
}
