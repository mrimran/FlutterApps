import 'package:flutter/material.dart';

import './home.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String titleValue = '';
  String descriptionValue = '';
  double priceValue = 0.0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      onSaved: (String value) {
        setState(() {
          titleValue = value;
        });
      },
      decoration: InputDecoration(labelText: 'Product title'),
      validator: (String value) {
        if(value.isEmpty) {
          return 'Title is required.';
        }
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 3,
      onSaved: (String desc) {
        descriptionValue = desc;
      },
      decoration: InputDecoration(labelText: 'Product description'),
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (String price) {
        priceValue = double.parse(price);
      },
      decoration: InputDecoration(labelText: 'Product price'),
    );
  }

  void _submitForm() {
    if(!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();
    final Map product = {
      'title': titleValue,
      'description': descriptionValue,
      'price': priceValue,
      'image': 'assets/food.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 600 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding),
          children: <Widget>[
            _buildTitleTextField(),
            Text(titleValue),
            _buildDescriptionTextField(),
            _buildPriceTextField(),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: _submitForm,
              child: Text('Save'),
            )
          ],
        )));
  }
}
