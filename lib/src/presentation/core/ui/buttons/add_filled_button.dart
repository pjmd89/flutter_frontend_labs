import 'package:flutter/material.dart';
import 'package:labs/src/presentation/core/ui/buttons/widgets/button_text.dart';

class AddFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AddFilledButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: ButtonText(text: label),
    );
  }
}