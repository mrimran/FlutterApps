import 'package:flutter/material.dart';

import './user.dart';
import './location_data.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  bool isFavorite;
  String userId;
  LocationData location;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      this.isFavorite = false,
      this.userId,
      this.location});

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
