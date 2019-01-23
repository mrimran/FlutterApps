import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  final Map formData = {'email': null, 'password': null};

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordTextController = TextEditingController();

  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
        ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      validator: (String value) {
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Enter a valid email address e.g. example@example.com';
        }
      },
      onSaved: (String email) {
        formData['email'] = email;
      },
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Enter a password having 5+ characters.';
        }
      },
      onSaved: (String password) {
        formData['password'] = password;
      },
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      validator: (String value) {
        if (passwordTextController.text != value) {
          return 'Password do not match.';
        }
      },
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
    );
  }

  void _submitForm(MainModel model) async {
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    if (_authMode == AuthMode.Login) {
      model.login(formData['email'], formData['password']);
    } else {
      final Map resInfo = await model.signup(
          formData['email'], formData['password']);
      if (resInfo['success']) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        showDialog(context: context, builder: (BuildContext contenxt) {
          return AlertDialog(title: Text('An error occured!'),
            content: Text(resInfo['message']),
            actions: <Widget>[
              FlatButton(child: Text('OK'), onPressed: () {
                Navigator.of(context).pop();
              },)
            ],);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width; //Media query
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: SingleChildScrollView(
                  child: Container(
                    width: targetWidth, //80% of our device width
                    child: Form(
                        key: formKey,
                        child: Column(children: <Widget>[
                          _buildEmailTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildPasswordTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _authMode == AuthMode.Signup
                              ? _buildPasswordConfirmTextField()
                              : Container(),
                          _authMode == AuthMode.Signup
                              ? SizedBox(
                            height: 10.0,
                          )
                              : Container(),
                          FlatButton(
                            child: Text(
                                'Switch to ${_authMode == AuthMode.Login
                                    ? 'Signup'
                                    : 'Login'}'),
                            onPressed: () {
                              setState(() {
                                _authMode = _authMode == AuthMode.Login
                                    ? AuthMode.Signup
                                    : AuthMode.Login;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ScopedModelDescendant<MainModel>(
                            builder:
                                (BuildContext context, Widget child,
                                MainModel model) {
                              return RaisedButton(
                                textColor: Colors.white,
                                onPressed: () => _submitForm(model),
                                child: Text('LOGIN'),
                              );
                            },
                          ),
                        ])),
                  ))),
        ));
  }
}
