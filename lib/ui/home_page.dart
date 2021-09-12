import 'dart:io';

import 'package:firesto/ui/detail_page.dart';
import 'package:firesto/ui/favorite_page.dart';
import 'package:firesto/ui/list_restaurant_page.dart';
import 'package:firesto/ui/settings_page.dart';
import 'package:firesto/utils/notification_helper.dart';
import 'package:firesto/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<Widget> _listWidget = <Widget>[
    const ListRestaurantPage(),
    const FavoritePage(),
    SettingsPage()
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItem =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.home : Icons.home_filled,
      ),
      label: 'Beranda',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.square_favorites : Icons.favorite,
      ),
      label: 'Favorit',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.settings : Icons.settings,
      ),
      label: 'Pengaturan',
    ),
  ];

  Widget androidBuilder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (int index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        items: _bottomNavBarItem,
      ),
    );
  }

  Widget iosBuilder(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: _bottomNavBarItem),
      tabBuilder: (BuildContext context, int index) {
        return _listWidget[index];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(DetailPage.id);
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: androidBuilder,
      iosBuilder: iosBuilder,
    );
  }
}
