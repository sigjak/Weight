import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String uid;
  String _token;
  String _localId;
  bool regSuccess = false;

  static const key = 'AIzaSyDpgIquPiqxhtImtv1tnATs0tMGwBktGmY';

  String get token {
    return _token;
  }

  String get id {
    return _localId;
  }

  void registerAlert(String alertMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          content: Text(
            alertMessage,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$key';
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw responseData['error']['message'];
      } else {
        regSuccess = true;
        _token = (responseData['idToken']);
        _localId = (responseData['localId']);
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
