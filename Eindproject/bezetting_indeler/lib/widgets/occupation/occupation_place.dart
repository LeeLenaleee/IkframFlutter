import 'package:flutter/material.dart';

class OccupationPlace extends StatelessWidget {
  final String place;

  OccupationPlace(this.place);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            'Ingedeeld bij: $place',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.5,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
