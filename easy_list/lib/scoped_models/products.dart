import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';

mixin ProductsModel on Model {
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFav = false;
  final productsEndpoint =
      'https://flutter-easylist-35b62.firebaseio.com/products.json';

  List<Product> get products {
    //Making clone of original List so we make changes in clone not the original one.
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFav) {
      return _products.where((Product product) => product.isFavorite).toList();
    }

    return List.from(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
  }

  Future saveProductOnServer(Map productData) async {
    return await http.post(productsEndpoint, body: json.encode(productData));
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
    if (_selectedProductIndex == null) {
      return null;
    }

    return _products[_selectedProductIndex];
  }

  void toggleProductFavorite() {
    _products[_selectedProductIndex].isFavorite =
        !_products[_selectedProductIndex].isFavorite;

    notifyListeners(); //notify view to reload and update the change of the favt icon
  }

  void toggleFavDisplayMode() {
    _showFav = !_showFav;

    notifyListeners();
  }

  void fetchProducts() async {
    http.Response res = await http.get(productsEndpoint);
    final Map<String, dynamic> productListData = json.decode(res.body);
    final List<Product> fetchedProductList = [];

    //print(resBody);
    //add the product list on local codebase

    if(productListData != null) {
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userId: productData['userId'] == null ? '' : productData['userId']);

        fetchedProductList.add(product);
      });
    }

    _products = fetchedProductList;
    notifyListeners();
  }

  bool get displayFavOnly {
    return _showFav;
  }
}
