// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';


Future<DateTime?> showDateTimePicker(BuildContext context, DateTime initialDate, DateTime currentDate, {String? locale}) async {
  await Future.delayed(const Duration(milliseconds: 100));

  final DateTime? pickedDate = await showDatePicker(
    locale: locale != null ? Locale(locale) : null,
    context: context,
    fieldHintText: "",
    fieldLabelText: "",
    helpText: "",
    barrierLabel: "",
    confirmText: AppLocalizations.of(context)!.confirm,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    initialDate: initialDate,
    currentDate: currentDate,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );

  if (pickedDate != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      return DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
    }
  }
  return null;
}