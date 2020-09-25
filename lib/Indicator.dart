import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final double frontsize;
  final bool showText;
  const Indicator({
    Key key,
    this.showText = true,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.frontsize = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        showText
            ? Text(
                text,
                style: TextStyle(
                    fontSize: frontsize,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              )
            : Container()
      ],
    );
  }
}
