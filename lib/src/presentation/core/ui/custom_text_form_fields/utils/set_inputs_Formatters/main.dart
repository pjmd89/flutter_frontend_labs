import 'package:flutter/services.dart';

List<TextInputFormatter> setTextInputFormatters({List<TextInputFormatter> userTextFormatters = const []}) {
  if (userTextFormatters.isEmpty) {
    userTextFormatters = [];
  }
  List<TextInputFormatter> otherFormatters = [
    FilteringTextInputFormatter.deny(RegExp(r'\^')),
    FilteringTextInputFormatter.deny(RegExp(r'\[')),
    FilteringTextInputFormatter.deny(RegExp(r'\]')),
    FilteringTextInputFormatter.deny(RegExp(r'\\')),
    FilteringTextInputFormatter.deny(RegExp(r'\<')),
    FilteringTextInputFormatter.deny(RegExp(r'\>')),
  ];
  userTextFormatters.addAll(otherFormatters);
  return userTextFormatters;
}


FilteringTextInputFormatter onlyNumbersFormatter = FilteringTextInputFormatter.allow(RegExp(r"[0-9]"));
FilteringTextInputFormatter specialNamesFormatter = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-z0-9., ´ñáéíóúÁÉÍÓÚ-]"));
FilteringTextInputFormatter normalNamesFormatter = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-z0-9 ´ñáéíóúÁÉÍÓÚ]"));
FilteringTextInputFormatter peopleNameFormatter = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-z ´ñÑáéíóúÁÉÍÓÚ]"));
FilteringTextInputFormatter emailFormatter = FilteringTextInputFormatter.allow(RegExp(r"^([\w\.]+)@(\w+)\.(.*)$"));