import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

mixin UserModel on Model {
  User _authUser;
  final authEndpoint =
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/';
  final authKey = 'AIzaSyBxr8j7o3760Nvp-kkDgJK7IcAsUQBCbTs';

  User get authUser {
    return _authUser;
  }

  Future<Map> login(String email, String password) async {
    Map authData = this.authPayload(email, password);

    final http.Response res = await http.post(
        this.authEndpoint + 'verifyPassword?key=$authKey',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});
    //authUser = User(id: '1', email: email, password: password);

    final Map resBody = json.decode(res.body);

    bool hasError = false;
    String message = 'Auth successeeded';
    if (resBody.containsKey('error')) {
      hasError = true;
      if (resBody['error']['message'] == 'EMAIL_NOT_FOUND' ||
          resBody['error']['message'] == 'INVALID_PASSWORD') {
        message = 'Wrong email or password.';
      } else {
        message = 'Something went wrong.';
      }
    }

    return {'success': !hasError, 'message': message};
  }

  Future<Map> signup(String email, String password) async {
    Map authData = this.authPayload(email, password);

    final http.Response res = await http.post(
        this.authEndpoint +
            'signupNewUser?key=AIzaSyBxr8j7o3760Nvp-kkDgJK7IcAsUQBCbTs',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    final Map resBody = json.decode(res.body);

    bool hasError = false;
    String message = 'Auth successeeded';
    if (resBody.containsKey('error')) {
      hasError = true;
      if (resBody['error']['message'] == 'EMAIL_EXISTS') {
        message = 'Email already exists.';
      } else {
        message = 'Something went wrong.';
      }
    }

    return {'success': !hasError, 'message': message};
  }

  Map authPayload(String email, String password) {
    return {
      //required by google auth
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
  }
}
