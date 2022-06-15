import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = "http://127.0.0.1:8000";
  dio.options.headers['Content-Type'] = 'application/json;charset=UTF-8';
  dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['Charset'] = 'utf-8';

  return dio;
}
