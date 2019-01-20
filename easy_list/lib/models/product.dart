import 'package:flutter/material.dart';

import './user.dart';

class Product {
  final String title;
  final String description;
  final double price;
  final String image;
  bool isFavorite;
  User user;

  Product(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      this.isFavorite = false,
      this.user});
}
