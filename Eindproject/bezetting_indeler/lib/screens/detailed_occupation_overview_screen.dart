import 'package:bezetting_indeler/widgets/occupation/occupation_detailed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailedOccupationOverviewScreen extends StatelessWidget {
  final String club;
  final DateTime date;
  final Map<String, dynamic> occupations;

  DetailedOccupationOverviewScreen(
    this.club,
    this.date,
    this.occupations,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$club ${DateFormat('dd/MM').format(date)}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Bezetting $club ${DateFormat('dd MMMM yyyy').format(date)}',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView(
              padding: EdgeInsets.all(25),
              children: occupations.keys
                  .map((key) => OccupationDetailed(key, occupations[key]))
                  .toList(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
