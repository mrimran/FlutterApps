import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/products/price_tag.dart';
import 'package:easy_list/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;

  ProductPage(this.title, this.imageUrl, this.description, this.price);

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

  Widget _buildTitlePriceRow() {
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
              Image.asset(imageUrl),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
                child: Text(
                  'Islamabad',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.bottomRight,
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildTitlePriceRow(),
              SizedBox(
                height: 10.0,
              ),
              Text(description),
            ],
          ),
        ));
  }
}
