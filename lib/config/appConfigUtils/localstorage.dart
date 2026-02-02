import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _storageUtil;
  static SharedPreferences? _preferences;

  static Future<LocalStorage?> getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = LocalStorage._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  LocalStorage._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future clearPreference() async {
    if (_preferences != null) {
      await _preferences!.clear();
    }
  }

  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(key) ?? defValue;
  }

  static bool getBool(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences!.getBool(key) ?? defValue;
  }

  static List<String> getListString(
      String key,
      ) {
    if (_preferences == null) return [];
    return _preferences!.getStringList(key) ?? [];
  }

  static Future<bool>? putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, value);
  }

  static Future<bool>? putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences!.setBool(key, value);
  }

  static Future<bool>? putListString(String key, List<String> value) {
    if (_preferences == null) return null;
    return _preferences!.setStringList(key, value);
  }

  static Future<bool>? removeString(String key) {
    if (_preferences == null) return null;
    return _preferences!.remove(key);
  }
}