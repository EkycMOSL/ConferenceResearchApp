import 'package:flutter/services.dart';

class MaxValueFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final intValue = int.tryParse(newValue.text) ?? 0;

    if (intValue > 100) {
      return oldValue;      // ❌ block typing more than 100
    }

    return newValue;         // ✔ allow valid value
  }
}