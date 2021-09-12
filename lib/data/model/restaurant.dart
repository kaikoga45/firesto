import 'package:firesto/data/model/categories.dart';
import 'package:firesto/data/model/customer_review.dart';
import 'package:firesto/data/model/menu.dart';
import 'package:firesto/utils/define_data_type.dart';

class Restaurants {
  String? id;
  String? name;
  String? description;
  String pictureId;
  String? city;
  num? rating;

  Restaurants({
    this.id,
    this.name,
    this.description,
    required this.pictureId,
    this.city,
    this.rating,
  });

  factory Restaurants.fromJson(Map<String, dynamic> jsonRes) => Restaurants(
        id: asT<String?>(jsonRes['id']),
        name: asT<String?>(jsonRes['name']),
        description: asT<String?>(jsonRes['description']),
        pictureId: asT<String>(jsonRes['pictureId']) ?? '',
        city: asT<String?>(jsonRes['city']),
        rating: asT<num?>(jsonRes['rating']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        'city': city,
        'rating': rating,
      };
}

class ListRestaurantResult {
  bool? error;
  String? message;
  int? count;
  List<Restaurants>? restaurants;

  ListRestaurantResult({
    this.error,
    this.message,
    this.count,
    this.restaurants,
  });

  factory ListRestaurantResult.fromJson(Map<String, dynamic> jsonRes) {
    final List<Restaurants>? restaurants =
        jsonRes['restaurants'] is List ? <Restaurants>[] : null;
    if (restaurants != null) {
      for (final dynamic item in jsonRes['restaurants']!) {
        if (item != null) {
          restaurants
              .add(Restaurants.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return ListRestaurantResult(
      error: asT<bool?>(jsonRes['error']),
      message: asT<String?>(jsonRes['message']),
      count: asT<int?>(jsonRes['count']),
      restaurants: restaurants,
    );
  }
}

class DetailRestaurantResult {
  bool? error;
  String? message;
  DetailRestaurant? restaurant;

  DetailRestaurantResult({
    this.error,
    this.message,
    this.restaurant,
  });

  factory DetailRestaurantResult.fromJson(Map<String, dynamic> jsonRes) =>
      DetailRestaurantResult(
        error: asT<bool?>(jsonRes['error']),
        message: asT<String?>(jsonRes['message']),
        restaurant: jsonRes['restaurant'] == null
            ? null
            : DetailRestaurant.fromJson(
                asT<Map<String, dynamic>>(jsonRes['restaurant'])!),
      );
}

class DetailRestaurant {
  String? id;
  String? name;
  String? description;
  String? city;
  String? address;
  String? pictureId;
  List<Categories>? categories;
  Menus? menus;
  num? rating;
  List<CustomerReview>? customerReviews;

  DetailRestaurant({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  },);

  factory DetailRestaurant.fromJson(Map<String, dynamic> jsonRes) {
    final List<Categories>? categories =
        jsonRes['categories'] is List ? <Categories>[] : null;
    if (categories != null) {
      for (final dynamic item in jsonRes['categories']!) {
        if (item != null) {
          categories.add(Categories.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<CustomerReview>? customerReviews =
        jsonRes['customerReviews'] is List ? <CustomerReview>[] : null;
    if (customerReviews != null) {
      for (final dynamic item in jsonRes['customerReviews']!) {
        if (item != null) {
          customerReviews
              .add(CustomerReview.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return DetailRestaurant(
      id: asT<String?>(jsonRes['id']),
      name: asT<String?>(jsonRes['name']),
      description: asT<String?>(jsonRes['description']),
      city: asT<String?>(jsonRes['city']),
      address: asT<String?>(jsonRes['address']),
      pictureId: asT<String?>(jsonRes['pictureId']),
      categories: categories,
      menus: jsonRes['menus'] == null
          ? null
          : Menus.fromJson(asT<Map<String, dynamic>>(jsonRes['menus'])!),
      rating: asT<num?>(jsonRes['rating']),
      customerReviews: customerReviews,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'city': city,
        'address': address,
        'pictureId': pictureId,
        'categories': categories,
        'menus': menus,
        'rating': rating,
        'customerReviews': customerReviews,
      };
}

class SearchRestaurantResult {
  bool? error;
  int? founded;
  List<Restaurants>? restaurants;

  SearchRestaurantResult({
    this.error,
    this.founded,
    this.restaurants,
  });

  factory SearchRestaurantResult.fromJson(Map<String, dynamic> jsonRes) {
    final List<Restaurants>? restaurants =
        jsonRes['restaurants'] is List ? <Restaurants>[] : null;
    if (restaurants != null) {
      for (final dynamic item in jsonRes['restaurants']!) {
        if (item != null) {
          restaurants
              .add(Restaurants.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return SearchRestaurantResult(
      error: asT<bool?>(jsonRes['error']),
      founded: asT<int?>(jsonRes['founded']),
      restaurants: restaurants,
    );
  }
}

List<Restaurants>? parseRestaurants(Map<String, dynamic>? jsonData) {
  if (jsonData == null) {
    return <Restaurants>[];
  }
  return ListRestaurantResult.fromJson(jsonData).restaurants;
}
