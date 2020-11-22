import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final userData = json.decode(prefs.getString('userData'));

    final expiryDate = DateTime.parse(userData['_expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['_token'];
    _userId = userData['_userId'];
    _expiryDate = expiryDate;

    notifyListeners();

    return true;
  }

  Future<void> _authenticate(String email, String password, String uri) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$uri?key=AIzaSyAKDVM1NcODyMQJTEoh15ubIFJFvJ7dPsU';

      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['message']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['lodalId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        '_token': _token,
        '_userId': _userId,
        '_expiryDate': _expiryDate.toIso8601String()
      });

      prefs.setString('userData', userData);

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    await _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, 'signUp');
  }
}
