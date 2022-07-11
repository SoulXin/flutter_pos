import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:mobile/models/CategoryModel.dart';
import 'package:mobile/models/MessageException.dart';
import '../services/Dio.dart';

class Category extends ChangeNotifier {
  final String authToken;
  Category(this.authToken);

  String _name = '';
  String get name => _name;

  List<CategoryModel> _items = [];
  List<CategoryModel> get items {
    return [..._items];
  }

  Future<void> fetchData() async {
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
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }

  Future<void> fetchDataDetail({required int id}) async {
    try {
      Dio.Response response = await dio().get(
        '/api/categories/detail/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      final data = CategoryModel.fromJson(response.data['data']);
      _name = data.name;

      notifyListeners();
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }

  Future<String> add({required String name}) async {
    Map data = {'name': name};

    try {
      Dio.Response response = await dio().post(
        '/api/categories/store',
        data: data,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      fetchData();
      _name = name;
      notifyListeners();

      return response.data['message'];
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }

  Future<String> update({int? id, required String name}) async {
    Map data = {'name': name};

    try {
      Dio.Response response = await dio().post(
        '/api/categories/update/$id',
        data: data,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      fetchData();

      _name = name;
      notifyListeners();

      return response.data['message'];
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }

  Future<String> delete({required int id}) async {
    try {
      Dio.Response response = await dio().delete(
        '/api/categories/delete/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      fetchData();

      return response.data['message'];
    } on Dio.DioError catch (error) {
      if (error.response!.statusCode! >= 500) {
        throw Exception(error.response!.data['message']);
      }

      throw MessageException(error.response!.data['message']);
    }
  }
}
