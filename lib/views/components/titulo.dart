import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {
  final String txt;

  const Titulo({Key key, this.txt}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }
}
