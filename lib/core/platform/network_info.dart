import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoConnectivity implements NetworkInfo {
  final Connectivity connectivityChecker;

  NetworkInfoConnectivity(this.connectivityChecker);

  @override
  Future<bool> get isConnected async {
    final result = await connectivityChecker.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
