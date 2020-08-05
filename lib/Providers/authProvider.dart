import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  String name;
  String email;
  String token = 'hello';

  String get myToken {
    return token;
  }
}
