import 'package:kuzzle/src/protocols/websocket_io.dart'
    if (dart.library.html) 'package:kuzzle/src/protocols/websocket_browser.dart';

class WebSocketProtocol extends KuzzleWebSocket {
  WebSocketProtocol(
    Uri uri, {
    bool autoReconnect = true,
    Duration reconnectionDelay = const Duration(seconds: 1),
    int reconnectionAttempts = 10,
    Duration? pingInterval,
  }) : super(
          uri,
          autoReconnect: autoReconnect,
          reconnectionDelay: reconnectionDelay,
          reconnectionAttempts: reconnectionAttempts,
          pingInterval: pingInterval,
        );
}
