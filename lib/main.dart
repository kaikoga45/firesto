import 'dart:io';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firesto/common/navigation.dart';
import 'package:firesto/data/api/api_service.dart';
import 'package:firesto/data/db/database_helper.dart';
import 'package:firesto/data/preferences/preferences_helper.dart';
import 'package:firesto/provider/database_provider.dart';
import 'package:firesto/provider/detail_restaurant_provider.dart';
import 'package:firesto/provider/internet_connection_provider.dart';
import 'package:firesto/provider/preferences_provider.dart';
import 'package:firesto/provider/scheduling_provider.dart';
import 'package:firesto/provider/search_restaurant_provider.dart';
import 'package:firesto/provider/list_restaurant_provider.dart';
import 'package:firesto/ui/detail_page.dart';
import 'package:firesto/ui/home_page.dart';
import 'package:firesto/ui/search_page.dart';
import 'package:firesto/ui/splash_page.dart';
import 'package:firesto/utils/background_service.dart';
import 'package:firesto/utils/internet_connection_helper.dart';
import 'package:firesto/utils/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _backgroundService = BackgroundService();

  _backgroundService.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const Firesto());
}

class Firesto extends StatelessWidget {
  const Firesto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ListRestaurantProvider>(
          create: (BuildContext context) => ListRestaurantProvider(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider()),
        ChangeNotifierProvider<PreferencesProvider>(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider<DetailRestaurantProvider>(
          create: (BuildContext context) => DetailRestaurantProvider(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider<SearchRestaurantProvider>(
          create: (BuildContext context) => SearchRestaurantProvider(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (BuildContext context) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider<InternetConnectionProvider>(
          create: (BuildContext context) => InternetConnectionProvider(
              internetConnectionHelper: InternetConnectionHelper()),
        ),
      ],
      child: Consumer<PreferencesProvider>(builder: (BuildContext context,
          PreferencesProvider preferencesProvider, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: preferencesProvider.themeData,
          builder: (BuildContext context, Widget? child) {
            return CupertinoTheme(
              data: CupertinoThemeData(
                brightness: preferencesProvider.isDarkTheme
                    ? Brightness.dark
                    : Brightness.light,
              ),
              child: Material(
                child: child,
              ),
            );
          },
          initialRoute: SplashPage.id,
          routes: <String, Widget Function(BuildContext)>{
            SplashPage.id: (BuildContext context) => const SplashPage(),
            HomePage.id: (BuildContext context) => const HomePage(),
            DetailPage.id: (BuildContext context) => DetailPage(
                  restaurantId:
                      ModalRoute.of(context)!.settings.arguments as String,
                ),
            SearchPage.id: (BuildContext context) => const SearchPage(),
          },
        );
      }),
    );
  }
}
