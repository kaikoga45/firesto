import 'dart:isolate';
import 'dart:math';

import 'dart:ui';

import 'package:firesto/data/api/api_service.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:firesto/main.dart';
import 'package:firesto/utils/notification_helper.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  BackgroundService._internal() {
    _instance = this;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationHelper _notificationHelper = NotificationHelper();

    final ListRestaurantResult listRestaurantResult =
        await ApiService(http.Client()).getListRestaurant();
    final Restaurants restaurantReccomendation =
        listRestaurantResult.restaurants![
            Random().nextInt(listRestaurantResult.restaurants!.length)];

    await _notificationHelper.showNotification(
      flutterLocalNotificationsPlugin,
      restaurantReccomendation,
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
