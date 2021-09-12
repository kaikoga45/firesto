import 'package:firesto/utils/define_data_type.dart';

class CustomerReviewResult {
  bool? error;
  String? message;
  List<CustomerReview>? customerReviews;

  CustomerReviewResult({
    this.error,
    this.message,
    this.customerReviews,
  });

  factory CustomerReviewResult.fromJson(Map<String, dynamic> jsonRes) {
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
    return CustomerReviewResult(
      error: asT<bool?>(jsonRes['error']),
      message: asT<String?>(jsonRes['message']),
      customerReviews: customerReviews,
    );
  }
}

class CustomerReview {
  String? name;
  String? review;
  String? date;

  CustomerReview({
    this.name,
    this.review,
    this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> jsonRes) =>
      CustomerReview(
        name: asT<String?>(jsonRes['name']),
        review: asT<String?>(jsonRes['review']),
        date: asT<String?>(jsonRes['date']),
      );
}
