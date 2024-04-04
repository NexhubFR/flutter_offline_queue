library flutter_offline_queue;

enum HTTPMethod { post, patch, put }

extension HTTPMethodExtension on HTTPMethod {
  static HTTPMethod? fromString(String from) {
    switch (from) {
      case 'post':
        return HTTPMethod.post;
      case 'patch':
        return HTTPMethod.patch;
      case 'put':
        return HTTPMethod.put;
      default:
        return null;
    }
  }
}
