import 'package:flutter/material.dart';

import './products.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;//will be changed from outside

  ProductManager(this.startingProduct);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];

  @override
  void initState() {//runs before build runs
    _products.add(widget.startingProduct);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: RaisedButton(
            onPressed: () {
              setState(() {
                _products.add('Advanced Food Tester');
              });
            }, //anon empty function
            child: Text('Add Product'),
          ),
        ),
        Products(_products)
      ],
    );
  }
}
