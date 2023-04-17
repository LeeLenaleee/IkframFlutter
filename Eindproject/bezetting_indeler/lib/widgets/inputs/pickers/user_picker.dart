import 'package:bezetting_indeler/widgets/inputs/pickers/user_picker_dropdown.dart';
import 'package:quiver/iterables.dart';
import 'package:flutter/material.dart';

class UserPicker extends StatefulWidget {
  final Function updateVolunteers;
  final List<String> volunteers;
  final List<dynamic> oldVolunteers;
  final String occupationPlace;
  final List<dynamic> availability;

  UserPicker(
    this.volunteers,
    this.updateVolunteers,
    this.occupationPlace,
    this.availability, {
    this.oldVolunteers = const [],
  });

  @override
  _UserPickerState createState() => _UserPickerState();
}

class _UserPickerState extends State<UserPicker> {
  var amountOfVolunteers = 1;
  var dropdownValue = '';
  Map<String, String> selectedVolunteers = {};

  void _addVolunteerToPlace(String volunteer, String key) {
    selectedVolunteers[key] = volunteer;
    widget.updateVolunteers(
      widget.occupationPlace,
      selectedVolunteers.values.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.oldVolunteers.length > 0) {
      amountOfVolunteers = widget.oldVolunteers.length;
    }

    return Container(
      child: Column(
        children: [
          Column(
            children: widget.oldVolunteers.length == 0
                ? range(amountOfVolunteers)
                    .toList()
                    .map((e) => UserPickerDropdown(
                          widget.volunteers,
                          _addVolunteerToPlace,
                          widget.availability,
                        ))
                    .toList()
                : range(amountOfVolunteers)
                    .toList()
                    .map((e) => UserPickerDropdown(
                          widget.volunteers,
                          _addVolunteerToPlace,
                          widget.availability,
                          lastWeekVolunteer: widget.oldVolunteers[e],
                        ))
                    .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    amountOfVolunteers++;
                  });
                },
                icon: Icon(Icons.add),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    amountOfVolunteers--;
                  });
                },
                icon: Icon(Icons.remove),
              )
            ],
          )
        ],
      ),
    );
  }
}
