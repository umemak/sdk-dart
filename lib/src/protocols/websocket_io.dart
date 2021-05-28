import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:kuzzle/src/kuzzle/response.dart';
import 'package:pedantic/pedantic.dart';

import '../kuzzle/errors.dart';
import '../kuzzle/request.dart';

import 'abstract.dart';
import 'events.dart';

class KuzzleWebSocket extends KuzzleProtocol {
  KuzzleWebSocket(
    Uri uri, {
    bool autoReconnect = true,
    Duration reconnectionDelay = const Duration(seconds: 1),
    int reconnectionAttempts = 10,
    this.pingInterval,
  }) : super(uri,
            autoReconnect: autoReconnect,
            reconnectionDelay: reconnectionDelay,
            reconnectionAttempts: reconnectionAttempts);

  WebSocket _webSocket;
  StreamSubscription _subscription;
  Duration pingInterval;

  @override
  Future<void> protocolConnect() async {
    // If a reconnection is going on
    // and the enduser called disconnect in between
    // then don't try to connect
    if (state == KuzzleProtocolState.reconnecting) {
      return;
    }

    final url = '${uri.scheme}://${uri.host}:${uri.port}';

    await _subscription?.cancel();
    _subscription = null;

    await _webSocket?.close();
    _webSocket = null;

    _webSocket = await WebSocket.connect(url);

    _webSocket.pingInterval = pingInterval;

    _subscription = _webSocket.listen(_handlePayload,
        onError: _handleError, onDone: _handleDone);
  }

  @override
  Future<KuzzleResponse> send(KuzzleRequest request) {
    if (_webSocket != null && _webSocket.readyState == WebSocket.open) {
      _webSocket.add(json.encode(request));
    }
    return null;
  }

  @override
  void close() {
    super.close();

    removeAllListeners();

    _subscription?.cancel();
    _subscription = null;

    _webSocket?.close();
    _webSocket = null;
  }

  void _handlePayload(dynamic payload) {
    emit(ProtocolEvents.NETWORK_ON_RESPONSE_RECEIVED, [payload]);
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    if (error is Error) {
      clientNetworkError(error);
    } else {
      clientNetworkError(KuzzleError('websocket.onError'));
    }
  }

  void _handleDone() {
    if (_webSocket.closeCode == 1000) {
      clientDisconnected();
    } else if (state == KuzzleProtocolState.connected) {
      clientNetworkError(KuzzleError(
          'clientNetworkError', _webSocket.closeReason, _webSocket.closeCode));
    }
  }
}
