import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    String resultText;
    if (resultScore <= 8) {
      resultText = 'How can you\'re score be so low?';
    } else if (resultScore <= 12) {
      resultText = 'You are pretty ok';
    } else if (resultScore <= 16) {
      resultText = 'Are you Donald Trump?';
    } else {
      resultText = 'I think you are a robot';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            Text(
              resultPhrase,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: resetHandler,
              child: Text('Restart Quiz'),
              // style: TextButton.styleFrom(primary: Colors.pinkAccent)
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.pinkAccent),
              ),
            ),
          ],
        ),
      );
}
