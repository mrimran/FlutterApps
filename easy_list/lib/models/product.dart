import 'package:flutter/material.dart';

import './user.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  bool isFavorite;
  String userId;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      this.isFavorite = false,
      this.userId});

  Map get toMap {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'isFavorite': isFavorite,
      'userId': userId
    };
  }
}
