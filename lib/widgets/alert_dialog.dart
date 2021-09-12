import 'package:firesto/common/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void alertDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Segera akan mendatang!'),
        content: const Text('Saat ini fitur ini tidak tersedia untuk iOS!'),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigation.back();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
