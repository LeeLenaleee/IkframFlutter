import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
        'orders/$userId.json',
        {'auth': authToken});

    final res = await http.get(url);

    final List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(res.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'],
                  ))
              .toList(),
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'shopappfluttercourse-default-rtdb.europe-west1.firebasedatabase.app',
        'orders/$userId.json',
        {'auth': authToken});
    print(url);

    final timeStamp = DateTime.now();

    final res = await http.post(
      url,
      body: jsonEncode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(res.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
