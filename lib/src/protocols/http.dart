import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:kuzzle/src/kuzzle/request.dart';
import 'package:kuzzle/src/kuzzle/response.dart';
import 'package:kuzzle/src/protocols/abstract.dart';

class HttpProtocol extends KuzzleProtocol {
  HttpProtocol(Uri uri, {bool acceptUnsignedCertificate = false}) : super(uri) {
    _client = HttpClient()
      ..badCertificateCallback =
          ((cert, host, port) => acceptUnsignedCertificate);
    _ioClient = IOClient(_client);
  }

  HttpClient _client;
  IOClient _ioClient;

  @override
  Future<void> connect() async {
    await super.connect();

    final res = await _ioClient.get('${uri.toString()}/_query');
    if (res.statusCode == 401 || res.statusCode == 403) {
      return Future.error('You must have permission on the _query route.');
    }
    clientConnected();
    return Future.value();
  }

  @override
  Future<KuzzleResponse> send(KuzzleRequest request) async {
    final headers = {'Content-Type': 'application/json'};

    if (request.jwt != null) {
      headers['Authorization'] = 'Bearer ${request.jwt}';
    }

    if (request.volatile != null) {
      headers['x-kuzzle-volatile'] = jsonEncode(request.volatile);
    }

    final res = await _ioClient.post(
      '${uri.toString()}/_query',
      headers: headers,
      body: jsonEncode(request),
    );
    if (res.statusCode != 200) {
      return Future.error(res);
    }
    return Future.value(
      KuzzleResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>),
    );
  }
}
