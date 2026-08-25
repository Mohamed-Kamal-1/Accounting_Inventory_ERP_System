/// Base exception class for data layer operations.
class ServerException implements Exception {
  final String message;
  final int? code;

  const ServerException({required this.message, this.code});

  @override
  String toString() => 'ServerException: $message (code: $code)';
}

/// Exception for authentication errors at the data layer.
class AppAuthException implements Exception {
  final String message;
  final String? code;

  const AppAuthException({required this.message, this.code});

  @override
  String toString() => 'AuthException: $message (code: $code)';
}

/// Exception for cache/local storage errors.
class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception when a resource is not found.
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({required this.message});

  @override
  String toString() => 'NotFoundException: $message';
}
