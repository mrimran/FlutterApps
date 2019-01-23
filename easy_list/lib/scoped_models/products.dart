import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';
import '../scoped_models/user.dart';

mixin ProductsModel on Model {
  List<Product> _products = [];
  String _selectedProductId;
  bool _showFav = false;
  bool isLoading = false;

  final productsEndpoint = 'https://flutter-easylist-35b62.firebaseio.com/';

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

  Future saveProductOnServer(Map productData, {String productId = ''}) async {
    if (productId.isEmpty) {
      return await http.post(productsEndpoint + 'products.json?auth=${UserModel.loggedInUser.token}',
          body: json.encode(productData));
    } else {
      return await http.put(productsEndpoint + 'products/$productId.json?auth=${UserModel.loggedInUser.token}',
          body: json.encode(productData));
    }
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == this.selectedProductId;
    });
  }

  void updateProduct(Product product) {
    _products[this.selectedProductIndex] = product;
  }

  void deleteProduct() async {
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    this._selectedProductId = null;
    //notifyListeners();
    try {
      await http.delete(productsEndpoint + 'products/$deletedProductId.json?auth=${UserModel.loggedInUser.token}');
      this.isLoading = false;
    } catch (e) {
      print(e.toString());
      this.isLoading = false;
    }
  }

  void selectProduct(String productId) {
    _selectedProductId = productId;
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  Product get selectedProduct {
    if (_selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((product) {
      return product.id == this.selectedProductId;
    });
  }

  void toggleProductFavorite() {
    _products[this.selectedProductIndex].isFavorite =
        !_products[this.selectedProductIndex].isFavorite;

    notifyListeners(); //notify view to reload and update the change of the favt icon
  }

  void toggleFavDisplayMode() {
    _showFav = !_showFav;

    notifyListeners();
  }

  Future fetchProducts() async {
    this.isLoading = true;
    http.Response res;
    try {
      res = await http.get(productsEndpoint + 'products.json?auth=${UserModel.loggedInUser.token}');
      final Map<String, dynamic> productListData = json.decode(res.body);
      final List<Product> fetchedProductList = [];

      //print(resBody);
      //add the product list on local codebase

      if (productListData != null) {
        productListData.forEach((String productId, dynamic productData) {
          final Product product = Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              image: productData['image'],
              userId:
                  productData['userId'] == null ? '' : productData['userId']);

          fetchedProductList.add(product);
        });
      }

      _products = fetchedProductList;
    } catch (e) {
      print(e.toString());
    }

    this.isLoading = false;

    notifyListeners();

    return res;
  }

  bool get displayFavOnly {
    return _showFav;
  }

  void toggleIsLoading() {
    this.isLoading = !this.isLoading;
    notifyListeners();
  }
}
