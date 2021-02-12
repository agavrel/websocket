import 'package:flutter/material.dart';

import 'serverClass.dart';
import 'clientClass.dart';

class SendMessage extends StatefulWidget {
  final String text;
  final Server server;
  final Client client;

  const SendMessage({
    Key key, this.server ,this.client,this.text
  }) : super(key: key);
  @override
  _SendMessageWidgetState createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessage> {

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x33000033),
      height: 80,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 8,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          MaterialButton(
            onPressed: () {
              controller.text = "";
            },
            minWidth: 30,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Icon(Icons.clear),
          ),
          SizedBox(width: 15,),
          MaterialButton(
            onPressed: () {
              widget.server != null ? widget.server.broadCast(controller.text) :
              widget.client.add(controller.text);
              controller.text = "";
            },
            minWidth: 30,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Icon(Icons.send, color: Colors.blueAccent),
          )
        ],
      ),
    );
  }
}

