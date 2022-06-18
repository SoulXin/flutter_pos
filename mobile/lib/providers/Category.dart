import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:mobile/models/CategoryModel.dart';
import '../services/Dio.dart';

class Category extends ChangeNotifier {
  List<CategoryModel> _items = [];

  List<CategoryModel> get items => _items;

  int findIdCategory(String? name) =>
      items.firstWhere((element) => element.name == name).id;

  Future<void> getCategory({String? authToken}) async {
    try {
      Dio.Response response = await dio().get(
        '/api/categories',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      final data = response.data['data'] as List;
      final List<CategoryModel> loadedProducts = [];

      data.forEach((prodData) {
        loadedProducts.add(CategoryModel.fromJson(prodData));
      });

      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
