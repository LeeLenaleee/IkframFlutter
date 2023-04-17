import 'package:bezetting_indeler/helpers/availability_helper.dart';
import 'package:bezetting_indeler/helpers/dialog_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'inputs/clubs_input/club_chooser.dart';
import 'inputs/pickers/date_picker.dart';

class NewAvailabilityForm extends StatefulWidget {
  final List userClubs;
  final String username;
  final String userId;

  NewAvailabilityForm(this.userClubs, this.username, this.userId);

  @override
  _NewAvailabilityFormState createState() => _NewAvailabilityFormState();
}

class _NewAvailabilityFormState extends State<NewAvailabilityForm> {
  TextEditingController _reasonController = new TextEditingController();
  String _userName;
  List<String> _userClubs = [];

  var _availability = Availability.NOT_AVAILABLE;
  DateTime _selectedDate;
  String _selectedClub;

  void _setSelectedDate(DateTime date) => _selectedDate = date;

  void _validateAndSubmitData(BuildContext ctx) {
    if (!_validateInput(ctx)) {
      return;
    }

    _submitData();
  }

  bool _validateInput(BuildContext ctx) {
    if (_selectedDate == null) {
      DialogHelper.showInputErrorDialog(ctx, 'Geen datum opgegeven');
      return false;
    }

    if (_reasonController.text.isEmpty) {
      DialogHelper.showInputErrorDialog(ctx, 'Geen reden opgegeven');
      return false;
    }

    if (_selectedClub == null) {
      DialogHelper.showInputErrorDialog(ctx, 'Geen vereneging opgegeven');
      return false;
    }

    return true;
  }

  void _submitData() async {
    await Firestore.instance.collection('availability').add(
      {
        'username': _userName,
        'availability': AvailabilityHelper.transLateAvailability(_availability),
        'reason': _reasonController.text,
        'date': _selectedDate,
        'club': _selectedClub,
        'userID': widget.userId
      },
    );
    _closeModalAndGiveFeedback(context);
    return;
  }

  void _closeModalAndGiveFeedback(BuildContext ctx) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text('Beschikbaarheid opgeslagen')));
  }

  void _setSelectedClub(String club) => _selectedClub = club;

  @override
  Widget build(BuildContext context) {
    widget.userClubs.forEach((club) {
      if (_userClubs.indexOf(club) == -1) {
        _userClubs.add(club);
      }
    });
    _selectedClub = _selectedClub == null ? _userClubs[0] : _selectedClub;
    _userName = widget.username;

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Reden'),
                controller: _reasonController,
              ),
              DatePicker(_setSelectedDate),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClubChooser(_userClubs, _setSelectedClub),
                  DropdownButton(
                    value: _availability,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    onChanged: (newVal) {
                      setState(() {
                        _availability = newVal;
                      });
                    },
                    items: Availability.values
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(
                              AvailabilityHelper.transLateAvailability(e),
                            ),
                            value: e,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () => _validateAndSubmitData(context),
                child: Text('Geef beschikbaarheid op'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
