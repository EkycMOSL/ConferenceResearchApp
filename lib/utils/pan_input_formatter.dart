import 'package:flutter/services.dart';

class PANInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text.toUpperCase();

    // Remove any invalid characters
    text = text.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Limit to 10 characters
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    // Apply PAN format: AAAAA9999A
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i < 5) {
        // First 5 positions: only letters
        if (RegExp(r'[A-Z]').hasMatch(text[i])) {
          formatted += text[i];
        }
      } else if (i < 9) {
        // Next 4 positions: only numbers
        if (RegExp(r'[0-9]').hasMatch(text[i])) {
          formatted += text[i];
        }
      } else {
        // Last position: only letter
        if (RegExp(r'[A-Z]').hasMatch(text[i])) {
          formatted += text[i];
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
