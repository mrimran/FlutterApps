import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/products/price_tag.dart';
import 'package:easy_list/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  _showWarningDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone.'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
    //Navigator.pop(context, true)
  }

  Widget _buildTitlePriceRow(String title, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(title),
        SizedBox(
          width: 8.0,
        ),
        PriceTag(price.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false); //ignore original pop request
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Product Detail'),
          ),
          body: ListView(
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/food.jpg'),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
                child: Text(
                  product.location.address,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.bottomRight,
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildTitlePriceRow(product.title, product.price),
              SizedBox(
                height: 10.0,
              ),
              Text(product.description),
            ],
          ),
        ));
  }
}
