import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageToken {
  static final _storage = FlutterSecureStorage();

  static const _token = 'token';

  static Future<String?> getToken() async => await _storage.read(key: _token);
}
