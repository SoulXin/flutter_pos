import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import '../models/User.dart';
import '../services/Dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  String _token = '';
  late User _user;

  bool get isAuth => _token != '';
  String get authToken => _token;

  User get user => _user;

  final storage = new FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    Map data = {'username': username, 'password': password};

    try {
      Dio.Response response = await dio().post('/api/login', data: data);
      setUser(token: response.data['data']['token']);
    } catch (error) {
      throw error;
    }
  }

  Future<void> register(String username, String password) async {
    Map data = {'username': username, 'password': password};

    try {
      Dio.Response response = await dio().post('/api/register', data: data);
      _token = response.data['data']['token'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() async {
    try {
      Dio.Response response = await dio().post('/api/logout',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));

      cleanUp();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void setUser({required String token}) async {
    try {
      Dio.Response response = await dio().get('/api/profile',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

      _token = token;
      _user = User.fromJson(response.data);
      storeToken(token: token);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void storeToken({required String token}) async {
    storage.write(key: 'token', value: token);
  }

  void cleanUp() async {
    _token = '';
    await storage.delete(key: 'token');
  }
}
