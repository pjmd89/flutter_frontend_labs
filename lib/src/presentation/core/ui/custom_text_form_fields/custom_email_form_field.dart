import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/form_field_length/main.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/format_validator/main.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/set_inputs_Formatters/main.dart';

class CustomTextFormFieldPersonalEmail extends StatefulWidget { 
  final double? width;
  final TextEditingController controller;
  final String? labelText;
  final bool isDense;
  final bool readOnly;

  const CustomTextFormFieldPersonalEmail(
    {
      super.key,
      this.labelText,
      required this.controller,
      this.width,
      required this.isDense,
      this.readOnly = false
    }
  );

  @override
  State<CustomTextFormFieldPersonalEmail> createState() => _CustomTextFormFieldPersonalEmailState();
}

class _CustomTextFormFieldPersonalEmailState extends State<CustomTextFormFieldPersonalEmail> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        readOnly: widget.readOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        inputFormatters: setTextInputFormatters(
          userTextFormatters: [
            LengthLimitingTextInputFormatter(FormFieldLength.email)
          ]
        ),
        decoration: InputDecoration(
          helperText: "",
          isDense: widget.isDense,
          focusColor: Colors.blue[700],
          labelText: widget.labelText,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return FormatValidator.validateFieldIsNotEmpty(context, value);
          }
          return FormatValidator.validateUserEmail(context, value);
        },
      ),
    );
  }
}