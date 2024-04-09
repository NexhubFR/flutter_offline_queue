library otter;

enum HTTPMethod { get, post, patch, put, delete }

extension HTTPMethodExtension on HTTPMethod {
  /// Converts a string to its corresponding `HTTPMethod` enum.
  ///
  /// This static method maps string representations of HTTP methods
  /// to their respective `HTTPMethod` enum values.
  /// Supported methods include 'get', 'post', 'patch', 'put', and 'delete'.
  /// If the input string does not match any supported methods,
  /// the method logs an exception and returns `null`.
  ///
  /// Parameters:
  /// - `from`: The string representation of the HTTP method to convert.
  ///
  /// Returns:
  /// - The corresponding `HTTPMethod` enum, or `null`
  ///   if the string does not match any recognized methods.
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
