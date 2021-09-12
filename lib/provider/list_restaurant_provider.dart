import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/data/api/api_service.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:flutter/material.dart';

class ListRestaurantProvider extends ChangeNotifier {
  late ApiService apiService;
  String _message = '';
  late ResultState _state;
  late ListRestaurantResult _result;

  String get message => _message;
  ResultState get state => _state;
  ListRestaurantResult get result => _result;

  ListRestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final ListRestaurantResult listRestaurant =
          await apiService.getListRestaurant();
      if (listRestaurant.restaurants!.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = listRestaurant.message ?? 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = listRestaurant;
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
