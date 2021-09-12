import 'dart:async';

import 'package:firesto/ui/home_page.dart';
import 'package:firesto/widgets/display_info.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const String id = '/splash_screen';

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(
          context,
          HomePage.id,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DisplayInfo(
          textTheme: Theme.of(context).textTheme,
          lottiePath: 'assets/lottie/store-location.json',
          title: 'Firesto',
          description:
              'Tempat dimana anda bisa menemukan restoran yang terdekat dengan anda!',
        ),
      ),
    );
  }
}
