import 'package:bezetting_indeler/screens/create_occipation_details_screen.dart';
import 'package:bezetting_indeler/widgets/inputs/clubs_input/club_chooser.dart';
import 'package:bezetting_indeler/widgets/inputs/pickers/date_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateOccupationScreen extends StatefulWidget {
  @override
  _CreateOccupationScreenState createState() => _CreateOccupationScreenState();
}

class _CreateOccupationScreenState extends State<CreateOccupationScreen> {
  DateTime _selectedDate;
  var organizableClubs = [];
  String _selectedClub;
  var showDetailedCreateOccupationForm = false;

  void _toDetailedView(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) =>
            CreateOccupationDetailsScreen(_selectedClub, _selectedDate),
      ),
    );
  }

  void _startOccupationCreation(BuildContext context) {
    _toDetailedView(context);
  }

  void _setSelectedDate(DateTime date) => setState(() {
        _selectedDate = date;
      });

  void _setChosenClub(String clubName) => _selectedClub = clubName;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((authUser) {
      Firestore.instance
          .collection('clubs')
          .where('organizer', isEqualTo: authUser.uid)
          .getDocuments()
          .then(
            (clubs) => setState(() {
              organizableClubs =
                  clubs.documents.map((e) => e.documentID).toList();

              _selectedClub =
                  _selectedClub == null ? organizableClubs[0] : _selectedClub;
            }),
          );
    });

    return organizableClubs.length == 0
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Selecteer club en datum om bezetting te maken',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Club'),
                      ClubChooser(organizableClubs, _setChosenClub)
                    ],
                  ),
                  DatePicker(_setSelectedDate,
                      mainAxisAlignment: MainAxisAlignment.center),
                  RaisedButton(
                    onPressed: _selectedDate == null
                        ? null
                        : () => _startOccupationCreation(context),
                    child: Text('Bezetting maken'),
                  ),
                ],
              ),
            ),
          );
  }
}
