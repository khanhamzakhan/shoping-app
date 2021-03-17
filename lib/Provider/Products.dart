import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite = false});

  void setFavourite(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  void toggleFavourite() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url =
        'https://shop-app-5f66d-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(url,
          body: json.encode({'isFavourite': isFavourite}));
      if (response.statusCode >= 400) {
        setFavourite(oldStatus);
      }
    } catch (error) {
      setFavourite(oldStatus);
    }
  }
}
