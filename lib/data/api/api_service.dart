import 'dart:convert';
import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/data/model/customer_review.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String _apiKey = '12345';
  static const String _list = '/list';
  static const String _detail = '/detail/';
  static const String _search = '/search?q=';
  static const String _review = '/review';

  late final http.Client client;

  ApiService(this.client);

  Future<ListRestaurantResult> getListRestaurant() async {
    final response = await _getResponse(type: _list);
    if (response.statusCode == 200) {
      return ListRestaurantResult.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load list of restaurant. Try again later!');
    }
  }

  Future<SearchRestaurantResult> getSearchRestaurant(String query) async {
    final http.Response response =
        await _getResponse(type: _search, query: query);
    if (response.statusCode == 200) {
      return SearchRestaurantResult.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to search restaurant. Try again later!');
    }
  }

  Future<DetailRestaurantResult> getDetailRestaurant(String id) async {
    final http.Response response = await _getResponse(type: _detail, query: id);
    if (response.statusCode == 200) {
      return DetailRestaurantResult.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to get detail restaurant. Try again later!');
    }
  }

  Future<CustomerReviewResult> postRestaurantReview(
      {required String id, required String review}) async {
    final Uri url = Uri.parse(_baseUrl + _review);
    try {
      final http.Response response = await client.post(
        url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: _apiKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'id': id,
            'name': kUserName,
            'review': review,
          },
        ),
      );
      if (response.statusCode == 200) {
        return CustomerReviewResult.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to post user restaurant review');
      }
    } catch (e) {
      throw Exception('Error : $e');
    }
  }

  Future<http.Response> _getResponse(
      {required String type, String? query}) async {
    final Uri url;
    if (query == null) {
      url = Uri.parse(_baseUrl + type);
    } else {
      url = Uri.parse(_baseUrl + type + query);
    }
    final http.Response response = await client.get(url);
    return response;
  }
}
