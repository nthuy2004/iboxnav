import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String AUTH_TOKEN = "AUTH_TOKEN";

class SharedPref {
  static const FlutterSecureStorage _instance = FlutterSecureStorage();
  static Future<String?> getItem(String key) async {
    return await _instance.read(key: key);
  }

  static Future setItem(String key, String? value) async {
    await _instance.write(key: key, value: value);
  }

  static Future deleteItem(String key) async {
    await _instance.delete(key: key);
  }

  static Future clear() async {
    await _instance.deleteAll();
  }
}
