import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import '../models/CartModel.dart';
import '../models/MessageException.dart';
import '../services/Dio.dart';

class Carts extends ChangeNotifier {
  final String authToken;

  Carts(this.authToken, this._items);

  List<CartModel> _items = [];
  List<CartModel> get items {
    return [..._items];
  }

  bool _loading = false;
  bool get loading => _loading;

  int get itemCount {
    return _items.length;
  }

  int get totalAmout {
    var total = 0;
    _items.forEach((value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  Future<void> setLoading({required bool value}) async {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      Dio.Response response = await dio().get(
        '/api/carts/index',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );
      final data = response.data['data'] as List;
      final List<CartModel> loadedProducts = [];

      data.forEach((prodData) {
        loadedProducts.add(CartModel.fromJson(prodData));
      });

      _items = loadedProducts;
      notifyListeners();
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }

  Future<void> addItem({
    int? cartId,
    int? productId,
    String? name,
    int? price,
  }) async {
    int index = _items.indexWhere((element) => element.productId == productId);
    if (index.isNegative != true) {
      try {
        _items[index].quantity = _items[index].quantity + 1;

        await dio().post(
          '/api/carts/update/${_items[index].id}',
          data: _items[index],
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );
      } on Dio.DioError catch (error) {
        if (error.response!.statusCode! >= 500) {
          throw Exception(error.response!.data['message']);
        }

        throw MessageException(error.response!.data['message']);
      }
    } else {
      Map<String, dynamic> data = {"products_id": productId, "quantity": 1};

      try {
        Dio.Response response = await dio().post(
          '/api/carts/store',
          data: data,
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );

        _items.add(
          CartModel(
            id: response.data['data']['id'],
            productId: productId as int,
            name: name as String,
            price: price as int,
            quantity: 1,
          ),
        );
      } on Dio.DioError catch (error) {
        if (error.response!.statusCode! >= 500) {
          throw Exception(error.response!.data['message']);
        }

        throw MessageException(error.response!.data['message']);
      }
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> decrementItem(int cartId) async {
    final quantity = _items.firstWhere((list) => list.id == cartId).quantity;
    if (quantity == 1) {
      removeItem(cartId);
    } else {
      try {
        int index = _items.indexWhere((element) => element.id == cartId);
        _items[index].quantity = _items[index].quantity - 1;

        await dio().post(
          '/api/carts/update/${cartId}',
          data: _items[index],
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );
        notifyListeners();
      } on Dio.DioError catch (error) {
        if (error.response!.statusCode! >= 500) {
          throw Exception(error.response!.data['message']);
        }

        throw MessageException(error.response!.data['message']);
      }
    }
  }

  Future<void> incrementItem(int cartId) async {
    try {
      int index = _items.indexWhere((element) => element.id == cartId);
      _items[index].quantity = _items[index].quantity + 1;

      await dio().post(
        '/api/carts/update/${cartId}',
        data: _items[index],
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );
      notifyListeners();
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }

  Future<void> removeItem(int cartId) async {
    try {
      await dio().delete(
        '/api/carts/delete/${cartId}',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );
      _items.removeWhere((list) => list.id == cartId);

      notifyListeners();
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }
}
