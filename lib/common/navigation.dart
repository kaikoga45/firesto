import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static void intentWithData(String routeName, String arguments) =>
      navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);

  static void back() => navigatorKey.currentState?.pop();
}
