import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/data/api/api_service.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:flutter/material.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  late ApiService apiService;
  String _message = '';
  late ResultState _state;
  late SearchRestaurantResult _result;

  String get message => _message;
  ResultState get state => _state;
  SearchRestaurantResult get result => _result;

  SearchRestaurantProvider({required this.apiService}) {
    _state = ResultState.standBy;
  }

  Future<dynamic> fetchSearchRestaurant(String query) async {
    if (query.isEmpty) {
      _state = ResultState.standBy;
      notifyListeners();
    } else {
      try {
        _state = ResultState.loading;
        notifyListeners();
        final SearchRestaurantResult searchRestaurant =
            await apiService.getSearchRestaurant(query);
        if (searchRestaurant.founded == 0) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'Firesto tidak menemukan yang kamu carikan!';
        } else {
          _state = ResultState.hasData;
          notifyListeners();
          return _result = searchRestaurant;
        }
      } catch (e) {
        if (e is SocketException) {
          _state = ResultState.noInternet;
          notifyListeners();
          return _message = 'Tolong pastikan anda mempunyai koneksi internet!';
        } else {
          _state = ResultState.error;
          notifyListeners();
          return _message = 'Error : $e';
        }
      }
    }
  }
}
