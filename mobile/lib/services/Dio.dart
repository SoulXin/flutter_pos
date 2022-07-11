import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = "http://backend.local";
  dio.options.headers['Content-Type'] = 'application/json;charset=UTF-8';
  dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['Charset'] = 'utf-8';

  return dio;
}
