import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  static const String monthId = "MONTH-ID";
  static const String split = "SPLIT-TYPE";
  static const String todayTitleId = "TODAY-TITLE-ID";
  static const String lastStreakCount = "STREAK-COUNT";

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<bool?> putString(String key, String value) async {
    return _preferences?.setString(key, value);
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences == null ? defValue : _preferences!.getString(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    return _preferences?.setInt(key, value);
  }

  int? getInt(String key, {int defValue = 0}) {
    return _preferences == null ? defValue : _preferences!.getInt(key) ?? defValue;
  }
}
