import 'dart:io';

import 'package:firesto/provider/preferences_provider.dart';
import 'package:firesto/provider/scheduling_provider.dart';
import 'package:firesto/widgets/alert_dialog.dart';
import 'package:firesto/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Pengaturan'),
      ),
      child: _buildBody(context),
    );
  }

  SafeArea _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<PreferencesProvider>(
          builder: (BuildContext context,
              PreferencesProvider preferencesProvider, Widget? _) {
            return ListView(
              children: <Widget>[
                Material(
                  child: ListTile(
                    title: const Text('Tema Hitam'),
                    trailing: Switch.adaptive(
                      value: preferencesProvider.isDarkTheme,
                      onChanged: (bool value) {
                        preferencesProvider.enableDarkTheme(value: value);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Material(
                  child: ListTile(
                    title: const Text('Rekomendasi Restoran Harian'),
                    trailing: Consumer<SchedulingProvider>(
                      builder: (BuildContext context,
                          SchedulingProvider scheduled, _) {
                        return Switch.adaptive(
                          value:
                              preferencesProvider.isDailyRecommendationActive,
                          onChanged: (bool value) async {
                            if (Platform.isIOS) {
                              alertDialog(context);
                            } else {
                              scheduled.scheduledRecommendation(value: value);
                              preferencesProvider.enableDailyRecommendation(
                                value: value,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
