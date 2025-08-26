import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    final prefs = await getPreferences();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await getPreferences();
    return prefs.getString(key);
  }
}
