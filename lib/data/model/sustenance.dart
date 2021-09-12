import 'package:firesto/utils/define_data_type.dart';

class Sustenance {
  String? name;

  Sustenance({
    this.name,
  });

  factory Sustenance.fromJson(Map<String, dynamic> jsonRes) => Sustenance(
        name: asT<String?>(jsonRes['name']),
      );
}
