import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DisplayInfo extends StatelessWidget {
  final TextTheme textTheme;
  final String lottiePath;
  final String title;
  final String description;

  const DisplayInfo({
    Key? key,
    required this.textTheme,
    required this.lottiePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Lottie.asset(lottiePath),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headline5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyText2,
          ),
        ),
      ],
    );
  }
}
