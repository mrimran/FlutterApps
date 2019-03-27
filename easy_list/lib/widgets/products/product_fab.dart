import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/product.dart';
import '../../scoped_models/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: FloatingActionButton(
                heroTag: 'contact',
                backgroundColor: Theme.of(context).cardColor,
                mini: true,
                onPressed: () async {
                  final url = 'mailto:${widget.product.userEmail}';
                  if(await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch URL';
                  }
                },
                child: Icon(
                  Icons.mail,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Container(
              child: FloatingActionButton(
                heroTag: 'favt',
                backgroundColor: Theme.of(context).cardColor,
                mini: true,
                onPressed: () {
                  model.toggleProductFavorite();
                },
                child: Icon(
                  widget.product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
            FloatingActionButton(
              heroTag: 'options',
              onPressed: () {},
              child: Icon(Icons.more_vert),
            ),
          ],
        );
      },
    );
  }
}
