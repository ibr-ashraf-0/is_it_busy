import 'package:flutter/material.dart';

mixin Helpers {
  showSnackBar({
    required BuildContext context,
    required String message,
    bool error = false,
    num time = 1,
    margin,
    textAlign,
    width,
    shape,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: textAlign,
        ),
        width: double.parse('$width'),
        shape: shape,
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: margin,
        duration: Duration(seconds: int.parse('$time')),
      ),
    );
  }
}
