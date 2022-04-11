import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showAlertDialog({
  @required BuildContext? context,
  @required String? title,
  @required String? content,
  @required String? defaultActionText,
}) async {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context!,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title!),
              content: Text(content!),
              actions: [
                CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(defaultActionText!))
              ],
            ));
  }
  if (Platform.isAndroid) {
    return await showDialog(
        context: context!,
        builder: (context) => AlertDialog(
              title: Text(title!),
              content: Text(content!),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(defaultActionText!))
              ],
            ));
  }
}
