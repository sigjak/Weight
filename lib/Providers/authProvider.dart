import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String uid;
  String _token;
  String _localId;
  String _expiresIn;

  static const key = 'AIzaSyDpgIquPiqxhtImtv1tnATs0tMGwBktGmY';

  String get token {
    return _token;
  }

  String get id {
    return _localId;
  }

  Future<void> signUp(String email, String password) async {
    print('signup');
    return authenticate(email, password, 'signUp').catchError((error) {
      throw error;
    });
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$key';
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
    _token = (responseData['idToken']);
    _expiresIn = (responseData['expiresIn']);
    _localId = (responseData['localId']);
    //print(responseData);
    print(responseData['email']);
    //print(_token);
    notifyListeners();
  }
  //Future<void> signIn(String email, String password) async {
  // print('signin');
  // final url =
  //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$key';
  // final response = await http.post(
  //   url,
  //   body: jsonEncode(
  //     {
  //       'email': email,
  //       'password': password,
  //       'returnSecureToken': true,
  //     },
  //   ),
  // );
  // final responseData = jsonDecode(response.body);
  // _token = (responseData['idToken']);
  // _expiresIn = (responseData['expiresIn']);
  // _localId = (responseData['localId']);

  // print(responseData['email']);
  // print(_localId);

  // print(_expiresIn);
  // notifyListeners();
  //await Future.delayed(Duration(seconds: 1));
  // }
}
