import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firesto/utils/background_service.dart';
import 'package:firesto/utils/date_time_helper.dart';

import 'package:flutter/material.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRecommendation({required bool value}) async {
    _isScheduled = value;
    if (_isScheduled) {
      notifyListeners();
      return AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return AndroidAlarmManager.cancel(1);
    }
  }
}
