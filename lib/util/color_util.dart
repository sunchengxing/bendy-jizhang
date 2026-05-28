import 'package:flutter/material.dart';

class ColorUtil {
  static Color fromHex(String hexString) {
    final hex = hexString.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  static String toHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}
