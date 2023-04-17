import 'package:flutter/material.dart';

class ClubSelector extends StatefulWidget {
  final List<String> clubs;
  final Function addClub;
  final int index;

  ClubSelector(this.clubs, this.addClub, this.index);

  @override
  _ClubSelectorState createState() => _ClubSelectorState();
}

class _ClubSelectorState extends State<ClubSelector> {
  var dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue.isEmpty
          ? widget.index >= widget.clubs.length
              ? widget.clubs[0]
              : widget.clubs[widget.index]
          : dropdownValue,
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
          widget.addClub(newVal, widget.index);
        });
      },
      items: widget.clubs
          .map(
            (e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ),
          )
          .toList(),
    );
  }
}
