import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exeption.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String authToken;
  String userId;

  Uri url;

  // var _showFavoritesOnly = false;

  Products(String authToken, this.userId, this._items) {
    this.authToken = authToken;
    url = Uri.https(
      'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
      'products.json',
      {
        'auth': authToken,
        'orderBy': '"creatorId"',
        'equalTo': '"$userId"',
      },
    );
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final url = Uri.https(
      'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
      'products.json',
      {
        'auth': authToken,
        (filterByUser ? 'orderBy' : ''): filterByUser ? '"creatorId"' : '',
        (filterByUser ? 'equalTo' : ''): filterByUser ? '"$userId"' : '',
      },
    );

    try {
      final res = await http.get(url);
      final extractedData = jsonDecode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      final favUrl = Uri.https(
        'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
        'userFavorites/$userId/.json',
        {
          'auth': authToken,
        },
      );

      if (extractedData == null) {
        return;
      }

      final favoriteRes = await http.get(favUrl);
      final favData = jsonDecode(favoriteRes.body);

      extractedData.forEach((key, prodData) {
        loadedProducts.add(
          Product(
            id: key,
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavorite: favData == null ? false : favData[key] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }

    // _items = jsonDecode(res.body)
  }

  Future<void> addProduct(Product product) {
    return http
        .post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        },
      ),
    )
        .then((res) {
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index == -1) {
      return;
    }

    final url = Uri.https(
        'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
        'products/$id.json',
        {'auth': authToken});

    http.patch(url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ));
    _items[index] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    print(authToken);
    final url = Uri.https(
        'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
        'products/$id.json',
        {'auth': authToken});
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final res = await http.delete(url);

    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Invalid method');
    }
    existingProduct = null;
  }
}
