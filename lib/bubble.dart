import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Bubble extends StatefulWidget {
  final Tuple3<DateTime, String, String> msg;

  Bubble({Key key, this.msg});

  static double radius = 15;

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  double _fontSize = Bubble.radius / 3 * 4;
  final double _baseFontSize = Bubble.radius / 3 * 4;
  double _fontScale = 1;
  double _baseFontScale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleStart: (ScaleStartDetails scaleStartDetails) {
          _baseFontScale = _fontScale;
        },
        onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails) {
          setState(() {
            _fontScale =
                (_baseFontScale * scaleUpdateDetails.scale).clamp(0.5, 4.0);
            _fontSize = _fontScale * _baseFontSize;
          });
        },

                child: Container(
                    margin: EdgeInsets.only(bottom: Bubble.radius * 2, right: Bubble.radius),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Bubble.radius),
                          topRight: Radius.circular(Bubble.radius),
                          bottomLeft: Radius.circular(Bubble.radius),
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: Bubble.radius / 3* 2,
                              offset: Offset(
                                  Bubble.radius / 5*3, Bubble.radius / 4*3 ),
                              color: Colors.black54)
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.lightGreenAccent, Colors.greenAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    padding: EdgeInsets.all(Bubble.radius),
                    constraints: BoxConstraints(maxWidth: 330),
                    child: Text.rich(
                      buildTextSpan(),
                      strutStyle: StrutStyle(
                          fontSize:
                              _fontSize), // all lines will have this height
                    )),
            ) ;
  }

  TextSpan buildTextSpan() {
    String time = widget.msg.item1.hour.toString() + ":" + widget.msg.item1.minute.toString();

    return TextSpan(style: TextStyle(fontSize: _fontSize), children: [
      TextSpan(
          text: '${widget.msg.item2} ',
          style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: _fontSize / 3 * 2)),
      TextSpan(
          text: '$time\n',
          style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: _fontSize / 3)),
      TextSpan(text: widget.msg.item3)
    ]);
  }
}

/*
/// TODO https://stackoverflow.com/questions/61964242/customizing-chat-bubbles-on-the-left-bottom-by-adding-a-nip
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double factor = 20;
    path.lineTo(0, size.height);

    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
        size.width - factor * 1.5, factor * 1.5, size.width, factor);

    // path.lineTo(size.width, factor);
    path.quadraticBezierTo(
        size.width / 4, size.height - 100, 0,factor /2);
   // path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
*/