import 'dart:math';

import 'package:kuzzle/src/kuzzle/errors.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../lib/src/kuzzle/response.dart';
import '../../lib/src/kuzzle/request.dart';
import '../../lib/src/protocols/abstract.dart';

class FakeProtocol extends KuzzleProtocol {
  FakeProtocol(Uri uri,
      {bool autoReconnect = false,
      Duration reconnectionDelay = const Duration(seconds: 1),
      int reconnectionAttempts = 10})
      : super(uri,
            autoReconnect: autoReconnect,
            reconnectionAttempts: reconnectionAttempts,
            reconnectionDelay: reconnectionDelay);

  int connectionRetries = 0;
  bool shouldConnectFail = false;

  @override
  Future<void> protocolConnect() async {
    connectionRetries += 1;
    if (shouldConnectFail) {
      throw KuzzleError('connection.error', 'Connection failed');
    }
  }

  @override
  Future<KuzzleResponse> send(KuzzleRequest request) {
    throw UnimplementedError();
  }
}

void main() {
  group('connect', () {
    test('connect should call protocolConnect', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      await protocol.connect();
      expect(protocol.connectionRetries, equals(1));
    });

    test('connect should throw an error on failure', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      protocol.shouldConnectFail = true;
      expect(protocol.connect, throwsA(const TypeMatcher<KuzzleError>()));
      expect(protocol.connectionRetries, equals(1));
    });
  });

  group('reconnect', () {
    test(
        'should try to connect until it exceeds the maximum reconnection attempt',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'),
          autoReconnect: true,
          reconnectionAttempts: 5,
          reconnectionDelay: const Duration(milliseconds: 10));

      protocol.shouldConnectFail = true;

      try {
        await protocol.connect();
      } on KuzzleError catch (e) {
        expect(Future.error(e), throwsA(const TypeMatcher<KuzzleError>()));
        expect(protocol.connectionRetries, equals(5));
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        rethrow;
      }
    });
  });
}
