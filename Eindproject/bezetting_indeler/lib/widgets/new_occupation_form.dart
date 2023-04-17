import 'dart:async';
import 'package:bezetting_indeler/helpers/availability_helper.dart';
import 'package:bezetting_indeler/helpers/intl_helper.dart';
import 'package:bezetting_indeler/widgets/inputs/pickers/user_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewOccupationForm extends StatefulWidget {
  final String selectedClub;
  final DateTime selectedDate;

  NewOccupationForm(this.selectedClub, this.selectedDate);

  @override
  _NewOccupationFormState createState() => _NewOccupationFormState();
}

class _NewOccupationFormState extends State<NewOccupationForm> {
  final ScrollController scrollController = ScrollController();
  List<String> allMembers = [];
  Map<String, dynamic> newOccupation = {'occupation': {}};
  bool _useLastWeeksOccupation = false;

  void _setOccupation(String key, List<String> volunteers) {
    newOccupation['occupation'][key] = volunteers;
  }

  void _setMetaDataInOccupation() {
    newOccupation['club'] = widget.selectedClub;
    newOccupation['targetDate'] = widget.selectedDate;
    newOccupation['creationDate'] = DateTime.now();
  }

  void _setNewOccupation(BuildContext context) {
    var msWaitForSubmitWithoutScroll = 0;
    var msWaitForSubmitWithScroll = 250;

    _setMetaDataInOccupation();

    if (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Niet alle bezettingen bekeken'),
                content: Text(
                    'Nog niet alle bezettingen zijn beken. \n Scroll volledig naar beneden om de bezetting op te slaan.'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                      Navigator.of(context).pop();
                      _safeNewOccupation(context, msWaitForSubmitWithScroll);
                    },
                    child: Text('Toch opslaan'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Bezetting verder bekijken'),
                  )
                ],
              ));
    } else {
      _safeNewOccupation(context, msWaitForSubmitWithoutScroll);
    }
  }

  void _safeNewOccupation(BuildContext context, int msWaitForSubmit) {
    Timer(Duration(milliseconds: msWaitForSubmit), () {
      Firestore.instance
          .collection('occupations')
          .document(
              '${widget.selectedClub}-${DateFormat('dd-MMMM-yyyy').format(widget.selectedDate)}')
          .setData(newOccupation);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bezetting opgeslagen'),
        ),
      );

      Navigator.of(context).pop();
    });
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  void _loadLastWeekOccupation(lastWeekOccupation, club) {
    setState(() {
      _useLastWeeksOccupation = true;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance
          .collection('users')
          .where('clubs', arrayContains: widget.selectedClub)
          .getDocuments(),
      builder: (ctx, members) {
        if (members.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        }

        return FutureBuilder(
          future: Firestore.instance
              .collection('clubs')
              .document(widget.selectedClub)
              .get(),
          builder: (ctx, club) {
            if (club.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            }

            return FutureBuilder(
              future: Firestore.instance
                  .collection('availability')
                  .where('club', isEqualTo: widget.selectedClub)
                  .where('date', isEqualTo: widget.selectedDate)
                  .getDocuments(),
              builder: (ctx, availability) {
                if (availability.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                }

                // TODO: SWITCH BACK TO SUBTRACT, IS ADD FOR TESTING
                return FutureBuilder(
                  future: Firestore.instance
                      .collection('occupations')
                      .where('club', isEqualTo: widget.selectedClub)
                      .where('targetDate', isLessThan: widget.selectedDate)
                      .orderBy('targetDate', descending: true)
                      .getDocuments(),
                  builder: (ctx, lastWeekOccupation) {
                    if (lastWeekOccupation.connectionState ==
                        ConnectionState.waiting) {
                      return _buildLoadingIndicator();
                    }

                    List<String> availableVolunteers = [
                      ...members.data.documents.map((e) => (e['username']))
                    ];

                    availability.data.documents.forEach((availabilty) {
                      if (AvailabilityHelper.transLateAvailabilityToEnum(
                              availabilty['availability']) ==
                          Availability.NOT_AVAILABLE) {
                        availableVolunteers.removeWhere(
                            (name) => name == availabilty['username']);
                      }
                    });

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 25),
                          child: Text(
                            'Bezetting: ${widget.selectedClub} ${IntlHelper.translateMonthEnglishDutch(DateFormat('dd-MMMM-yyyy').format(widget.selectedDate))}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          // Expanded neccesarry for the Listview to render correctly
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: club.data['assignableSpots'].length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            club.data['assignableSpots'][i],
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        _useLastWeeksOccupation
                                            ? UserPicker(
                                                availableVolunteers,
                                                _setOccupation,
                                                club.data['assignableSpots'][i],
                                                availability.data.documents
                                                    .map(
                                                      (availability) => {
                                                        'name': availability[
                                                            'username'],
                                                        'available':
                                                            availability[
                                                                'availability'],
                                                      },
                                                    )
                                                    .toList(),
                                                oldVolunteers:
                                                    lastWeekOccupation
                                                            .data.documents[0]
                                                        ['occupation'][club
                                                            .data[
                                                        'assignableSpots'][i]],
                                              )
                                            : UserPicker(
                                                availableVolunteers,
                                                _setOccupation,
                                                club.data['assignableSpots'][i],
                                                availability.data.documents
                                                    .map(
                                                      (availability) => {
                                                        'name': availability[
                                                            'username'],
                                                        'available':
                                                            availability[
                                                                'availability'],
                                                      },
                                                    )
                                                    .toList(),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              onPressed:
                                  lastWeekOccupation.data.documents.length > 0
                                      ? () => _loadLastWeekOccupation(
                                          lastWeekOccupation, club)
                                      : null,
                              child: Text('Laad vorige bezetting'),
                            ),
                            RaisedButton(
                              child: Text('Sla bezetting op'),
                              onPressed: () => _setNewOccupation(context),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
