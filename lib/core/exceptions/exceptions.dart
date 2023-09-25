class AuthorizationException implements Exception {
  AuthorizationException();
}

class ServerException implements Exception {
  final int code;
  ServerException(this.code);
}

class ConnectionTimeoutException implements Exception {
  ConnectionTimeoutException();
}
