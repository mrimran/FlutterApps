import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';

mixin UserModel on Model {
  User _authUser;

  User get authUser {
    return _authUser;
  }

  void login(String email, String password) {
    _authUser = User(id: '1', email: email, password: password);
  }
}