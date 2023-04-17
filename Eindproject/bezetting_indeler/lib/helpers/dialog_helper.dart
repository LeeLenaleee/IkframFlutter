import 'package:flutter/material.dart';

class DialogHelper {
  static void showInputErrorDialog(
    BuildContext ctx,
    String message,
  ) {
    showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
              title: Text('Ongeldige input'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okee'),
                )
              ],
            ));
  }
}
