import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exeption.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;
  String _authDataKey = 'authData';

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlPart,
  ) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      urlPart,
      {
        'key': 'AIzaSyCKO2YG4vZ8ybNd8zXne5UZCx9DbLShFMY',
      },
    );
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final resData = jsonDecode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            resData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expireDate.toIso8601String(),
        },
      );
      prefs.setString(_authDataKey, userData);
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'v1/accounts:signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'v1/accounts:signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_authDataKey)) {
      return false;
    }

    final userData =
        jsonDecode(prefs.getString(_authDataKey)) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _expireDate = expiryDate;
    _userId = userData['userId'];

    notifyListeners();
    _autoLogout();

    return true;
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
    }

    _authTimer = null;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) => prefs.remove(_authDataKey));
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    print('yeet');
    print(DateTime.now().add(Duration(seconds: 4)).second);
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
