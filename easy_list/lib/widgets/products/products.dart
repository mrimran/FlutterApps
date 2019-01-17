import 'package:flutter/material.dart';
import './product_card.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/product.dart';
import '../../scoped_models/products.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
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

    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return _buildProductList(model.products);
    });
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
