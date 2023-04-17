import 'package:bezetting_indeler/helpers/availability_helper.dart';
import 'package:bezetting_indeler/widgets/NewAvailability.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezetting_indeler/helpers/intl_helper.dart';

class MyAvailabilityScreen extends StatefulWidget {
  @override
  _MyAvailabilityScreenState createState() => _MyAvailabilityScreenState();
}

class _MyAvailabilityScreenState extends State<MyAvailabilityScreen> {
  @override
  Widget build(BuildContext context) {
    const collection = 'availability';
    const cardTextSize = 17.0;

    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, currUser) {
        if (currUser.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder(
          stream: Firestore.instance
              .collection(collection)
              .where('userID', isEqualTo: currUser.data.uid)
              .orderBy('date', descending: true)
              .limit(
                  20) // TODO: Make this a settings thing so users can set themselfs how many old ones they want for performance
              .snapshots(),
          builder: (ctx, availabilitySnapshot) {
            if (availabilitySnapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (availabilitySnapshot.data.documents.length <= 0) {
              return Center(
                child: Text('Geen opgeslagen beschikbaarheden gevonden'),
              );
            }

            List<Map<String, dynamic>> availabilityList = [];
            availabilitySnapshot.data.documents.forEach((availability) {
              availabilityList.add({
                'date': availability['date'],
                'reason': availability['reason'],
                'availability': availability['availability'],
                'club': availability['club'],
                'documentID': availability.documentID
              });
            });

            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: availabilityList.length,
                itemBuilder: (ctx, i) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 3),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'Datum: ${IntlHelper.translateMonthEnglishDutch(DateFormat('dd-MMMM-yyyy').format(availabilityList[i]['date'].toDate()))}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Vereneging: ${availabilityList[i]['club']}',
                            style: TextStyle(fontSize: cardTextSize),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Reden: ${availabilityList[i]['reason']}',
                            style: TextStyle(
                              fontSize: cardTextSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${availabilityList[i]['availability']}',
                            style: TextStyle(fontSize: cardTextSize),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: ctx,
                                    builder: (_) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('Nieuwe beschikbaarheid'),
                                          DropdownButton(
                                            value: AvailabilityHelper
                                                .transLateAvailabilityToEnum(
                                                    '${availabilityList[i]['availability']}'),
                                            icon: const Icon(
                                                Icons.arrow_downward),
                                            iconSize: 24,
                                            elevation: 16,
                                            underline: Container(
                                              height: 2,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            onChanged: (newVal) {
                                              Firestore.instance
                                                  .collection(collection)
                                                  .document(
                                                      '${availabilityList[i]['documentID']}')
                                                  .updateData(
                                                {
                                                  'availability':
                                                      AvailabilityHelper
                                                          .transLateAvailability(
                                                              newVal)
                                                },
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            items: Availability.values
                                                .map(
                                                  (e) => DropdownMenuItem(
                                                    child: Text(
                                                      AvailabilityHelper
                                                          .transLateAvailability(
                                                              e),
                                                    ),
                                                    value: e,
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  Firestore.instance
                                      .collection(collection)
                                      .document(
                                          '${availabilityList[i]['documentID']}')
                                      .delete();
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
