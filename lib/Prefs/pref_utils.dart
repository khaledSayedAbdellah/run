import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils{

  static Future<SharedPreferences> getSharedPref() async{
    return await SharedPreferences.getInstance();
  }

  static Future clearSharedPref() async{
    return (await getSharedPref()).clear();
  }

  static Future<bool> setString(String key, String data) async {
    return (await getSharedPref()).setString(key, data ?? "");
  }

  static Future<String> getString(String key) async {
    return (await getSharedPref()).getString(key) ?? "";
  }

  static Future<bool> setBool(String key, bool data) async {
    return (await getSharedPref()).setBool(key, data);
  }

  static Future<bool> getBool(String key) async {
    var result = (await getSharedPref()).getBool(key);
    if (result != null)
      return result;
    else
      return false;
  }

}