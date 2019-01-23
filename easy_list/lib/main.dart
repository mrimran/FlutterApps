import 'package:flutter/material.dart';

//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/product.dart';
import './pages/home.dart';
import './pages/product_admin.dart';
import './scoped_models/main.dart';
import './models/product.dart';

void main() {
  //debugPaintSizeEnabled = true;
  try {
    runApp(MyApp());
  } catch (e) {
    print(e.toString());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final model = MainModel();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      //initiating only one instance of the ProductsModel in whole application
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => HomePage(model),
          '/product_admin_page': (BuildContext context) =>
              ProductAdminPage(model)
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
            final String productId =
                pathElements[2]; //to entertain path like /product/2

            final Product product =
                model.products.firstWhere((Product product) {
              return product.id == productId;
            });

            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product));
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          //When onGenerateRoute even fails, so this can be used to through 404 or maybe get back user to home page.
          return MaterialPageRoute(
              builder: (BuildContext context) => HomePage(model));
        },
      ),
    );
  }
}
