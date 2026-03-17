import 'package:flutter/material.dart';

class Alerts {
  static void showError(context, text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Ошибка'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ок'),
          ),
        ],
      ),
    );
  }
}
