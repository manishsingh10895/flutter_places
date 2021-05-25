import 'package:flutter/material.dart';

class Messenger {
  static void showSimpleMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
