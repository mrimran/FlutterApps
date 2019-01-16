import 'package:flutter/material.dart';

import './home.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map product;
  final int productIndex;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  String titleValue = '';
  String descriptionValue = '';
  double priceValue = 0.0;
  final Map formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      initialValue: widget.product == null ? '' : widget.product['title'],
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long.';
        }
      },
      onSaved: (String value) {
        formData['title'] = value;
      },
      decoration: InputDecoration(labelText: 'Product title'),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      initialValue: widget.product == null ? '' : widget.product['description'],
      maxLines: 3,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Title is required and should be 10+ characters long.';
        }
      },
      onSaved: (String desc) {
        formData['description'] = desc;
      },
      decoration: InputDecoration(labelText: 'Product description'),
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      initialValue:
          widget.product == null ? '' : widget.product['price'].toString(),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:[.]\d+)?$').hasMatch(value)) {
          return 'Title is required and should be a valid number.';
        }
      },
      onSaved: (String price) {
        formData['price'] = double.parse(price);
      },
      decoration: InputDecoration(labelText: 'Product price'),
    );
  }

  void _submitForm() {
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    if (widget.product == null) {
      widget.addProduct(formData);
    } else {
      widget.updateProduct(widget.productIndex, formData);
    }

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 600 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Widget pageContent = GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
              FocusNode()); //close the keyboard when we tap outside of input fields of the form.
        },
        child: Container(
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
                ))));

    // TODO: implement build
    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(title: Text('Edit Product')), body: pageContent);
  }
}
