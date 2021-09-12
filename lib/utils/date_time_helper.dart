import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime format() {
    final DateTime now = DateTime.now();
    final DateFormat dateFormat = DateFormat('y/M/d');
    const String timeSpecific = "11:00:00";
    final DateFormat completeFormat = DateFormat('y/M/d H:m:s');

    final String todayDate = dateFormat.format(now);
    final String todayDateAndTime = "$todayDate $timeSpecific";
    final DateTime resultToday = completeFormat.parseStrict(todayDateAndTime);

    final DateTime formatted = resultToday.add(const Duration(days: 1));
    final String tomorrowDate = dateFormat.format(formatted);
    final String tomorrowDateAndTime = "$tomorrowDate $timeSpecific";
    final DateTime resultTomorrow =
        completeFormat.parseStrict(tomorrowDateAndTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}
