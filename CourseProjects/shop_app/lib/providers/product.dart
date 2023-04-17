import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _rollBackFavVal(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https(
      'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
      'userFavorites/$userId/$id.json',
      {
        'auth': token,
      },
    );
    try {
      final res = await http.put(
        url,
        body: jsonEncode(isFavorite),
      );

      if (res.statusCode >= 400) {
        _rollBackFavVal(oldStatus);
      }
    } catch (err) {
      _rollBackFavVal(oldStatus);
    }
  }
}
