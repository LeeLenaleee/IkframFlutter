import 'dart:io';

import 'package:bezetting_indeler/helpers/array_helpers.dart';
import 'package:bezetting_indeler/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _store = Firestore.instance;
  var _isLoading = false;

  void _subitForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    File userImageFile,
    List<String> selectedClubs,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + p.extension(userImageFile.path));

        await ref.putFile(userImageFile).onComplete;

        final url = await ref.getDownloadURL();

        await _store.collection('users').document(authResult.user.uid).setData(
          {
            'username': userName,
            'email': email,
            'image_url': url,
            'clubs': ArrayHelpers.removeDuplicatesFromList(selectedClubs)
          },
        );

        for (String club in selectedClubs) {
          var clubInfo = await _store.collection('clubs').document(club).get();
          await _store.collection('clubs').document(club).updateData({
            'userNames': [
              {
                'userName': userName,
                'userId': authResult.user.uid,
              },
              ...clubInfo['userNames']
            ]
          });
        }
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_subitForm, _isLoading),
    );
  }
}
