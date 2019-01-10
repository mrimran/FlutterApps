import 'package:flutter/material.dart';

import './home.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  String email = '';
  String password = '';

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'));
  }

  Widget _buildEmailTextField() {
    return TextField(
      onChanged: (String email) {
        setState(() {
          this.email = email;
        });
      },
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      onChanged: (String password) {
        setState(() {
          this.password = password;
        });
      },
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
    );
  }

  void _submitForm() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;//Media query
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
                    width: targetWidth,//80% of our device width
            child: Column(children: <Widget>[
              _buildEmailTextField(),
              SizedBox(
                height: 10.0,
              ),
              _buildPasswordTextField(),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                textColor: Colors.white,
                onPressed: _submitForm,
                child: Text('LOGIN'),
              ),
            ]),
          ))),
        ));
  }
}
