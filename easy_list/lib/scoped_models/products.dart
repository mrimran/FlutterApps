import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;

  List<Product> get products {
    //Making clone of original List so we make changes in clone not the original one.
    return List.from(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  Product get selectedProduct {
    if(_selectedProductIndex == null) {
      return null;
    }

    return _products[_selectedProductIndex];
  }

  void toggleProductFavorite() {
    _products[_selectedProductIndex].isFavorite = !_products[_selectedProductIndex].isFavorite;
    _selectedProductIndex = null;

    notifyListeners();//notify view to reload and update the change of the favt icon
  }
}