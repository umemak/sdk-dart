import 'dart:async';
import 'dart:math';

import 'package:kuzzle/src/kuzzle/errors.dart';
import 'package:kuzzle/src/protocols/events.dart';
import 'package:pedantic/pedantic.dart';
import 'package:test/test.dart';

import 'package:kuzzle/src/kuzzle/request.dart';
import 'package:kuzzle/src/kuzzle/response.dart';
import 'package:kuzzle/src/protocols/abstract.dart';

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
  bool shouldSendFail = false;

  void setAborted(bool state) {
    abortConnection = state;
  }

  void setState(KuzzleProtocolState state) {
    protocolState = state;
  }

  @override
  Future<void> protocolConnect() async {
    if (connectionAborted) {
      return;
    }
    connectionRetries += 1;
    if (shouldConnectFail) {
      throw KuzzleError('connection.error', 'Connection failed');
    }
  }

  @override
  Future<void> send(KuzzleRequest request) async {
    if (shouldSendFail) {
      throw Exception('Failed to send');
    }
  }
}

void main() {
  group('connect', () {
    test('connect should call protocolConnect', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      await protocol.connect();
      expect(protocol.connectionRetries, equals(1));
      expect(protocol.state, equals(KuzzleProtocolState.connected));
    });

    test('should emit a connect event when connected', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      var connected = false;
      protocol.on(ProtocolEvents.CONNECT, () => connected = true);
      await protocol.connect();
      expect(connected, equals(true));
      expect(protocol.state, equals(KuzzleProtocolState.connected));
    });

    test('connect should throw an error on failure', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      protocol.shouldConnectFail = true;

      try {
        await protocol.connect();
        throw Exception('should have failed');
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(Future.error(e), throwsA(const TypeMatcher<KuzzleError>()));
      }

      expect(protocol.connectionRetries, equals(1));
      expect(protocol.state, equals(KuzzleProtocolState.offline));
    });

    test('calling connect when offline should set abortConnection to false',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      protocol.setAborted(true);
      expect(protocol.state, equals(KuzzleProtocolState.offline));
      expect(protocol.connectionAborted, equals(true));
      await protocol.connect();
      expect(protocol.connectionAborted, equals(false));
      expect(protocol.state, equals(KuzzleProtocolState.connected));
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
        throw Exception('should have failed');
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(Future.error(e), throwsA(const TypeMatcher<KuzzleError>()));
        expect(protocol.connectionRetries, equals(5));
        // ignore: avoid_catches_without_on_clauses
      }
    });

    test('should reconnect on network error', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'),
          autoReconnect: true,
          reconnectionAttempts: 50,
          reconnectionDelay: const Duration(milliseconds: 100));

      final completer = Completer<void>();
      await protocol.connect();
      protocol.shouldConnectFail = true;
      protocol.connectionRetries = 0;
      protocol.on(ProtocolEvents.RECONNECT, completer.complete);
      expect(protocol.state, equals(KuzzleProtocolState.connected));
      protocol
          .clientNetworkError(KuzzleError('network.error', 'Network Error'));
      expect(protocol.state, equals(KuzzleProtocolState.reconnecting));
      protocol.shouldConnectFail = false;
      await completer.future;
      expect(protocol.connectionRetries, greaterThan(1));
      expect(protocol.state, equals(KuzzleProtocolState.connected));
    });

    test('should emit a disconnect event when not able to reconnect', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'),
          autoReconnect: true,
          reconnectionAttempts: 5,
          reconnectionDelay: const Duration(milliseconds: 10));

      final completer = Completer<void>();
      await protocol.connect();
      protocol.shouldConnectFail = true;
      protocol.connectionRetries = 0;
      protocol.on(ProtocolEvents.DISCONNECT, completer.complete);
      expect(protocol.state, equals(KuzzleProtocolState.connected));
      protocol
          .clientNetworkError(KuzzleError('network.error', 'Network Error'));
      expect(protocol.state, equals(KuzzleProtocolState.reconnecting));
      await completer.future;
      expect(protocol.connectionRetries, equals(5));
      expect(protocol.state, equals(KuzzleProtocolState.offline));
    });
  });

  group('#clientNetworkError', () {
    test('should emit a NETWORK_ERROR event when clientNetworkError is called',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'),
          autoReconnect: true,
          reconnectionAttempts: 5,
          reconnectionDelay: const Duration(milliseconds: 10));
      await protocol.connect();
      expect(protocol.state, equals(KuzzleProtocolState.connected));

      final completer = Completer<void>();
      protocol.on(ProtocolEvents.NETWORK_ERROR, completer.complete);
      protocol
          .clientNetworkError(KuzzleError('network.error', 'Network Error'));
      await completer.future;
    });

    test(
        'should emit a NETWORK_ERROR and a DISCONNECT event when clientNetworkError is called without autoReconnect',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      await protocol.connect();
      expect(protocol.state, equals(KuzzleProtocolState.connected));

      final completerNetworkError = Completer<void>();
      final completerDisconnect = Completer<void>();
      protocol.on(ProtocolEvents.NETWORK_ERROR, completerNetworkError.complete);
      protocol.on(ProtocolEvents.DISCONNECT, completerDisconnect.complete);
      protocol
          .clientNetworkError(KuzzleError('network.error', 'Network Error'));
      await completerNetworkError.future;
      await completerDisconnect.future;
    });
  });

  group('#clientDisconnected', () {
    test('should emit a DISCONNECT event and set the state to offline',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      await protocol.connect();
      expect(protocol.state, equals(KuzzleProtocolState.connected));

      final completerDisconnect = Completer<void>();
      protocol.on(ProtocolEvents.DISCONNECT, completerDisconnect.complete);
      protocol.clientDisconnected();
      await completerDisconnect.future;
      expect(protocol.state, KuzzleProtocolState.offline);
    });
  });

  group('#close', () {
    test('should emit a DISCONNECT event and set the state to offline',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      await protocol.connect();
      expect(protocol.state, equals(KuzzleProtocolState.connected));

      final completerDisconnect = Completer<void>();
      protocol.on(ProtocolEvents.DISCONNECT, completerDisconnect.complete);
      protocol.close();
      await completerDisconnect.future;
      expect(protocol.state, equals(KuzzleProtocolState.offline));
    });

    test(
        'should abort the connection while connecting or reconnecting and set the state to offline',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      protocol.setState(KuzzleProtocolState.connecting);
      expect(protocol.state, equals(KuzzleProtocolState.connecting));
      expect(protocol.connectionAborted, equals(false));

      protocol.close();
      expect(protocol.connectionAborted, equals(true));

      protocol.setAborted(false);
      protocol.setState(KuzzleProtocolState.reconnecting);

      expect(protocol.state, equals(KuzzleProtocolState.reconnecting));
      expect(protocol.connectionAborted, equals(false));

      protocol.close();
      expect(protocol.connectionAborted, equals(true));
    });
  });

  group('#query', () {
    test('should discard requests when not connected', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      final completerDiscarded = Completer<void>();
      expect(protocol.state, equals(KuzzleProtocolState.offline));

      try {
        await protocol.query(KuzzleRequest(action: 'foo'));
        throw Exception('should have failed');
      } catch (e) {
        expect(Future.error(e), throwsA(const TypeMatcher<KuzzleError>()));
      }
    });

    test('complete with an error when send has throw', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      final completerQueryError = Completer<void>();
      protocol.setState(KuzzleProtocolState.connected);
      protocol.on(ProtocolEvents.QUERY_ERROR, (error, request) {
        completerQueryError.complete();
      });
      protocol.shouldSendFail = true;
      try {
        await protocol.query(KuzzleRequest(action: 'foo'));
        throw KuzzleError('should have failed');
      } catch (e) {
        expect(Future.error(e), throwsA(const TypeMatcher<Exception>()));
      }
      return completerQueryError.future;
    });

    test(
        'sending an event with a requestId should complete the previously generated future',
        () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      final request = KuzzleRequest(action: 'foo');
      final completerQueryError = Completer<void>();
      protocol.setState(KuzzleProtocolState.connected);
      protocol.on(ProtocolEvents.QUERY_ERROR, (error, request) {
        completerQueryError.complete();
      });

      final responseFuture = protocol.query(request);

      protocol.emit(request.requestId!, [KuzzleResponse(action: 'foo')]);

      final response = await responseFuture;

      expect(response.action, equals('foo'));

      return responseFuture;
    });

    test('complete with an error when the KuzzleResponse is errored', () async {
      final protocol = FakeProtocol(Uri(host: 'uri'));
      final request = KuzzleRequest(action: 'foo');
      final completerQueryError = Completer<void>();
      protocol.setState(KuzzleProtocolState.connected);

      protocol.on(ProtocolEvents.QUERY_ERROR, (error, request) {
        expect((error as KuzzleError).id, equals('foobar'));
        completerQueryError.complete();
      });

      final responseFuture = protocol.query(request);

      protocol.emit(request.requestId!,
          [KuzzleResponse(action: 'foo', error: KuzzleError('foobar'))]);

      KuzzleResponse response;
      try {
        await responseFuture;
        throw KuzzleError('should have failed');
      } catch (e) {
        expect(Future.error(e), throwsA(const TypeMatcher<KuzzleError>()));
        expect((e as KuzzleError).id, equals('foobar'));
      }
      return completerQueryError.future;
    });
  });
}
