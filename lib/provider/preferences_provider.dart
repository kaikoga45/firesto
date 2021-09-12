import 'package:firesto/common/styles.dart';
import 'package:firesto/data/preferences/preferences_helper.dart';
import 'package:flutter/material.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    _getDailyRecommendationPreferences();
  }

  bool _isDarkTheme = false;
  bool _isDailyRecommendationActive = false;

  bool get isDarkTheme => _isDarkTheme;
  bool get isDailyRecommendationActive => _isDailyRecommendationActive;
  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  Future<void> _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  Future<void> _getDailyRecommendationPreferences() async {
    _isDailyRecommendationActive =
        await preferencesHelper.isDailyRecommendationActive;
    notifyListeners();
  }

  void enableDarkTheme({required bool value}) {
    preferencesHelper.setDarkTheme(value: value);
    _getTheme();
  }

  void enableDailyRecommendation({required bool value}) {
    preferencesHelper.setDailyRecommendation(value: value);
    _getDailyRecommendationPreferences();
  }
}
