import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'home.dart';

// substitute your server's IP and port
const YOUR_SERVER_IP = '0.0.0.0';
const YOUR_SERVER_PORT = 4040;
const URL = 'wss://$YOUR_SERVER_IP:$YOUR_SERVER_PORT';

ServerSocket server;

class Server {

  // ...

  start() async {
    runZoned(() async {
      // server = await ServerSocket.bind('localhost', 4040);
      server = await ServerSocket.bind(YOUR_SERVER_IP, YOUR_SERVER_PORT);

      // ...
    }, onError: (e) {
      print(e);
    });
  }

// ...
}

void main() async {
 // Server serverInstance = new Server();
 // await serverInstance.start();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: SafeArea(child: WhatsAppStyle()

      /*MyHomePage(
        title: title,
        channel: IOWebSocketChannel.connect(Uri.parse(URL)),//   'wss://echo.websocket.org'),
      ),*/
    ));
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}




class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState () {


    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
  //  MyHomePage.removeListener(_onAction);
    widget.channel.sink.close();
    super.dispose();
  }
}
