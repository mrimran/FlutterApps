import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/product.dart';
import './pages/home.dart';
import './pages/product_admin.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map> _products = [];

  void _addProduct(Map product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, accentColor: Colors.deepPurple, buttonColor: Colors.deepPurple),
      //home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/home': (BuildContext context) => HomePage(_products),
        '/product_admin_page': (BuildContext context) =>
            ProductAdminPage(_addProduct, _deleteProduct)
      },
      onGenerateRoute: (RouteSettings settings) {
        //on handle dynamic named routes like /product/:id
        final List<String> pathElements = settings.name.split('/');

        if (pathElements[0] != '') {
          //this means the route isn't correct as in the very start of route we should have a /
          return null;
        }

        if (pathElements[1] == 'product') {
          //if we are on product route
          final int index =
              int.parse(pathElements[2]); //to entertain path like /product/2

          return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(
                  _products[index]['title'],
                  _products[index]['image'],
                  _products[index]['description'],
                  _products[index]['price']));
        }

        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        //When onGenerateRoute even fails, so this can be used to through 404 or maybe get back user to home page.
        return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(_products));
      },
    );
  }
}
