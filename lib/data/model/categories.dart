import 'package:firesto/utils/define_data_type.dart';

class Categories {
  String? name;

  Categories({
    this.name,
  });

  factory Categories.fromJson(Map<String, dynamic> jsonRes) => Categories(
        name: asT<String?>(jsonRes['name']),
      );
}
