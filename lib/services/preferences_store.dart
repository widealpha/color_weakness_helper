import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesStore {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);
}

class SharedPreferencesStore implements PreferencesStore {
  const SharedPreferencesStore();

  SharedPreferencesAsync get _preferences => SharedPreferencesAsync();

  @override
  Future<String?> getString(String key) {
    return _preferences.getString(key);
  }

  @override
  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  @override
  Future<void> remove(String key) {
    return _preferences.remove(key);
  }
}
