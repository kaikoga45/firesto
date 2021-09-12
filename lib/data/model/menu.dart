import 'package:firesto/data/model/sustenance.dart';
import 'package:firesto/utils/define_data_type.dart';

class Menus {
  List<Sustenance>? foods;
  List<Sustenance>? drinks;

  Menus({
    this.foods,
    this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> jsonRes) {
    final List<Sustenance>? foods =
        jsonRes['foods'] is List ? <Sustenance>[] : null;
    if (foods != null) {
      for (final dynamic item in jsonRes['foods']!) {
        if (item != null) {
          foods.add(Sustenance.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Sustenance>? drinks =
        jsonRes['drinks'] is List ? <Sustenance>[] : null;
    if (drinks != null) {
      for (final dynamic item in jsonRes['drinks']!) {
        if (item != null) {
          drinks.add(Sustenance.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Menus(
      foods: foods,
      drinks: drinks,
    );
  }
}
