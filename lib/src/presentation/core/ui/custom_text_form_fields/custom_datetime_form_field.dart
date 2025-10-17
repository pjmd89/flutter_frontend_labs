import 'package:flutter/material.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/custom_text_form_field.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/date_format/main.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/form_field_length/main.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/datetime_picker/main.dart';
import 'package:intl/intl.dart';

class CustomDateTimeFormField extends StatefulWidget {
  final DateTime initialDate;
  final DateTime currentDate;
  final void Function(DateTime?) onChange;
  const CustomDateTimeFormField({
    super.key, 
    required this.initialDate, 
    required this.currentDate, 
    required this.onChange
  });

  @override
  State<CustomDateTimeFormField> createState() => _CustomDateTimeFormFieldState();
}

class _CustomDateTimeFormFieldState extends State<CustomDateTimeFormField> {
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      fieldLength: FormFieldLength.description,
      readOnly: true,
      controller: TextEditingController(text: DateFormat(dateTimeFormat).format(widget.initialDate)),
      prefixIcon: const Icon(Icons.edit_calendar),
      isDense: true,
      labelText: AppLocalizations.of(context)!.date,
      onTap: () async {
        final DateTime? pickedDateTime = await showDateTimePicker(
          context, 
          widget.initialDate,
          widget.currentDate
        );
        widget.onChange(pickedDateTime);
      }
    );
  }
}

