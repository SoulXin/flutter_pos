import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:mobile/models/ProductModel.dart';
import '../services/Dio.dart';

class Products extends ChangeNotifier {
  final String authToken;
  Products(this.authToken);

  List _items = [];
  List get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> setLoading({required bool value}) async {
    _loading = value;
    notifyListeners();
  }

  Future<void> getProducts({int? id}) async {
    try {
      Dio.Response response = await dio().get(
        '/api/products/${id}',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      final data = response.data['data'] as List;
      final List<ProductModel> loadedProducts = [];

      data.forEach((prodData) {
        loadedProducts.add(ProductModel.fromJson(prodData));
      });

      _items = loadedProducts;
      _loading = false;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
