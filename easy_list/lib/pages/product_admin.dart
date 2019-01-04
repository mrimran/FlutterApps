import 'package:flutter/material.dart';

import './home.dart';
import './product_create.dart';
import './product_list.dart';

class ProductAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Choose'),
                ),
                ListTile(
                  title: Text('Home Page'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Product Admin'),
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              )
            ]),
          ),
          body: TabBarView(children: [
            ProductCreatePage(),
            ProductListPage()
          ]),
        ));
  }
}
