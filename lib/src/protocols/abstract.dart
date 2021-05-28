import 'dart:async';

import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';

import '../kuzzle/errors.dart';
import '../kuzzle/event_emitter.dart';
import '../kuzzle/request.dart';
import '../kuzzle/response.dart';
import 'events.dart';

final _uuid = Uuid();

enum KuzzleProtocolState {
  connected,
  connecting,
  reconnecting,
  offline,
}

abstract class KuzzleProtocol extends KuzzleEventEmitter {
  KuzzleProtocol(
    this.uri, {
    this.autoReconnect = false,
    this.reconnectionDelay = const Duration(seconds: 1),
    this.reconnectionAttempts = 10,
  })  : _state = KuzzleProtocolState.offline,
        id = _uuid.v4();

  final Uri uri;
  final String id;
  bool autoReconnect;
  Duration reconnectionDelay;
  int reconnectionAttempts;

  KuzzleProtocolState _state;
  KuzzleProtocolState get state => _state;
  bool _abortConnection = false;

  bool isReady() => _state == KuzzleProtocolState.connected;

  @nonVirtual
  Future<void> connect() async {
    if (_state == KuzzleProtocolState.offline) {
      _abortConnection = false;
    }

    _state = KuzzleProtocolState.connecting;
    var attempt = 0;
    do {
      if (_abortConnection) {
        _abortConnection = false;
        _state = KuzzleProtocolState.offline;
        throw KuzzleError(
            'Unable to connect to kuzzle server at ${uri.toString()}: Connection aborted.');
      }
      try {
        await protocolConnect();
        _clientConnected();
        return;
      } on Exception {
        attempt += reconnectionAttempts > -1 ? 1 : 0;
        print('Reconnection attempt: $attempt');

        if (!autoReconnect ||
            reconnectionAttempts > -1 && attempt >= reconnectionAttempts) {
          rethrow;
        }

        await Future.delayed(reconnectionDelay);
      }
    } while (autoReconnect &&
        (reconnectionAttempts == -1 || attempt < reconnectionAttempts));
  }

  @protected
  Future<void> protocolConnect();

  /// Sends a payload to the connected server
  Future<KuzzleResponse> send(KuzzleRequest request);

  /// Called when the client's connection is established
  void _clientConnected() {
    emit(_state == KuzzleProtocolState.reconnecting
        ? ProtocolEvents.RECONNECT
        : ProtocolEvents.CONNECT);
    _state = KuzzleProtocolState.connected;
  }

  /// Called when the client's connection is closed
  void clientDisconnected() {
    _state = KuzzleProtocolState.offline;
    emit(ProtocolEvents.DISCONNECT);
  }

  /// Called when the client's connection is closed with an error state
  void clientNetworkError([dynamic error]) {
    _state = KuzzleProtocolState.offline;

    emit(ProtocolEvents.NETWORK_ERROR, [error]);

    unawaited(_handleAutoReconnect());
  }

  Future<void> _handleAutoReconnect() async {
    if (!autoReconnect) {
      clientDisconnected();
      return;
    }

    _state = KuzzleProtocolState.reconnecting;

    try {
      await connect();
    } on Exception {
      clientDisconnected();
    }
  }

  /// Called when the client's connection is closed
  @mustCallSuper
  void close() {
    if (_state == KuzzleProtocolState.connected) {
      clientDisconnected();
      return;
    }
    _abortConnection = true;
  }

  // todo: implement query options
  /// Register a response event handler for [request]
  @mustCallSuper
  Future<KuzzleResponse> query(KuzzleRequest request) {
    if (!isReady()) {
      emit(ProtocolEvents.DISCARDED, [request]);

      return Future.error(KuzzleError(
          'Unable to execute request: not connected to a Kuzzle server.'));
    }

    final completer = Completer<KuzzleResponse>();

    once(request.requestId, (response) {
      if (response.error != null) {
        emit(ProtocolEvents.QUERY_ERROR, [response.error, request]);
        return completer.completeError(response.error);
      }

      return completer.complete(response as KuzzleResponse);
    });

    try {
      final syncRes = send(request);
      // If we use a synchronous protocol the result is returned directly
      if (syncRes != null) {
        syncRes.then((response) {
          if (response.error != null) {
            emit(ProtocolEvents.QUERY_ERROR, [response, request]);
          }
        }).catchError((err) {
          emit(ProtocolEvents.QUERY_ERROR, [
            {
              'error': err,
            },
            request
          ]);
        });
        return syncRes;
      }
    } on Exception catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }
}
