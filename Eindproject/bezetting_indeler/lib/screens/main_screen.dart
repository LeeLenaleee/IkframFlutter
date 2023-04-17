import 'package:bezetting_indeler/screens/create_occupation_screen.dart';
import 'package:bezetting_indeler/screens/my_availability_screen.dart';
import 'package:bezetting_indeler/screens/occupation_overview_screen.dart';
import 'package:bezetting_indeler/widgets/NewAvailability.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var isOrganizer = false;
  var profileImage =
      'https://cdn.discordapp.com/attachments/417999374379909123/864483577710641152/avatar-placeholder.png';
  final List<Map<String, Object>> _pages = [
    {'page': OccupationOverviewScreen(), 'title': 'Bezettingen'},
    {'page': MyAvailabilityScreen(), 'title': 'Beschikbaarheid'},
    {'page': CreateOccupationScreen(), 'title': 'Bezetting toevoegen'},
  ];
  var _selectedPageIndex = 1;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId;

    return StreamBuilder(
      stream: Firestore.instance.collection('clubs').snapshots(),
      builder: (ctx, clubSnapshot) {
        if (clubSnapshot.connectionState == ConnectionState.active) {
          FirebaseAuth.instance.currentUser().then(
            (user) {
              Firestore.instance
                  .collection('users')
                  .document(user.uid)
                  .get()
                  .then(
                    (value) => setState(
                      () {
                        profileImage = value['image_url'];
                      },
                    ),
                  );

              userId = user.uid;

              clubSnapshot.data.documents.forEach(
                (club) {
                  if (club['organizer'] == user.uid) {
                    setState(() {
                      isOrganizer = true;
                    });
                  }
                },
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_pages[_selectedPageIndex]['title']),
            actions: [
              DropdownButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                ),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Logout')
                        ],
                      ),
                    ),
                    value: 'logout',
                  )
                ],
                onChanged: (identifier) {
                  if (identifier == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                },
                underline: Container(), //Remove underline with empty container
              ),
            ],
          ),
          body: _pages[_selectedPageIndex]['page'],
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            unselectedItemColor: Colors.white,
            selectedItemColor: Theme.of(context).accentColor,
            backgroundColor: Theme.of(context).primaryColor,
            currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list_sharp),
                label: 'Bezetting',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Beschikbaarheid',
              ),
              if (isOrganizer)
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Bezetting maken',
                )
            ],
          ),
          floatingActionButton: _selectedPageIndex == 1
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (_) => NewAvailability());
                  },
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
