import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:mobile/models/CategoryModel.dart';
import 'package:mobile/models/ProductModel.dart';
import 'package:mobile/providers/Category.dart';
import '../services/Dio.dart';

class Products extends ChangeNotifier {
  final String authToken;
  Category? providerCategory;
  Products(this.authToken, this.providerCategory);

  List _items = [];
  List get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  Map<int, ProductModel> _temp = {};
  Map<int, ProductModel> get temp => _temp;

  List<CategoryModel> _itemsCategory = [];
  List<CategoryModel> get itemsCategory => _itemsCategory;

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  Future<void> setLoading({required bool value}) async {
    _loading = value;
    notifyListeners();
  }

  void clearDetail() {
    _temp.clear();
    _selectedCategory = '';
  }

  void changeSelected({String? name}) {
    _selectedCategory = name.toString();
    notifyListeners();
  }

  void getCategory() async {
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

      _itemsCategory = loadedProducts;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void fetchData() async {
    try {
      Dio.Response response = await dio().get(
        '/api/products',
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

  Future<void> getProducts({int? id}) async {
    try {
      Dio.Response response = await dio().get(
        '/api/products/$id',
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

  void detail({int? id}) async {
    try {
      Dio.Response responseProductDetail = await dio().get(
        '/api/products/detail/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (providerCategory!.items.isEmpty) {
        Dio.Response responseCategory = await dio().get(
          '/api/categories',
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );

        final dataCategory = responseCategory.data['data'] as List;
        final List<CategoryModel> loadedProducts = [];

        dataCategory.forEach((prodData) {
          loadedProducts.add(CategoryModel.fromJson(prodData));
        });

        _itemsCategory = loadedProducts;
      } else {
        _itemsCategory = providerCategory!.items;
      }

      var dataProduct =
          ProductModel.fromJson(responseProductDetail.data['data']);

      _temp[dataProduct.id] = dataProduct;

      _selectedCategory = _itemsCategory
          .firstWhere((element) => element.id == dataProduct.categoryId)
          .name;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> add(
      {required String name,
      required int price,
      required int categoriesId}) async {
    Map data = {'name': name, 'price': price, 'categories_id': categoriesId};

    try {
      await dio().post(
        '/api/products/store',
        data: data,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );
      clearDetail();
      fetchData();
    } catch (error) {
      throw error;
    }
  }

  Future<void> update({
    int? id,
    required String name,
    required int price,
    required int categoriesId,
  }) async {
    Map data = {'name': name, 'price': price, 'categories_id': categoriesId};

    try {
      await dio().post(
        '/api/products/update/$id',
        data: data,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      fetchData();

      _temp[id as int] = ProductModel(
        id: id,
        name: name,
        price: price,
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> delete({required int id}) async {
    try {
      await dio().delete(
        '/api/products/delete/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      fetchData();
    } catch (error) {
      throw error;
    }
  }
}
