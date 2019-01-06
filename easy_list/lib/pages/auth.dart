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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              TextField(
                onChanged: (String email) {
                  setState(() {
                    this.email = email;
                  });
                },
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                onChanged: (String password) {
                  setState(() {
                    this.password = password;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 10.0,),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text('LOGIN'),
              ),
            ],
          ),
        ));
  }
}
