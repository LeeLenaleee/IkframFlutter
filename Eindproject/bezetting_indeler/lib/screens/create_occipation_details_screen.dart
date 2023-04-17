import 'package:bezetting_indeler/widgets/new_occupation_form.dart';
import 'package:flutter/material.dart';

class CreateOccupationDetailsScreen extends StatelessWidget {
  final String selectedClub;
  final DateTime selectedDate;

  CreateOccupationDetailsScreen(this.selectedClub, this.selectedDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bezetting maken'),
      ),
      body: NewOccupationForm(selectedClub, selectedDate),
    );
  }
}
