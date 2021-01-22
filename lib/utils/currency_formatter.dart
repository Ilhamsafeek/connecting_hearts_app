
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('$value'));

    return newValue.copyWith(
        text: formattedAmount.output.withoutFractionDigits,
        selection: new TextSelection.collapsed(
            offset: formattedAmount.output.withoutFractionDigits.length));
  }
}
