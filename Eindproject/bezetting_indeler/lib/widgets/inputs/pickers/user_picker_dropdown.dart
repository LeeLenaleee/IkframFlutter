import 'package:bezetting_indeler/helpers/availability_helper.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserPickerDropdown extends StatefulWidget {
  final Function updateVolunteer;
  final List<String> volunteers;
  final List<dynamic> availability;
  final String lastWeekVolunteer;

  UserPickerDropdown(
    this.volunteers,
    this.updateVolunteer,
    this.availability, {
    this.lastWeekVolunteer = '',
  });

  @override
  _UserPickerDropdownState createState() => _UserPickerDropdownState();
}

class _UserPickerDropdownState extends State<UserPickerDropdown> {
  String UUID = Uuid().v4();
  var dropdownValue = '';
  var inital = true;

  bool _checkAvailability(Availability availability, String name) {
    var availabilityFound =
        widget.availability.where((avail) => avail['name'] == name).toList();

    if (availabilityFound.length == 0 &&
        availability == Availability.AVAILABLE) {
      return true;
    } else if (availabilityFound.length == 0) {
      return false;
    }

    return AvailabilityHelper.transLateAvailabilityToEnum(
            availabilityFound[0]['available']) ==
        availability;
  }

  bool _isNotAvailable(String name) =>
      _checkAvailability(Availability.NOT_AVAILABLE, name);

  bool _isNotSure(String name) =>
      _checkAvailability(Availability.NOT_SURE, name);

  @override
  Widget build(BuildContext context) {
    if (inital && widget.lastWeekVolunteer.isNotEmpty) {
      var index = widget.volunteers.indexOf(widget.lastWeekVolunteer);
      if (index != -1) {
        widget.volunteers.removeAt(index);
      }
      widget.volunteers.insert(0, widget.lastWeekVolunteer);
      inital = false;
    }

    widget.updateVolunteer(
        dropdownValue.isEmpty ? widget.volunteers[0] : dropdownValue, UUID);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButton(
        value: dropdownValue.isEmpty ? widget.volunteers[0] : dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        onChanged: (newVal) {
          setState(() {
            dropdownValue = newVal;
            widget.updateVolunteer(newVal, UUID);
          });
        },
        items: widget.volunteers
            .map(
              (e) => DropdownMenuItem(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(e),
                  ),
                  color: _isNotAvailable(e)
                      ? Colors.red
                      : _isNotSure(e)
                          ? Colors.orange[400]
                          : Colors.transparent,
                ),
                value: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
