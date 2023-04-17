import 'package:flutter/material.dart';
import 'package:quiz_app/result.dart';
import 'package:quiz_app/quiz.dart';

void main() => runApp(RootWidget());

class RootWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RootWidgetState();
  }
}

class _RootWidgetState extends State<RootWidget> {
  int _questionIndex = 0;
  var _totalScore = 0;

  final _questions = const [
    {
      'question': 'What\'s your favourite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 8},
        {'text': 'Green', 'score': 2},
        {'text': 'Pink', 'score': 4},
      ]
    },
    {
      'question': 'What\'s your favourite animal?',
      'answers': [
        {'text': 'Rhino', 'score': 10},
        {'text': 'Elephant', 'score': 6},
        {'text': 'Rabbit', 'score': 2},
        {'text': 'Snake', 'score': 4},
      ]
    },
    {
      'question': 'Who is your favourite teacher',
      'answers': [
        {'text': 'Dio', 'score': 0},
        {'text': 'Jeroen', 'score': 2},
        {'text': 'Dio & Jeroen', 'score': 1},
        {'text': 'All SE teachers and Dio', 'score': 3},
      ]
    },
    {
      'question': 'What is the best specialisation',
      'answers': [
        {'text': 'SE', 'score': 0},
        {'text': 'IAT', 'score': 9},
        {'text': 'FICT', 'score': 10000},
        {'text': 'BDAM', 'score': 30000000},
        {'text': 'What is are those specialisations?', 'score': 1000},
      ]
    },
  ];

  void resetQuiz() {
    setState(() {
      _totalScore = _questionIndex = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("QUIZ APP"),
          backgroundColor: Colors.pink,
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(_totalScore, resetQuiz),
      ),
    );
  }
}
