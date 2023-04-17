import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String text;
  final Function selectHandler;

  Answer({this.text = 'Not Implemented', this.selectHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: Text(this.text),
        onPressed: this.selectHandler,
        color: Colors.pinkAccent,
        textColor: Colors.white,
      ),
    );
  }
}
