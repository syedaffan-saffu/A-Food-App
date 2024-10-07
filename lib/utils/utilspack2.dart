import 'package:flutter/material.dart';

class UtilsPack2 {
  static SnackBar snackBar(String title, int duration) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.info,
            color: Color(0xFFF6AA21),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      duration: Duration(seconds: duration),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      backgroundColor: const Color(0xFFE83636),
    );
  }
}
