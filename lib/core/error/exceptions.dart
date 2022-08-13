abstract class Exception {
  final String? message;

  Exception([this.message]);
}

class NetworkException extends Exception {
  NetworkException([super.message]);
}

class CacheException extends Exception {
  CacheException([super.message]);
}
