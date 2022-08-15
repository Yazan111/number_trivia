import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  final mockDataconnectionChecker = MockConnectivity();
  late NetworkInfoConnectivity networkInfo;

  setUp(() {
    networkInfo = NetworkInfoConnectivity(mockDataconnectionChecker);
    when(mockDataconnectionChecker.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);
  });

  test('network info should forward the call to DataConnectionChecker',
      () async {
    await networkInfo.isConnected;
    verify(mockDataconnectionChecker.checkConnectivity());
  });

  test('return false when device has no connection', () async {
    final result = await networkInfo.isConnected;
    expect(result, false);
  });

  test('return true when device has connection', () async {
    when(mockDataconnectionChecker.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);
    final result = await networkInfo.isConnected;
    expect(result, true);
  });
}
