import 'package:flutter/material.dart';
import './product_card.dart';

class Products extends StatelessWidget {
  final List<Map> products;

  Products(this.products) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProductList() {
    Widget productCard =
        Center(child: Text('No products found, please add some.'));

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    }

    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');

    return _buildProductList();
  }
}

/** Non dymamic list, will keep items always in memory only use for small lists
    return ListView(
    children: products
    .map((element) => Card(
    child: Column(
    children: <Widget>[
    Image.asset('assets/food.jpg'),
    Text(element)
    ],
    ),
    ))
    .toList(),
    );
 */