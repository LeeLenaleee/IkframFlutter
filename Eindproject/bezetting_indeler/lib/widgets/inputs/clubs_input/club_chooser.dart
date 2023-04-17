import 'package:flutter/material.dart';

class ClubChooser extends StatefulWidget {
  final List<String> userClubs;
  final Function updateChosenClub;

  ClubChooser(this.userClubs, this.updateChosenClub);

  @override
  _ClubChooserState createState() => _ClubChooserState();
}

class _ClubChooserState extends State<ClubChooser> {
  String _selectedClub;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _selectedClub == null ? widget.userClubs[0] : _selectedClub,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (newVal) {
        setState(() {
          _selectedClub = newVal;
        });

        widget.updateChosenClub(newVal);
      },
      items: widget.userClubs
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
