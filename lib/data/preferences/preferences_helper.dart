import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const String kDarkTheme = 'DARK_THEME';
  static const String kDailyRecommendation = 'DAILY_RECOMMENDATION';

  Future<bool> get isDarkTheme async {
    final SharedPreferences prefs = await sharedPreferences;
    return prefs.getBool(kDarkTheme) ?? false;
  }

  Future<void> setDarkTheme({required bool value}) async {
    final SharedPreferences prefs = await sharedPreferences;
    prefs.setBool(kDarkTheme, value);
  }

  Future<bool> get isDailyRecommendationActive async {
    final SharedPreferences prefs = await sharedPreferences;
    return prefs.getBool(kDailyRecommendation) ?? false;
  }

  Future<void> setDailyRecommendation({required bool value}) async {
    final SharedPreferences prefs = await sharedPreferences;
    prefs.setBool(kDailyRecommendation, value);
  }
}
