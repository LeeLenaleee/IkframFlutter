import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    File userImageFile,
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

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PLease pick a profile image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();
    widget.submitFn(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin,
      _userImageFile,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      return 'Please provide a valid email adress';
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
                        return 'Username must be at least 4 characters';
                      }

                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (val) => _userName = val,
                  ),
                TextFormField(
                  key: ValueKey('pass'),
                  validator: (val) {
                    if (val.isEmpty || val.length < 7) {
                      return 'Password not strong enough, must be at least 7 chars long';
                    }

                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (val) => _userPassword = val,
                ),
                SizedBox(
                  height: 12,
                ),
                widget.isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                      ),
                widget.isLoading
                    ? CircularProgressIndicator()
                    : FlatButton(
                        onPressed: () => setState(() {
                          _isLogin = !_isLogin;
                        }),
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have an account'),
                        textColor: Theme.of(context).primaryColor,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
