import 'dart:io';

import 'package:bezetting_indeler/widgets/inputs/clubs_input/clubs_selector.dart';
import 'package:bezetting_indeler/widgets/inputs/pickers/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    File userImageFile,
    List<String> selectedClubs,
  ) submitFn;
  final bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;
  List<String> _clubNames = [];
  List<String> _selectedClubs = [];

  void _setClubs(List<String> clubs) {
    _selectedClubs = clubs;
  }

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(ctx).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Geen profielfoto geselecteerd'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();
    widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
        _isLogin, _userImageFile, _selectedClubs);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('clubs').snapshots(),
      builder: (ctx, clubSnapshot) {
        if (clubSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        _clubNames = [];
        clubSnapshot.data.documents
            .forEach((document) => _clubNames.add(document.documentID));

        return Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (val) {
                        if (val.isEmpty || !val.contains('@')) {
                          return 'Ongeldig email adress';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email Adress'),
                      onSaved: (val) => _userEmail = val,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        autocorrect: true,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (val.isEmpty || val.length < 4) {
                            return 'Gebruikersnaam moet minimaal 4 karakters zijn';
                          }

                          return null;
                        },
                        decoration:
                            InputDecoration(labelText: 'Gebruikersnaam'),
                        onSaved: (val) => _userName = val,
                      ),
                    TextFormField(
                      key: ValueKey('pass'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 7) {
                          return 'Wachtwoord niet sterk genoeg, moet minimaal 7 tekens lang zijn';
                        }

                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Wachtwoord'),
                      obscureText: true,
                      onSaved: (val) => _userPassword = val,
                    ),
                    if (!_isLogin) ClubsSelector(_clubNames, _setClubs),
                    SizedBox(
                      height: 12,
                    ),
                    widget.isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            onPressed: () => _trySubmit(context),
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                    widget.isLoading
                        ? Container()
                        : FlatButton(
                            onPressed: () => setState(() {
                              _isLogin = !_isLogin;
                            }),
                            child: Text(_isLogin
                                ? 'Maak account'
                                : 'Ik heb al een account'),
                            textColor: Theme.of(context).primaryColor,
                          )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
