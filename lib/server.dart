import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:websocket/sendMessage.dart';

import 'bubble.dart';
import 'serverClass.dart';

class ServerPage extends StatefulWidget {
  @override
  _ServerPageState createState() => _ServerPageState();
}

//typedef FunctionCallback = server.broadCast(String);
class _ServerPageState extends State<ServerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  static Server server;
  List<Tuple3<DateTime, String, String>> serverLogs = [];

  initState() {
    super.initState();

    server = Server(
      onData: this.onData,
      onError: this.onError,
    );
  }

  onData(Uint8List data) {
    print(data);
    var test = Uint8List.fromList(data);
    bool fromClient = true;
    DateTime time = DateTime.now();

    for (int i = 0; i < 16; i++) {
      if (test[i] != 27) {
        fromClient = false;
        break;
      }
    }

    serverLogs.add(fromClient
        ? Tuple3(time, 'client', String.fromCharCodes(data).substring(16))
        : Tuple3(time, 'server', String.fromCharCodes(data)));

    //(time.hour.toString() + "h" + time.minute.toString() + " : " + String.fromCharCodes(data));
    setState(() {});
  }

  onError(dynamic error) {
    print(error);
  }

  dispose() {
    print('server stop');
    server.stop();
    super.dispose();
  }

  confirmReturn() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("WARNING"),
          content:
              Text("You are about to leave this app and shutdown the server"),
          actions: <Widget>[
            FlatButton(
              child: Text("Leave", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
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
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Server'),
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
                            "Server",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: server.running ? Colors.green : Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              server.running ? 'ON' : 'OFF',
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
                        child: Text(
                            server.running ? 'Stop server' : 'Start server'),
                        onPressed: () async {
                          if (server.running) {
                            await server.stop();
                            this.serverLogs.clear();
                          } else {
                            await server.start();
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
                          children: serverLogs
                              .map((Tuple3<DateTime, String, String> msg) {
                            return Bubble(msg: msg);
                            /*Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(log)
                        );*/
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SendMessage(
                  server: server, client: null, text: 'broadcast message :')
            ],
          ),
        ));
  }
}
