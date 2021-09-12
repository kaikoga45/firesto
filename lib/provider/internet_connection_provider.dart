import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/utils/internet_connection_helper.dart';
import 'package:flutter/material.dart';

class InternetConnectionProvider extends ChangeNotifier {
  late InternetConnectionHelper internetConnectionHelper;
  String _message = '';
  late ResultState _state;

  String get message => _message;
  ResultState get state => _state;

  InternetConnectionProvider({required this.internetConnectionHelper}) {
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final List<InternetAddress> result =
          await internetConnectionHelper.tryInternetConnection();
      if (result.isEmpty) {
        _state = ResultState.noInternet;
        notifyListeners();
        _message = 'Tolong pastikan anda mempunyai koneksi internet!';
      } else {
        _state = ResultState.hasInternet;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      _message = 'Error : $e';
    }
  }
}
