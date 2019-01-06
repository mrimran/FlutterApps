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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              onChanged: (String value) {
                setState(() {
                  titleValue = value;
                });
              },
              decoration: InputDecoration(labelText: 'Product title'),
            ),
            Text(titleValue),
            TextField(
              maxLines: 3,
              onChanged: (String desc) {
                descriptionValue = desc;
              },
              decoration: InputDecoration(labelText: 'Product description'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (String price) {
                priceValue = double.parse(price);
              },
              decoration: InputDecoration(labelText: 'Product price'),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: () {
                final Map product = {
                  'title': titleValue,
                  'description': descriptionValue,
                  'price': priceValue,
                  'image': 'assets/food.jpg'
                };
                widget.addProduct(product);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Save'),
            )
          ],
        ));
  }
}
