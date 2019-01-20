import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ProductsModel on Model {
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFav = false;

  List<Product> get products {
    //Making clone of original List so we make changes in clone not the original one.
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if(_showFav) {
      return _products.where((Product product) => product.isFavorite).toList();
    }

    return List.from(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;

    if (_selectedProductIndex != null) {
      notifyListeners();
    }
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

    notifyListeners();//notify view to reload and update the change of the favt icon
  }

  void toggleFavDisplayMode() {
    _showFav = !_showFav;

    notifyListeners();
  }

  bool get displayFavOnly {
      return _showFav;
  }
}