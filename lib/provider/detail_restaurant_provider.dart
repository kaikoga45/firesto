import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/data/api/api_service.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:flutter/material.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  late ApiService apiService;
  late String restaurantId;
  String _message = '';

  late ResultState _state;
  late DetailRestaurant _result;

  String get message => _message;
  ResultState get state => _state;
  DetailRestaurant get result => _result;

  DetailRestaurantProvider({required this.apiService}) {
    _state = ResultState.standBy;
  }

  Future<dynamic> fetchDetailRestaurant({required String id}) async {
    try {
      _state = ResultState.loading;
      final DetailRestaurantResult detailRestaurant =
          await apiService.getDetailRestaurant(id);
      if (detailRestaurant.restaurant == null) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Ooopss!';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = detailRestaurant.restaurant!;
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
