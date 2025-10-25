import 'package:flutter/material.dart';

class ContentDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool loading;
  final Form form;
  final List<Widget>? actions;
  final double? maxWidth;
  final double? minWidth;

  const ContentDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.loading,
    required this.form,
    this.actions,
    this.maxWidth,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
      content:
          loading
              ? SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
              : ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? 300,
                  minWidth: minWidth ?? 300,
                ),
                child: form,
              ),
      actions: [
        AbsorbPointer(
          absorbing: loading,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions ?? [],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
    );
  }
}
