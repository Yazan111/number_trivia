abstract class Exception {
  final String message;

  Exception({required this.message});
}

class NetworkException extends Exception {
  NetworkException({required super.message});
}

class CacheException extends Exception {
  CacheException({required super.message});
}
