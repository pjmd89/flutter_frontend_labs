import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/set_inputs_Formatters/main.dart';

class CustomTextFormField extends StatefulWidget { 
  final bool isEnabled;
  final double? width;
  final String? initialValue;
  final TextEditingController? controller;
  final String? labelText;
  final bool isDense;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? prefix;
  final void Function(String)? onChange;
  final TextInputType? type;
  final int fieldLength;
  final String? Function(String?)? validator;
  final List<FilteringTextInputFormatter> inputFormatters;
  final Widget? suffixIcon;
  final bool canRequestFocus;
  final int? maxLines;
  final VoidCallback? onTap;
  final String? counterText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final bool obscureText;
  
  const CustomTextFormField({
    super.key,
    this.labelText,
    this.controller,
    this.width,
    required this.isDense,
    this.readOnly = false,
    this.prefixIcon,
    this.onChange, 
    this.initialValue, 
    this.type, 
    required this.fieldLength, 
    this.validator, 
    this.inputFormatters = const [], 
    this.suffixIcon, 
    this.canRequestFocus = true, 
    this.isEnabled = true, 
    this.maxLines, 
    this.onTap, 
    this.counterText = "",
    this.floatingLabelBehavior, 
    this.focusNode, 
    this.prefix, 
    this.contentPadding,
    this.obscureText = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  
  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters = [];
    if (widget.inputFormatters.isNotEmpty) {
      inputFormatters.addAll(widget.inputFormatters);
    }
    return TextFormField(
      focusNode: widget.focusNode,
      keyboardType: widget.type,
      enabled: widget.isEnabled,
      canRequestFocus: widget.canRequestFocus,
      initialValue: widget.initialValue,
      readOnly: widget.readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: widget.maxLines,
      controller: widget.controller,
      maxLength: widget.fieldLength,
      inputFormatters: setTextInputFormatters(
        userTextFormatters: inputFormatters
      ),
      onChanged: (value) {
        if(widget.onChange != null) widget.onChange!(value);
      },
      decoration: InputDecoration(
        helperText: "",
        isDense: widget.isDense,
        labelText: widget.labelText,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(3))
        ),
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        counterText: widget.counterText ?? "",
        contentPadding: widget.contentPadding, // Use the contentPadding parameter from the widget
      ),
      validator: widget.validator,
      onTap: widget.onTap,
      obscureText: widget.obscureText,
    );
  }
}