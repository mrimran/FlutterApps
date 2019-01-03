import 'package:flutter/material.dart';

import './text.dart';

class TextControl extends StatefulWidget {
  String startText;

  TextControl(this.startText);

  @override
  State<StatefulWidget> createState() {
    return TextControlState();
  }
}

class TextControlState extends State<TextControl> {
  String text;

  @override
  void initState() {
    text = widget.startText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            setState(() {
              text = 'Text now changed.';
            });
          },
          child: Text('Change Text'),
        ),
        MyText(text)
      ],
    );
  }
}
