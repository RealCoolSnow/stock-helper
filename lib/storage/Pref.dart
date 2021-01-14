/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 12:15:54
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:58:11
 */
import 'package:shared_preferences/shared_preferences.dart';

/// Usage:
///
/// Pref.setString(PrefKey.launchTime, TimeUtil.format(DateTime.now()));
///
/// Pref.getString(PrefKey.launchTime).then((value) => print('launch time: $value'));
///

class Pref {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<bool> containsKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key);
  }

  static Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(key, value);
  }

  static Future<String> getString(String key, String def) async {
    final SharedPreferences prefs = await _prefs;
    String v = prefs.getString(key);
    return v == null ? def : v;
  }

  static Future<bool> setBool(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key, bool def) async {
    final SharedPreferences prefs = await _prefs;
    bool v = prefs.getBool(key);
    return v == null ? def : v;
  }

  static Future<bool> setInt(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setInt(key, value);
  }

  static Future<int> getInt(String key, int def) async {
    final SharedPreferences prefs = await _prefs;
    int v = prefs.getInt(key);
    return v == null ? def : v;
  }

  static Future<bool> setDouble(String key, double value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setDouble(key, value);
  }

  static Future<double> getDouble(String key, double def) async {
    final SharedPreferences prefs = await _prefs;
    double v = prefs.getDouble(key);
    return v == null ? def : v;
  }
}
