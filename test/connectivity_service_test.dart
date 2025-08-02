import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/services/connectivity_service.dart';

void main() {
  group('ConnectivityService Tests', () {
    late ConnectivityService connectivityService;

    setUp(() {
      connectivityService = ConnectivityService();
    });

    test('should initialize connectivity service', () async {
      await connectivityService.initialize();
      expect(connectivityService.currentStatus, isA<ConnectivityStatus>());
    });

    test('should check internet connection', () async {
      final hasConnection = await connectivityService.hasInternetConnection();
      expect(hasConnection, isA<bool>());
    });

    test('should provide connectivity stream', () {
      final stream = connectivityService.connectivityStream;
      expect(stream, isA<Stream<ConnectivityStatus>>());
    });

    test('should convert status to result for backward compatibility', () {
      final result = connectivityService.connectivityResultStream;
      expect(result, isA<Stream<ConnectivityResult>>());
    });

    test('should dispose resources properly', () {
      expect(() => connectivityService.dispose(), returnsNormally);
    });
  });
}
