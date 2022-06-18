import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:mobile/models/CartModel.dart';
import 'package:mobile/models/ProductModel.dart';
import '../services/Dio.dart';

class Carts extends ChangeNotifier {
  final String authToken;
  Carts(this.authToken);

  List<CartModel> _items = [];
  List get items => _items;

  void addItem({ProductModel? product}) {
    print(product!.name);

    print("tambah");
  }

  void removeItem({ProductModel? product}) {
    print(product);
    print("kurang");
  }
}
