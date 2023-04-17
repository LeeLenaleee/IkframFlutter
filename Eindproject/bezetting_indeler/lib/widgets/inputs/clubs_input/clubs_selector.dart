import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'club_selector.dart';

class ClubsSelector extends StatefulWidget {
  final List<String> clubs;
  final Function updateClubs;

  ClubsSelector(
    this.clubs,
    this.updateClubs,
  );

  @override
  _ClubsSelectorState createState() => _ClubsSelectorState();
}

// DEZE FILE BIJNA COPY PASTE VOOR INDELING MAKEN
class _ClubsSelectorState extends State<ClubsSelector> {
  List<String> _selectedClubs = [];
  var amountOfClubs = 1;

  void addClub(String clubName, int i) {
    i == _selectedClubs.length
        ? _selectedClubs.add(clubName)
        : _selectedClubs[i] = clubName;

    widget.updateClubs(_selectedClubs);
  }

  @override
  Widget build(BuildContext context) {
    addClub(widget.clubs[0], 0);
    return Container(
      child: Column(
        children: [
          Column(
            children: range(amountOfClubs)
                .toList()
                .map((e) => ClubSelector(widget.clubs, addClub, e))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (amountOfClubs < widget.clubs.length)
                IconButton(
                  onPressed: () {
                    setState(() {
                      amountOfClubs++;
                      addClub(
                          amountOfClubs <= widget.clubs.length
                              ? widget.clubs[amountOfClubs - 1]
                              : widget.clubs[0],
                          amountOfClubs - 1);
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              if (amountOfClubs > 1)
                IconButton(
                  onPressed: () {
                    setState(() {
                      amountOfClubs--;
                      _selectedClubs.removeLast();
                      widget.updateClubs(_selectedClubs);
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
