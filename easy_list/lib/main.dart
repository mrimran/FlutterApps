import 'package:flutter/material.dart';

//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/product.dart';
import './pages/home.dart';
import './pages/product_admin.dart';
import './models/product.dart';
import './scoped_models/products.dart';

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
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductsModel>(
      model: ProductsModel(),//initiating only one instance of the ProductsModel in whole application
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => HomePage(),
          '/product_admin_page': (BuildContext context) => ProductAdminPage()
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
                builder: (BuildContext context) =>
                    ProductPage(index));
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          //When onGenerateRoute even fails, so this can be used to through 404 or maybe get back user to home page.
          return MaterialPageRoute(
              builder: (BuildContext context) => HomePage());
        },
      ),
    );
  }
}
