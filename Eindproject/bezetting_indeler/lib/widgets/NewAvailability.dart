import 'package:bezetting_indeler/widgets/new_availability_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewAvailability extends StatefulWidget {
  @override
  _NewAvailabilityState createState() => _NewAvailabilityState();
}

class _NewAvailabilityState extends State<NewAvailability> {
  List<String> _clubs = [];
  String _username;
  String _userId;
  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((authUser) {
      Firestore.instance
          .collection('users')
          .document(authUser.uid)
          .get()
          .then((userSnapshot) {
        setState(() {
          userSnapshot.data['clubs'].forEach((el) => _clubs.add(el));
          _username = userSnapshot.data['username'];
          _userId = authUser.uid;
        });
      });
    });
    return (_clubs.length != 0 && _username != null && _userId != null)
        ? NewAvailabilityForm(_clubs, _username, _userId)
        : _buildLoadingIndicator();
  }
}
