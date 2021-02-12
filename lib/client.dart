import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:websocket/sendMessage.dart';
import 'bubble.dart';
import 'clientClass.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> with AutomaticKeepAliveClientMixin{
  @override
  bool wantKeepAlive = true;

  Client client;
  List<Tuple3<DateTime, String, String>> serverLogs = [];
  TextEditingController controller = TextEditingController();

  initState() {
    super.initState();

    client = Client(
      hostname: "0.0.0.0",
      port: 4040,
      onData: this.onData,
      onError: this.onError,
    );
  }

  onData(Uint8List data) {
    String sender = 'server';
    DateTime time = DateTime.now();
    //time.hour.toString() + "h" + time.minute.toString() + " : " +
    serverLogs.add(Tuple3(time,sender,String.fromCharCodes(data)));
    setState(() {});
  }

  onError(dynamic error) {
    print(error);
  }

  dispose() {
    controller.dispose();
    client.disconnect();
    super.dispose();
  }

  confirmReturn() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("WARNING"),
          content: Text("Leave this page disconnect the client from the server"),
          actions: <Widget>[
            FlatButton(
              child: Text("Leave", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: confirmReturn,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Client",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: client.connected ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          client.connected ? 'CONNECTED' : 'DISCONNECTED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    child: Text(!client.connected ? 'Connect client' : 'Disconnect client'),
                    onPressed: () async {
                      if (client.connected ) {
                        await client.disconnect();
                        this.serverLogs.clear();
                      } else {
                        await client.connect();
                      }
                      setState(() {});
                    },
                  ),
                  Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: serverLogs.map((Tuple3<DateTime,String,String> msg) {
                        return Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Bubble(msg: msg),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SendMessage(server: null, client: client, text: 'send message :')
        ],
      ),
    );
  }
}