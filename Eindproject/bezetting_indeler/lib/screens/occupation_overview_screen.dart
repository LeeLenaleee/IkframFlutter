import 'package:bezetting_indeler/screens/detailed_occupation_overview_screen.dart';
import 'package:bezetting_indeler/widgets/occupation/occupation_overview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OccupationOverviewScreen extends StatelessWidget {
  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  void _openDetailedScreen(
    String club,
    DateTime date,
    Map<String, dynamic> occupations,
    BuildContext ctx,
  ) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) =>
            DetailedOccupationOverviewScreen(club, date, occupations),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, authUser) {
          if (authUser.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          }
          return FutureBuilder(
              future: Firestore.instance
                  .collection('users')
                  .document(authUser.data.uid)
                  .get(),
              builder: (ctx, currentUser) {
                if (currentUser.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                }

                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('occupations')
                        .where('club', whereIn: currentUser.data['clubs'])
                        .orderBy('targetDate', descending: true)
                        .snapshots(),
                    builder: (ctx, occupations) {
                      if (occupations.connectionState ==
                          ConnectionState.waiting) {
                        return _buildLoadingIndicator();
                      }

                      return FutureBuilder(
                          future: Firestore.instance
                              .collection('clubs')
                              .where('clubname',
                                  whereIn: currentUser.data['clubs'])
                              .getDocuments(),
                          builder: (ctx, clubs) {
                            if (clubs.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingIndicator();
                            }

                            return ListView.builder(
                              itemCount: occupations.data.documents.length,
                              itemBuilder: (ctx, i) => GestureDetector(
                                onTap: () => _openDetailedScreen(
                                  occupations.data.documents[i]['club'],
                                  occupations.data.documents[i]['targetDate']
                                      .toDate(),
                                  occupations.data.documents[i]['occupation'],
                                  context,
                                ),
                                child: OccupationOverview(
                                  occupations.data.documents[i]['club'],
                                  occupations.data.documents[i]['targetDate']
                                      .toDate(),
                                  clubs.data.documents.firstWhere((e) =>
                                      e['clubname'] ==
                                      occupations.data.documents[i]
                                          ['club'])['logoUrl'],
                                  occupations
                                      .data.documents[i]['occupation'].entries
                                      .toList()
                                      .map((mapEntry) {
                                        if (mapEntry.value.contains(
                                            currentUser.data['username'])) {
                                          return mapEntry.key;
                                        }
                                      })
                                      .where((e) => e != null)
                                      .toList(),
                                ),
                              ),
                            );
                          });
                    });
              });
        });
  }
}
