import 'package:flutter/material.dart';
/* snippet:start:1 */
import 'package:kuzzle/kuzzle.dart';
/* snippet:end */

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/* snippet:start:2 */
class _MyHomePageState extends State<MyHomePage> {
  Kuzzle _kuzzle;

  @override
  void initState() {
    _kuzzle = Kuzzle(WebSocketProtocol(Uri(
      scheme: 'ws',
      host: '192.168.0.170',
      port: 7512,
    )));
    _kuzzle.connect().then(() {
      _initData();
    });
    super.initState();
  }
/* snippet:end */

  void _initData() async {
    if (!(await _kuzzle.index.exists("chat"))) {
      // If not, create 'chat' index and 'messages' collection
      await _kuzzle.index.create("chat");
      await _kuzzle.collection.create("chat", "messages");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
