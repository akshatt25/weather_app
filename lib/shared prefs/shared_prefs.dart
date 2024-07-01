import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _key = 'city';

  Future<void> saveString(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }

  Future<String?> getString() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
