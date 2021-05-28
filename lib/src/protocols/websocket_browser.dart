import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:kuzzle/src/kuzzle/response.dart';

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
  Completer<void> _connected = Completer();

  @override
  Future<void> protocolConnect() async {
    if (state == KuzzleProtocolState.reconnecting) {
      return;
    }

    final url = '${uri.scheme}://${uri.host}:${uri.port}';

    _webSocket ??= WebSocket(url);

    await _subscription?.cancel();
    _subscription = null;

    _subscription = _webSocket.onMessage.listen(_handlePayload);

    var onErrorSubscription = _webSocket.onError.listen((Event event) {
      _connected.completeError(event);
    });

    var onCloseSubscription = _webSocket.onClose.listen((Event event) {
      _connected
          .completeError(KuzzleError('Unable to connect to ${uri.toString()}'));
    });

    _webSocket.onOpen.listen((_) {
      onErrorSubscription.cancel();
      onCloseSubscription.cancel();

      _webSocket.onError.listen(_handleError);
      _webSocket.onClose.listen(_handleDone);

      _connected.complete();
    });

    return _connected.future;
  }

  @override
  Future<KuzzleResponse> send(KuzzleRequest request) {
    if (_webSocket != null && _webSocket.readyState == WebSocket.OPEN) {
      _webSocket.sendString(json.encode(request));
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

  void _handlePayload(MessageEvent payload) {
    emit(ProtocolEvents.NETWORK_ON_RESPONSE_RECEIVED, [payload.data]);
  }

  void _handleError(Event event) {
    clientNetworkError(event);
  }

  void _handleDone(Event event) {
    clientDisconnected();
  }
}
