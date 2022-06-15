import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:mobile/models/CategoryModel.dart';
import '../services/Dio.dart';

import 'package:flutter/material.dart';

class Category extends ChangeNotifier {
  final String authToken;
  Category(this.authToken);

  List<CategoryModel> _items = [];

  List<CategoryModel> get items => _items;

  Future<void> getCategory() async {
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
        loadedProducts.add(CategoryModel(
          id: prodData['id'],
          name: prodData['name'],
        ));
      });

      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void selectedCategory(Map<String, dynamic> category) {
    print(category);
  }
}
