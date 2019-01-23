import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

mixin UserModel on Model {
  User _authUser;

  User get authUser {
    return _authUser;
  }

  void login(String email, String password) {
    _authUser = User(id: '1', email: email, password: password);
  }

  Future<Map> signup(String email, String password) async {
    final Map authData = {
      //required by google auth
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final http.Response res = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBxr8j7o3760Nvp-kkDgJK7IcAsUQBCbTs',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    final Map resBody = json.decode(res.body);

    bool hasError = false;
    String message = 'Auth successeeded';
    if(resBody.containsKey('error')) {
      hasError = true;
      if(resBody['error']['message'] == 'EMAIL_EXISTS') {
        message = 'Email already exists.';
      } else {
        message = 'Something went wrong.';
      }
    }

    return {'success': !hasError, 'message': message};
  }
}
