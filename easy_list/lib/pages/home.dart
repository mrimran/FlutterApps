import 'package:flutter/material.dart';

import '../product_manager.dart';
import './product_admin.dart';

class HomePage extends StatelessWidget {
  final List<Map> products;

  HomePage(this.products);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/product_admin_page');
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('EasyList'),
      ),
      body: ProductManager(products),
    );
  }
}
