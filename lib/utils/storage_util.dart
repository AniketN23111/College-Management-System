import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil storageInstance = StorageUtil._instance();
  static SharedPreferences? _preferences;

  StorageUtil._instance() {
    getPreferences();
  }
  void getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? getPrefs(String key) {
    return _preferences?.getString(key) ?? '';
  }

  clearPrefs() {
    _preferences!.clear();
  }

  deletePrefs(String key) {
    _preferences?.remove(key);
  }

  addStringtoSF(String key, String value) async {
    print(' inside sharedPreferences file $key $value'); // Receives data here
    await _preferences!.setString(key, value);
  }
}
