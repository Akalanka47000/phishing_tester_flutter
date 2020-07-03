import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void msgDialog(BuildContext context, String title, String err) {
  if (Platform.isAndroid)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            err,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  else if (Platform.isIOS)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(
            err,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('OK'),
            )
          ],
        );
      },
    );
}